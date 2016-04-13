//
//  FirstViewController.m
//  MonoMosh
//
//  Created by 嶋本夏海 on 2016/02/02.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import "TimeLineViewController.h"
#import "MMCollectionViewCell.h"
#import "DetailViewController.h"
#import "SignupViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

static NSString *cellIdentifier = @"MMCollectionViewCell";

@interface TimeLineViewController ()

@end

@implementation TimeLineViewController

@synthesize monoArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MMCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:cellIdentifier];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshCollection:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    self.title = @"Timeline";
    
    if(![PFUser currentUser]){
        SignupViewController *SVC = [[SignupViewController alloc] init];
        [self presentViewController:SVC animated:YES completion:nil];
    }

    monoArray = [[NSMutableArray alloc] init];
    
    [self loadMono];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadMono{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"PostObject"];
    query.limit = 10;
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

-(void)loadNewMono{
    PFQuery *query = [PFQuery queryWithClassName:@"PostObject"];
    query.limit = 10;
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(!error){
            for(PFObject *object in objects){
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                dic[@"object"] = object;
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
            }
        }else{
            NSLog(@"Errpr:%@",error);
        }
    }];
}

-(void)loadOldMono{
    PFQuery *query = [PFQuery queryWithClassName:@"PostObject"];
    query.limit = 10;
    [query orderByDescending:@"createdAt"];
    query.skip = monoArray.count;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(!error){
            indicator.hidden = YES;
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
            }
            moreButton.hidden = NO;
        }else{
            NSLog(@"Errpr:%@",error);
        }
    }];
}

-(void)refreshCollection:(id)sender{
    [sender beginRefreshing];
    [monoArray removeAllObjects];
//    [self.collectionView reloadData];
    [self loadNewMono];
    [sender endRefreshing];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(monoArray.count == 0){
        return 10;
    }
    return monoArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MMCollectionViewCell *cell = (MMCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    if(monoArray.count == 0)
        return cell;
    NSDictionary *dic = monoArray[indexPath.row];
    cell.imageView.image = dic[@"postPhoto"];
    cell.monoName.text = dic[@"postName"];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //reference:http://qiita.com/k_kuni/items/9916dab83552b77e7751
    
    float width = (self.collectionView.frame.size.width-15)/2;
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
    detailVC.mono = dic[@"object"];
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    
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

-(void)loadMore{
    moreButton.hidden = YES;
    indicator.hidden = NO;
    [indicator startAnimating];
    [self loadOldMono];
}

@end
