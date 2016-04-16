//
//  SearchViewController.m
//  MonoMosh
//
//  Created by Paul McCartney on 2016/04/13.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import "SearchViewController.h"
#import "DetailViewController.h"
#import "MMCollectionViewCell.h"
#import "MMTableViewCell.h"
#import "FriendPageViewController.h"
#import "MyPageViewController.h"
#import "MyPageNavigationViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

static NSString *cellIdentifier = @"MMCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.tintColor = [UIColor darkGrayColor];
    searchBar.placeholder = @"Search";
    searchBar.keyboardType = UIKeyboardTypeDefault;
    searchBar.showsCancelButton = YES;
    searchBar.delegate = self;
    searchBar.tintColor = [UIColor whiteColor];
    
    // UINavigationBar上に、UISearchBarを追加
    self.navigationItem.titleView = searchBar;
    self.navigationItem.titleView.frame = CGRectMake(0, 0, 320, 44);
    
    // 初期フォーカスを設定
    [searchBar becomeFirstResponder];
    
    collection.delegate = self;
    collection.dataSource = self;
    collection.backgroundColor = [UIColor whiteColor];
    [collection registerNib:[UINib nibWithNibName:@"MMCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    collection.hidden = YES;
    
    table.dataSource = self;
    table.delegate = self;
    UINib *nib = [UINib nibWithNibName:@"MMTableViewCell" bundle:nil];
    [table registerNib:nib forCellReuseIdentifier:@"MMTableViewCell"];
    table.hidden = YES;
    
    [segmented addTarget:self action:@selector(segmentedChanged:) forControlEvents:UIControlEventValueChanged];
    segmented.tintColor = [UIColor colorWithRed:0.106 green:0.506 blue:0.243 alpha:1.000];
    
    indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    
    resultArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchBarCancelButtonClicked:(UISearchBar*)searchBar{
    searchBar.text = nil;
    [searchBar resignFirstResponder];
}

//-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
//
//}

-(void)searchBarSearchButtonClicked:(UISearchBar*)searchBar{
    
    [indicator stopAnimating];
    [query cancel];
    [searchBar resignFirstResponder];
    [resultArray removeAllObjects];
    
    collection.hidden = YES;
    table.hidden = YES;
    
    [indicator startAnimating];
    if(segmented.selectedSegmentIndex == 0)
        [self queryMono:searchBar.text];
    else
        [self queryUser:searchBar.text];
}

-(void)queryMono:(NSString*)searchText{
    query = [PFQuery queryWithClassName:@"PostObject"];
    [query whereKey:@"postName" containsString:searchText];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(!error){
            [indicator stopAnimating];
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
                [resultArray addObject:dic];
                PFFile *imageFile = object[@"postPhoto"];
                [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                    if(!error){
                        UIImage *postPhoto = [UIImage imageWithData:data];
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"postId == %@",object.objectId];
                        NSMutableDictionary *dic = [[[resultArray filteredArrayUsingPredicate:predicate] firstObject] mutableCopy];
                        NSUInteger index = [resultArray indexOfObject:dic];
                        dic[@"postPhoto"] = postPhoto;
                        resultArray[index] = dic;
                        [collection reloadData];
                    }
                }];
                collection.hidden = NO;
                [collection reloadData];
            }
        }else{
            NSLog(@"%@",error);
        }
    }];
}

-(void)queryUser:(NSString*)searchText{
    query = [PFUser query];
    [query whereKey:@"usernameForUser" containsString:searchText];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(!error){
            [indicator stopAnimating];
            for(PFUser *user in objects){
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                dic[@"user"] = user;
                dic[@"usernameForUser"] = user[@"usernameForUser"];
                dic[@"ability"] = user[@"ability"];
                [resultArray addObject:dic];
                PFFile *imageFile = user[@"profileImageFile"];
                [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                    if(!error){
                        UIImage *postPhoto = [UIImage imageWithData:data];
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"usernameForUser == %@",user[@"usernameForUser"]];
                        NSMutableDictionary *dic = [[[resultArray filteredArrayUsingPredicate:predicate] firstObject] mutableCopy];
                        NSUInteger index = [resultArray indexOfObject:dic];
                        dic[@"profileImage"] = postPhoto;
                        resultArray[index] = dic;
                        [collection reloadData];
                    }
                }];
                table.hidden = NO;
                [table reloadData];
            }
        }else{
            NSLog(@"%@",error);
        }
    }];
}

-(void)segmentedChanged:(id)sender{
    [indicator stopAnimating];
    [resultArray removeAllObjects];
    [query cancel];
    collection.hidden = YES;
    table.hidden = YES;
}

#pragma mark - CollectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return resultArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MMCollectionViewCell *cell = (MMCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    if(resultArray.count == 0)
        return cell;
    NSDictionary *dic = resultArray[indexPath.row];
    cell.imageView.image = dic[@"postPhoto"];
    cell.monoName.text = dic[@"postName"];

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
    
    float width = (collectionView.frame.size.width-15)/2;
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
    NSDictionary *dic = resultArray[indexPath.row];
    detailVC.postPhoto = dic[@"postPhoto"];
    detailVC.postName = dic[@"postName"];
    detailVC.postDiscription = dic[@"postDiscription"];
    detailVC.postId = dic[@"postId"];
    detailVC.postUserId = dic[@"postUserId"];
    detailVC.mono = dic[@"object"];
    detailVC.postState = dic[@"postState"];
    detailVC.abilityStr = dic[@"ability"];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark -TableView
//Table Viewのセクション数を指定
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 今回はセクション１個
    return 1;
}

//Table Viewのセルの数を指定
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return resultArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"MMTableViewCell";
    MMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSMutableDictionary *dic = resultArray[indexPath.row];
    PFUser *user = dic[@"user"];
    PFFile *file = user[@"profileImageFile"];
    [file getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if(!error){
            UIImage *profileImage = [UIImage imageWithData:data];
            cell.profileImage = profileImage;
            [cell setCell];
            dic[@"profileImage"] = profileImage;
        }else{
            NSLog(@"%@",error);
        }
    }];
    cell.username = user[@"usernameForUser"];
    
    [cell setCell];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = resultArray[indexPath.row];
    PFUser *user = dic[@"user"];
    if([user.objectId isEqualToString:[PFUser currentUser].objectId]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyPage" bundle:[NSBundle mainBundle]];
        MyPageNavigationViewController *myPageNaviVC = [storyboard instantiateInitialViewController];
        MyPageViewController *myPageVC = myPageNaviVC.viewControllers[0];
        myPageVC.profileImage = dic[@"profileImage"];
        myPageVC.username = dic[@"usernameForUser"];
        myPageVC.abilityStr = dic[@"abilityStr"];
        [self.navigationController pushViewController:myPageVC animated:YES];
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FriendPage" bundle:[NSBundle mainBundle]];
        FriendPageViewController *friendPageVC = [storyboard instantiateInitialViewController];
        friendPageVC.profileImage = dic[@"profileImage"];
        friendPageVC.friendUser = user;
        friendPageVC.username = user[@"usernameForUser"];
        friendPageVC.abilityStr = dic[@"abilityStr"];
        [self.navigationController pushViewController:friendPageVC animated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
