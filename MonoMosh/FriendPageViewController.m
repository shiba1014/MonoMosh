//
//  FriendPageViewController.m
//  MonoMosh
//
//  Created by Paul McCartney on 2016/02/07.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import "FriendPageViewController.h"
#import "MMCollectionReusableView.h"
#import "MMCollectionViewCell.h"
#import "DetailViewController.h"
#import "FriendListViewController.h"
#import "MBProgressHUD.h"

static NSString *headerIdentifier = @"MMCollectionHeader";
static NSString *cellIdentifier = @"MMCollectionViewCell";

@interface FriendPageViewController ()


@end

@implementation FriendPageViewController

@synthesize profileImage,username,friendUserId,friendUsername,friendUser;

//static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MMCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MMCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];

    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    [self loadMono];
    
    if(!friendUser)
        [self getUser];
    else
        self.title = username;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadMono{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"PostObject"];
    query.limit = 10;
    [query whereKey:@"postUser" equalTo:friendUser];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(!error){
            for(PFObject *object in objects){
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                dic[@"postName"] = object[@"postName"];
                dic[@"postDiscription"] = object[@"postDiscription"];
                PFUser *postUser = object[@"postUser"];
                dic[@"postUserId"] = postUser.objectId;
                dic[@"postId"] = object.objectId;
                dic[@"postDiscription"] = object[@"postDiscription"];
                [monoArray addObject:dic];
                PFFile *imageFile = object[@"postPhoto"];
                [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                    if(!error){
                        UIImage *postPhoto = [UIImage imageWithData:data];
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"postId == %@",object.objectId];
                        NSMutableDictionary *dic = [[[monoArray filteredArrayUsingPredicate:predicate] firstObject] mutableCopy];
                        NSUInteger index = [monoArray indexOfObject:dic];
                        dic[@"postPhoto"] = postPhoto;
                        monoArray[index] = dic;
                        [self.collectionView reloadData];
                    }
                }];
                [self.collectionView reloadData];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
        }else{
            NSLog(@"Error:%@",error);
        }
    }];
}

-(void)loadOldMono{
    PFQuery *query = [PFQuery queryWithClassName:@"PostObject"];
    query.limit = 10;
    query.skip = monoArray.count;
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"postUser" equalTo:friendUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        indicator.hidden = YES;
        if(!error){
            if(objects.count == 0){
                moreButton.hidden = YES;
                return;
            }
            for(PFObject *object in objects){
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                dic[@"postName"] = object[@"postName"];
                dic[@"postDiscription"] = object[@"postDiscription"];
                PFUser *postUser = object[@"postUser"];
                dic[@"postUserId"] = postUser.objectId;
                dic[@"postId"] = object.objectId;
                dic[@"postDiscription"] = object[@"postDiscription"];
                [monoArray addObject:dic];
                PFFile *imageFile = object[@"postPhoto"];
                [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                    if(!error){
                        UIImage *postPhoto = [UIImage imageWithData:data];
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"postId == %@",object.objectId];
                        NSMutableDictionary *dic = [[[monoArray filteredArrayUsingPredicate:predicate] firstObject] mutableCopy];
                        NSUInteger index = [monoArray indexOfObject:dic];
                        dic[@"postPhoto"] = postPhoto;
                        monoArray[index] = dic;
                        [self.collectionView reloadData];
                    }
                }];
            }
            [self.collectionView reloadData];
        }else{
            NSLog(@"Errpr:%@",error);
        }
        moreButton.hidden = NO;
    }];
}


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    
    if(kind == UICollectionElementKindSectionHeader){
        MMCollectionReusableView *header = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        [header.friendNumButton addTarget:self action:@selector(moveToFriendList) forControlEvents:UIControlEventTouchUpInside];
        header.profileImage = profileImage;
        header.username = username;
        [header setHeader];
        return header;
    }
    if (kind == UICollectionElementKindSectionFooter){
        reusableView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer" forIndexPath:indexPath];
        
        moreButton = (UIButton *)[reusableView viewWithTag:100];
        [moreButton addTarget:self action:@selector(loadMore) forControlEvents:UIControlEventTouchUpInside];
        
        indicator = (UIActivityIndicatorView *)[reusableView viewWithTag:200];
        indicator.hidden = YES;
    }
    
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width * 0.3);
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 17;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MMCollectionViewCell *cell = (MMCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor orangeColor];
    cell.shadowImage.hidden = YES;
    cell.monoName.hidden = YES;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width = (self.collectionView.frame.size.width-20)/3;
    float height = width;
    return CGSizeMake(width, height);
}

// 垂直方向のセル間のマージンの最小値を返却する
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

// 水平方向のセル間のマージンの最小値を返却する
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    NSDictionary *dic = monoArray[indexPath.row];
    detailVC.postPhoto = dic[@"postPhoto"];
    detailVC.postName = dic[@"postName"];
    detailVC.postDiscription = dic[@"postDiscription"];
    detailVC.postId = dic[@"postId"];
    detailVC.postUserId = dic[@"postUserId"];
    detailVC.postUsername = username;
    detailVC.profileImage = profileImage;
    [self.navigationController pushViewController:detailVC animated:YES];
}
-(void)loadMore{
    moreButton.hidden = YES;
    indicator.hidden = NO;
    [indicator startAnimating];
    [self loadOldMono];
}

-(void)moveToFriendList{
    FriendListViewController *friendListVC = [[FriendListViewController alloc] init];
    [self.navigationController pushViewController:friendListVC animated:YES];
}

-(void)getUserData{
    
}

-(void)getUser{
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" equalTo:friendUserId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        friendUser = (PFUser *)object;
        username = object[@"usernameForUser"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        PFFile *imageFile = object[@"profileImageFile"];
        [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error){
            if(!error){
                profileImage = [UIImage imageWithData:data];
                [self.collectionView reloadData];
            }else{
                NSLog(@"Error:%@",error);
            }
        }];
        [self.collectionView reloadData];
    }];
}


@end
