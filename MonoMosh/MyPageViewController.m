//
//  SecondViewController.m
//  MonoMosh
//
//  Created by 嶋本夏海 on 2016/02/02.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import "MyPageViewController.h"
#import "MonoCollectionReusableView.h"
#import "MonoCollectionViewCell.h"
#import "DetailViewController.h"
#import "FriendListViewController.h"

static NSString *headerIdentifier = @"MonoCollectionHeader";
static NSString *cellIdentifier = @"MonoCollectionViewCell";

@interface MyPageViewController (){
    UIButton *moreButton;
    UIActivityIndicatorView *indicator;
}

@end

@implementation MyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self loadMono];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    self.title = @"Mypage";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadMono{
    [self.collectionView registerNib:[UINib nibWithNibName:@"MonoCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MonoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    //    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //reference:http://qiita.com/nusa/items/30157bf0647495dca48c
    //reference:http://qiita.com/kaktaam/items/6035708823f31d4530a1
    
    UICollectionReusableView *reusableView = nil;
    
    if(kind == UICollectionElementKindSectionHeader){
        MonoCollectionReusableView *header = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        header.friendButton.hidden = YES;
        [header.friendNumButton addTarget:self action:@selector(moveToFriendList) forControlEvents:UIControlEventTouchUpInside];
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
    return 17;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MonoCollectionViewCell *cell = (MonoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor orangeColor];
    cell.shadowImage.hidden = YES;
    cell.monoName.hidden = YES;
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
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)loadMore{
    moreButton.hidden = YES;
    indicator.hidden = NO;
    [indicator startAnimating];
}

-(void)moveToFriendList{
    FriendListViewController *friendListVC = [[FriendListViewController alloc] init];
    [self.navigationController pushViewController:friendListVC animated:YES];
}

@end
