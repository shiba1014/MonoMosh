//
//  MainTabBarViewController.m
//  MonoMosh
//
//  Created by 嶋本夏海 on 2016/02/02.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "CameraViewController.h"

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
    
    UIStoryboard *cameraStoryboard = [UIStoryboard storyboardWithName:@"Camera" bundle:[NSBundle mainBundle]];
    UIViewController *cameraViewController = [cameraStoryboard instantiateInitialViewController];
    [viewControllers addObject:cameraViewController];

    UIStoryboard *mpStoryboard = [UIStoryboard storyboardWithName:@"MyPage" bundle:[NSBundle mainBundle]];
    UIViewController *mpViewController = [mpStoryboard instantiateInitialViewController];
    [viewControllers addObject:mpViewController];
    
    
    UIStoryboard *notifStoryboard = [UIStoryboard storyboardWithName:@"Notif" bundle:[NSBundle mainBundle]];
    UIViewController *notifViewController = [notifStoryboard instantiateInitialViewController];
    [viewControllers addObject:notifViewController];
    
    // TabBarController の持つ ViewController の配列に代入
    self.viewControllers = viewControllers;
    
/*
    for(UITabBarItem *item in self.tabBar.items){
        if([item.title isEqualToString:@"TimeLine"]){
            
            item.image = [[UIImage imageNamed:@"homeTabImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            item.selectedImage = [UIImage imageNamed:@"homeTabImage"];
            
        }else if ([item.title isEqualToString:@"Camera"]){
            
            item.image = [[UIImage imageNamed:@"studyTabImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
        }else if ([item.title isEqualToString:@"MyPage"]){
            
            item.image = [[UIImage imageNamed:@"studyTabImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }else {
            item.image = [[UIImage imageNamed:@"notifTabImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            item.selectedImage = [UIImage imageNamed:@"notifTabImage"];
        }
    }
    */
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
