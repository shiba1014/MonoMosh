//
//  SecondViewController.m
//  MonoMosh
//
//  Created by 嶋本夏海 on 2016/02/02.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import "MyPageViewController.h"
#import "MMCollectionReusableView.h"
#import "MMCollectionViewCell.h"
#import "DetailViewController.h"
#import "FriendListViewController.h"
#import "MBProgressHUD.h"
#import <Parse/Parse.h>
#import "TimeLineViewController.h"
#import "MyPageViewController.h"

static NSString *headerIdentifier = @"MMCollectionHeader";
static NSString *cellIdentifier = @"MMCollectionViewCell";

@interface MyPageViewController ()

@end

@implementation MyPageViewController

@synthesize profileImage,username,monoArray,postNum,friendNum,abilityStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MMCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MMCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    self.title = @"Mypage";
    
    monoArray = [[NSMutableArray alloc] init];
    
    [self loadMono];
    if(!profileImage)
        [self getUser];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadMono{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"PostObject"];
    query.limit = 9;
    [query whereKey:@"postUser" equalTo:[PFUser currentUser]];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(!error){
            if(objects.count == 0 || objects.count < query.limit)
                moreButton.hidden = YES;
            for(PFObject *object in objects){
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                dic[@"object"] = object;
                dic[@"postName"] = object[@"postName"];
                dic[@"postDiscription"] = object[@"postDiscription"];
                PFUser *postUser = object[@"postUser"];
                dic[@"postUserId"] = postUser.objectId;
                dic[@"postId"] = object.objectId;
                dic[@"postDiscription"] = object[@"postDiscription"];
                dic[@"postState"] = object[@"postState"];
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
            NSLog(@"Errpr:%@",error);
        }
    }];
}

-(void)loadOldMono{
    PFQuery *query = [PFQuery queryWithClassName:@"PostObject"];
    query.limit = 9;
    query.skip = monoArray.count;
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"postUser" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        indicator.hidden = YES;
        if(!error){
            if(objects.count == 0 || objects.count < query.limit)
                moreButton.hidden = YES;
            for(PFObject *object in objects){
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                dic[@"object"] = object;
                dic[@"postName"] = object[@"postName"];
                dic[@"postDiscription"] = object[@"postDiscription"];
                PFUser *postUser = object[@"postUser"];
                dic[@"postUserId"] = postUser.objectId;
                dic[@"postId"] = object.objectId;
                dic[@"postDiscription"] = object[@"postDiscription"];
                dic[@"postState"] = object[@"postState"];
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
    }];
}


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //reference:http://qiita.com/nusa/items/30157bf0647495dca48c
    //reference:http://qiita.com/kaktaam/items/6035708823f31d4530a1
    
    UICollectionReusableView *reusableView = nil;
    
    if(kind == UICollectionElementKindSectionHeader){
        //TODO:profileImageがnilになる
        MMCollectionReusableView *header = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        header.username = username;
        header.profileImage = profileImage;
        header.friendButton.hidden = YES;
        header.postNum = postNum;
        if([friendNum isEqualToString:@"(null)"])
            friendNum = @"0";
        header.friendNum = friendNum;
        header.abilityStr = abilityStr;
        [header.friendNumButton addTarget:self action:@selector(moveToFriendList) forControlEvents:UIControlEventTouchUpInside];
        [header setHeader];
        return header;
    }
    if (kind == UICollectionElementKindSectionFooter){
        reusableView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer" forIndexPath:indexPath];
        
        //reference:http://stackoverflow.com/questions/27142581/outlets-cannot-be-connected-to-repeating-content-ios-5
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
    return monoArray.count;

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MMCollectionViewCell *cell = (MMCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.shadowImage.hidden = YES;
    cell.monoName.hidden = YES;
    if(monoArray.count == 0)
        return cell;
    NSDictionary *dic = monoArray[indexPath.row];
    cell.imageView.image = dic[@"postPhoto"];
    if ([dic[@"postState"] isEqualToString:@"Sale"])
        cell.stateImageView.image = nil;
    else if([dic[@"postState"] isEqualToString:@"Negotiation"])
        cell.stateImageView.image = [UIImage imageNamed:@"negotiationLabel"];
    else if([dic[@"postState"] isEqualToString:@"SoldOut"])
        cell.stateImageView.image = [UIImage imageNamed:@"soldOutLabel"];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //reference:http://qiita.com/k_kuni/items/9916dab83552b77e7751
    
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
    detailVC.postNum = postNum;
    detailVC.friendNum = friendNum;
    detailVC.abilityStr = abilityStr;
    detailVC.mono = dic[@"object"];
    detailVC.postState = dic[@"postState"];
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

-(void)getUser{
    PFUser *user = [PFUser currentUser];
    user[@"usernameForUser"] = @"Satsuki Hashiba";
    [user saveInBackground];
    username = user[@"usernameForUser"];
    postNum = [NSString stringWithFormat:@"%@",user[@"postNum"]];
    friendNum = [NSString stringWithFormat:@"%@",user[@"friendNum"]];
    if(!friendNum){
        NSLog(@"yeah");
    }
    abilityStr = user[@"ability"];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    PFFile *imageFile = user[@"profileImageFile"];
    [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error){
        if(!error){
            profileImage = [UIImage imageWithData:data];
            [self.collectionView reloadData];
        }else{
            NSLog(@"Error:%@",error);
        }
    }];
}



@end
