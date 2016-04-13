//
//  FriendListViewController.m
//  MonoMosh
//
//  Created by Paul McCartney on 2016/02/07.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import "FriendListViewController.h"
#import "FriendPageViewController.h"
#import "MMTableViewCell.h"

@interface FriendListViewController ()

@end

@implementation FriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    UINib *nib = [UINib nibWithNibName:@"MMTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"MMTableViewCell"];
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
        
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"MMTableViewCell";
    MMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.profileImage = [UIImage imageNamed:@"profileImage.png"];
    cell.username = @"username";
    
    [cell setCell];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //reference:http://stackoverflow.com/questions/17215258/nsinvalidargumentexception-reason-uicollectionview-must-be-initialized-with
    //reference:http://stackoverflow.com/questions/17819826/application-tried-to-push-a-nil-view-controller-on-target
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FriendPage" bundle:[NSBundle mainBundle]];
    FriendPageViewController *friendPageVC = [storyboard instantiateInitialViewController];
    [self.navigationController pushViewController:friendPageVC animated:YES];
}


@end
