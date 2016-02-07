//
//  DetailViewController.m
//  MonoMosh
//
//  Created by Paul McCartney on 2016/02/05.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import "DetailViewController.h"
#import "FriendPageViewController.h"
#import "MyPageViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //reference:http://blog.misubo.com/article/111015348.html
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)moveToUserPage{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FriendPage" bundle:[NSBundle mainBundle]];
    FriendPageViewController *friendPageVC = [storyboard instantiateInitialViewController];
    [self.navigationController pushViewController:friendPageVC animated:YES];
}

@end
