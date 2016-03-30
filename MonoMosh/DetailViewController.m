//
//  DetailViewController.m
//  MonoMosh
//
//  Created by Paul McCartney on 2016/02/05.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import "DetailViewController.h"
#import "FriendPageViewController.h"
#import "MyPageNavigationViewController.h"
#import "MyPageViewController.h"
#import "MBProgressHUD.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize postId,postUserId,postUsername,postName,postDiscription,postPhoto,profileImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //reference:http://blog.misubo.com/article/111015348.html
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    monoLabel.text = postName;
    detailLabel.text = postDiscription;
    monoImageView.image = postPhoto;
    
    if(![postUserId isEqualToString:[PFUser currentUser].objectId]){
        optionButton.hidden = YES;
    }
    
    if(!profileImage){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self getPostUser];
    }else{
        usernameLabel.text = postUsername;
        profileImageView.image = profileImage;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)moveToUserPage{
    if([postUserId isEqualToString:[PFUser currentUser].objectId]){
        //TODO:落ちる
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyPage" bundle:[NSBundle mainBundle]];
        MyPageNavigationViewController *myPageNaviVC = [storyboard instantiateInitialViewController];
        MyPageViewController *myPageVC = myPageNaviVC.viewControllers[0];
        myPageVC.profileImage = profileImage;
        myPageVC.username = postUsername;
        [self.navigationController pushViewController:myPageNaviVC.viewControllers[0] animated:YES];
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FriendPage" bundle:[NSBundle mainBundle]];
        FriendPageViewController *friendPageVC = [storyboard instantiateInitialViewController];
        [self.navigationController pushViewController:friendPageVC animated:YES];
    }
}

-(void)getPostUser{
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" equalTo:postUserId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        postUsername = object[@"usernameForUser"];
        usernameLabel.text = postUsername;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        PFFile *imageFile = object[@"profileImageFile"];
        [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error){
            if(!error){
                profileImage = [UIImage imageWithData:data];
                profileImageView.image = profileImage;
            }else{
                NSLog(@"Error:%@",error);
            }
        }];
    }];
}

@end
