//
//  ThirdViewController.m
//  MonoMosh
//
//  Created by 嶋本夏海 on 2016/02/02.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import "NotifViewController.h"
#import "MMTableViewCell.h"

@interface NotifViewController ()

@end

@implementation NotifViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    table.dataSource = self;
    table.delegate = self;
    
    notifArray = [NSMutableArray array];

    profileImage = [UIImage imageNamed:@"profileImage.png"];
    
    userName = @"わんだ";
    monoName = @"犬";
    NSString *wantText = [NSString stringWithFormat:@"%@さんが%@を欲しがっています",userName,monoName];
   // NSString *pointText = [NSString stringWithFormat:@"交渉成立！%dポイントゲットしました",point];
  
    NSDictionary *notifDic = [NSDictionary dictionaryWithObjectsAndKeys:
                         profileImage, @"profileImage",
                         wantText, @"labelText",
                         nil];

    [notifArray addObject:notifDic];
 
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
    
    cell.profileImage = [UIImage imageNamed:@"profileImage.png"];
    cell.username = @"username";
    
    [cell setCell];
    
    return cell;
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
