//
//  FirstViewController.m
//  MonoMosh
//
//  Created by 嶋本夏海 on 2016/02/02.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import "TimeLineViewController.h"
#import "MonoCollectionViewCell.h"
#import "DetailViewController.h"

static NSString *cellIdentifier = @"MonoCollectionViewCell";

@interface TimeLineViewController (){
    UIButton *moreButton;
    UIActivityIndicatorView *indicator;
}

@end

@implementation TimeLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Timeline";
    [self loadMono];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadMono{
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MonoCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:cellIdentifier];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshCollection:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
}

-(void)refreshCollection:(id)sender{
    [sender beginRefreshing];
    [self.collectionView reloadData];
    [sender endRefreshing];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 7;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MonoCollectionViewCell *cell = (MonoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor orangeColor];
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
}

@end
