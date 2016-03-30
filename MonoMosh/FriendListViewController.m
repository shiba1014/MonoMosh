//
//  FriendListViewController.m
//  MonoMosh
//
//  Created by Paul McCartney on 2016/02/07.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import "FriendListViewController.h"
#import "FriendPageViewController.h"

@interface FriendListViewController ()

@end

@implementation FriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"profileImage.png"];
    cell.textLabel.text = @"username";
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //reference:http://stackoverflow.com/questions/17215258/nsinvalidargumentexception-reason-uicollectionview-must-be-initialized-with
    //reference:http://stackoverflow.com/questions/17819826/application-tried-to-push-a-nil-view-controller-on-target
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FriendPage" bundle:[NSBundle mainBundle]];
    FriendPageViewController *friendPageVC = [storyboard instantiateInitialViewController];
    [self.navigationController pushViewController:friendPageVC animated:YES];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 100;
//}

@end
