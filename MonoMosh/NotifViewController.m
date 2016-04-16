//
//  ThirdViewController.m
//  MonoMosh
//
//  Created by 嶋本夏海 on 2016/02/02.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import "NotifViewController.h"
#import "MMTableViewCell.h"
#import "FriendPageViewController.h"
#import "DetailViewController.h"

@interface NotifViewController ()

@end

@implementation NotifViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    table.dataSource = self;
    table.delegate = self;
    
    notifArray = [[NSArray alloc] init];

//    profileImage = [UIImage imageNamed:@"profileImage.png"];
//    
//    userName = @"わんだ";
//    monoName = @"犬";
//    NSString *wantText = [NSString stringWithFormat:@"%@さんが%@を欲しがっています",userName,monoName];
//   // NSString *pointText = [NSString stringWithFormat:@"交渉成立！%dポイントゲットしました",point];
//  
//    NSDictionary *notifDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                         profileImage, @"profileImage",
//                         wantText, @"labelText",
//                         nil];
//
//    [notifArray addObject:notifDic];
    notifArray = [[NSUserDefaults standardUserDefaults] arrayForKey:@"notifArray"];
 
    self.title = @"Notif";
    
    UINib *nib = [UINib nibWithNibName:@"MMTableViewCell" bundle:nil];
    [table registerNib:nib forCellReuseIdentifier:@"MMTableViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//Table Viewのセクション数を指定
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 今回はセクション１個
    return 1;
}

//Table Viewのセルの数を指定
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return notifArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

//各セルの要素を設定する
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"MMTableViewCell";
    MMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSDictionary *dic = notifArray[indexPath.row];
    
    cell.profileImage = dic[@"image"];
    cell.username = dic[@"alertStr"];
    
    [cell setCell];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = notifArray[indexPath.row];
    if([dic[@"type"] isEqualToString:@"want"]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FriendPage" bundle:[NSBundle mainBundle]];
        FriendPageViewController *friendPageVC = [storyboard instantiateInitialViewController];
        friendPageVC.friendUserId = dic[@"userId"];
        [self.navigationController pushViewController:friendPageVC animated:YES];
    }else if([dic[@"type"] isEqualToString:@"negotiation"]){
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        detailVC.postId = dic[@"postId"];
        detailVC.postUserId = dic[@"userId"];
        [self.navigationController pushViewController:detailVC animated:YES];
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
