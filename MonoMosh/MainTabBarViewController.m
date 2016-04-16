//
//  MainTabBarViewController.m
//  MonoMosh
//
//  Created by 嶋本夏海 on 2016/02/02.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import "MainTabBarViewController.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    
    NSMutableArray *viewControllers = [NSMutableArray new];
    
    UIStoryboard *tlStoryboard = [UIStoryboard storyboardWithName:@"TimeLine" bundle:[NSBundle mainBundle]];
    UIViewController *tlViewController = [tlStoryboard instantiateInitialViewController];
     [viewControllers addObject:tlViewController];
    
    UIStoryboard *searchStoryboard = [UIStoryboard storyboardWithName:@"Search" bundle:[NSBundle mainBundle]];
    UIViewController *searchViewController = [searchStoryboard instantiateInitialViewController];
    [viewControllers addObject:searchViewController];
    
    UIStoryboard *cameraStoryboard = [UIStoryboard storyboardWithName:@"Camera" bundle:[NSBundle mainBundle]];
    UIViewController *cameraViewController = [cameraStoryboard instantiateInitialViewController];
    [viewControllers addObject:cameraViewController];
    
    UIStoryboard *notifStoryboard = [UIStoryboard storyboardWithName:@"Notif" bundle:[NSBundle mainBundle]];
    UIViewController *notifViewController = [notifStoryboard instantiateInitialViewController];
    [viewControllers addObject:notifViewController];
    
    UIStoryboard *mpStoryboard = [UIStoryboard storyboardWithName:@"MyPage" bundle:[NSBundle mainBundle]];
    UIViewController *mpViewController = [mpStoryboard instantiateInitialViewController];
    [viewControllers addObject:mpViewController];
    
    // TabBarController の持つ ViewController の配列に代入
    self.viewControllers = viewControllers;
    
    for(UITabBarItem *item in self.tabBar.items){
        if([item.title isEqualToString:@"Timeline"]){
            
            item.image = [[UIImage imageNamed:@"timelineTabIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
        }else if([item.title isEqualToString:@"Search"]){
            
        }
        else if ([item.title isEqualToString:@"Camera"]){
            
            item.image = [[UIImage imageNamed:@"cameraTabIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
        }else if ([item.title isEqualToString:@"Mypage"]){
            
            item.image = [[UIImage imageNamed:@"mypageTabIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }else {
            item.image = [[UIImage imageNamed:@"notifTabIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
    }
 
    
    //タブ選択時のフォントとカラー
    NSDictionary *selectedAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:10],
                                         NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    [[UITabBarItem appearance] setTitleTextAttributes:selectedAttributes
                                             forState:UIControlStateSelected];
    
    //通常時のフォントとカラー
    NSDictionary *attributesNormal = @{NSFontAttributeName : [UIFont systemFontOfSize:10],
                                       NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    [[UITabBarItem appearance] setTitleTextAttributes:attributesNormal
                                             forState:UIControlStateNormal];
    
    [UITabBar appearance].barTintColor = [UIColor colorWithRed:0.227 green:0.239 blue:0.231 alpha:1.000];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"selectedIcon"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
