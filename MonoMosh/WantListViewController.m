//
//  WantListViewController.m
//  MonoMosh
//
//  Created by Paul McCartney on 2016/04/11.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import "WantListViewController.h"
#import "FriendPageViewController.h"
#import "MMTableViewCell.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

@interface WantListViewController ()

@end

@implementation WantListViewController

@synthesize wantListArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    UINib *nib = [UINib nibWithNibName:@"MMTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"MMTableViewCell"];
    
    if(wantListArray.count != 0)
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return wantListArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"MMTableViewCell";
    MMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSMutableDictionary *dic = wantListArray[indexPath.row];
    PFUser *user = dic[@"user"];
    PFFile *file = user[@"profileImageFile"];
    [file getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if(!error){
            UIImage *profileImage = [UIImage imageWithData:data];
            cell.profileImage = profileImage;
            [cell setCell];
            dic[@"profileImage"] = profileImage;
            
            if(indexPath.row == wantListArray.count - 1)
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }else{
            NSLog(@"%@",error);
        }
    }];
    cell.profileImage = [UIImage imageNamed:@"profileImage.png"];
    cell.username = user[@"usernameForUser"];
    
    NSString *value = dic[@"value"];
    if([value isEqualToString:@"StarBucks"])
        cell.valueImageView.backgroundColor = [UIColor magentaColor];
    else if([value isEqualToString:@"Lunch"])
        cell.valueImageView.backgroundColor = [UIColor cyanColor];
    else if([value isEqualToString:@"Ability"])
        cell.valueImageView.backgroundColor = [UIColor yellowColor];
    
    [cell setCell];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //TODO:タップ後どうするか
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FriendPage" bundle:[NSBundle mainBundle]];
    FriendPageViewController *friendPageVC = [storyboard instantiateInitialViewController];
    NSDictionary *dic = wantListArray[indexPath.row];
    PFUser *friendUser = dic[@"user"];
    friendPageVC.profileImage = dic[@"profileImage"];
    friendPageVC.friendUser = friendUser;
    friendPageVC.username = friendUser[@"usernameForUser"];
    [self.navigationController pushViewController:friendPageVC animated:YES];
}

@end
