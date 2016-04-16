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
#import "DetailViewController.h"
#import "TimeLineViewController.h"
#import "MyPageViewController.h"

@interface WantListViewController ()

@end

@implementation WantListViewController

@synthesize wantListArray,postId,postName;

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
        cell.valueImageView.image = [UIImage imageNamed:@"starbucksIcon"];
    else if([value isEqualToString:@"Lunch"])
        cell.valueImageView.image = [UIImage imageNamed:@"lunchIcon"];
    else if([value isEqualToString:@"Ability"])
        cell.valueImageView.image = [UIImage imageNamed:@"abilityIcon"];
    
    [cell setCell];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIAlertController *action = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSDictionary *dic = wantListArray[indexPath.row];
    PFUser *friendUser = dic[@"user"];
    
    [action addAction:[UIAlertAction actionWithTitle:@"Move to this user's page" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FriendPage" bundle:[NSBundle mainBundle]];
        FriendPageViewController *friendPageVC = [storyboard instantiateInitialViewController];
        friendPageVC.profileImage = dic[@"profileImage"];
        friendPageVC.friendUser = friendUser;
        friendPageVC.username = friendUser[@"usernameForUser"];
        friendPageVC.postNum = [NSString stringWithFormat:@"%@",friendUser[@"postNum"]];
        friendPageVC.friendNum = [NSString stringWithFormat:@"%@",friendUser[@"friendNum"]];
        friendPageVC.abilityStr = friendUser[@"abilityStr"];
        [self.navigationController pushViewController:friendPageVC animated:YES];
    }]];
    
    [action addAction:[UIAlertAction actionWithTitle:@"Give Mono to this user" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
        NSArray *viewControllers = [self.navigationController viewControllers];
        DetailViewController *detailVC = [viewControllers objectAtIndex:[viewControllers count]-1];
        [detailVC giveMono];
        UIViewController *viewController = [viewControllers objectAtIndex:viewControllers.count -2];
        if([viewController isMemberOfClass:[TimeLineViewController class]]){
            TimeLineViewController *timelineVC = (TimeLineViewController *)viewController;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"postId == %@",postId];
            NSMutableDictionary *dic = [[[timelineVC.monoArray filteredArrayUsingPredicate:predicate] firstObject] mutableCopy];
            NSUInteger index = [timelineVC.monoArray indexOfObject:dic];
            dic[@"postState"] = @"Negotiation";
            timelineVC.monoArray[index] = dic;
            [timelineVC loadMono];

        }else if([viewController isMemberOfClass:[MyPageViewController class]]){
            MyPageViewController *mypageVC = (MyPageViewController *)viewController;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"postId == %@",postId];
            NSMutableDictionary *dic = [[[mypageVC.monoArray filteredArrayUsingPredicate:predicate] firstObject] mutableCopy];
            NSUInteger index = [mypageVC.monoArray indexOfObject:dic];
            dic[@"postState"] = @"Negotiation";
            mypageVC.monoArray[index] = dic;
            [mypageVC loadMono];
        }
        
        PFPush *push = [[PFPush alloc] init];
        NSString *channel = [NSString stringWithFormat:@"U%@",friendUser.objectId];
        NSString *message = [NSString stringWithFormat:@"You get a bargaining right of %@",postName];
        NSDictionary *data = @{
                               @"alert":message,
                               @"userId":[PFUser currentUser].objectId,
                               @"postId":postId,
                               @"content-available": @1,
                               @"type":@"negotiation"
                               };
        [push setChannel:channel];
        [push setData:data];
        [push sendPushInBackground];
    }]];
    
    [action addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:action animated:YES completion:nil];
}

@end
