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
#import "CameraViewController.h"
#import "CameraNavigationViewController.h"
#import "TimeLineViewController.h"
#import "WantListViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize postId,postUserId,postUsername,postName,postDiscription,postPhoto,profileImage,friendUser,mono;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //reference:http://blog.misubo.com/article/111015348.html
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    ud = [NSUserDefaults standardUserDefaults];
    wantMonoArray = [[ud arrayForKey:@"wantMonoArray"] mutableCopy];
    if(!wantMonoArray)
        wantMonoArray = [[NSMutableArray alloc] init];
    
    monoLabel.text = postName;
    detailLabel.text = postDiscription;
    monoImageView.image = postPhoto;
    
    if(![postUserId isEqualToString:[PFUser currentUser].objectId]){
        optionButton.hidden = YES;
        wantListButton.hidden = YES;
        //        [goodButton addTarget:self action:@selector(goodButtonPushed) forControlEvents:UIControlEventTouchUpInside];
        [wantButton addTarget:self action:@selector(wantButtonPushed) forControlEvents:UIControlEventTouchUpInside];
    }else{
        //        goodButton.hidden = YES;
        wantButton.hidden = YES;
        [optionButton addTarget:self action:@selector(tappedOption) forControlEvents:UIControlEventTouchUpInside];
        [wantListButton addTarget:self action:@selector(wantListButtonPushed) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if(!profileImage){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self getPostUser];
    }else{
        usernameLabel.text = postUsername;
        profileImageView.image = profileImage;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    if([wantMonoArray containsObject:postId])
        wantButton.titleLabel.text = @"WANTED!";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)moveToUserPage{
    if([postUserId isEqualToString:[PFUser currentUser].objectId]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyPage" bundle:[NSBundle mainBundle]];
        MyPageNavigationViewController *myPageNaviVC = [storyboard instantiateInitialViewController];
        MyPageViewController *myPageVC = myPageNaviVC.viewControllers[0];
        myPageVC.profileImage = profileImage;
        myPageVC.username = postUsername;
        [self.navigationController pushViewController:myPageVC animated:YES];
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FriendPage" bundle:[NSBundle mainBundle]];
        FriendPageViewController *friendPageVC = [storyboard instantiateInitialViewController];
        friendPageVC.profileImage = profileImage;
        friendPageVC.username = postUsername;
        friendPageVC.friendUser = friendUser;
        [self.navigationController pushViewController:friendPageVC animated:YES];
    }
}

-(void)getPostUser{
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" equalTo:postUserId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        friendUser = (PFUser *)object;
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

-(void)tappedOption{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Edit this post" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self editButtonPushed];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Delete this post" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self deleteButtonPushed];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)deleteButtonPushed {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"この投稿を削除します。よろしいですか?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [mono deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                UIAlertController *finishAlert = [UIAlertController alertControllerWithTitle:@"" message:@"投稿を削除しました" preferredStyle:UIAlertControllerStyleAlert];
                [finishAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //                            UIStoryboard *timelineStoryboard = [UIStoryboard storyboardWithName:@"TimeLine" bundle:nil];
                    //                            TimeLineViewController *timelineVC = [timelineStoryboard instantiateInitialViewController];
                    //                            [timelineVC.monoArray removeAllObjects];
                    //                            [timelineVC loadMono];
                    //
                    //                            UIStoryboard *myPageStoryboard = [UIStoryboard storyboardWithName:@"MyPage" bundle:nil];
                    //                            MyPageNavigationViewController *myPageNaviVC = [myPageStoryboard instantiateInitialViewController];
                    //                            MyPageViewController *myPageVC = myPageNaviVC.viewControllers[0];
                    //                            [myPageVC.monoArray removeAllObjects];
                    //                            [myPageVC loadMono];
                    [self.navigationController popViewControllerAnimated:YES];
                }]];
                [self presentViewController:finishAlert animated:YES completion:nil];
            }
        }];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)editButtonPushed {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Camera" bundle:[NSBundle mainBundle]];
    CameraNavigationViewController *cameraNaviVC = [storyboard instantiateInitialViewController];
    CameraViewController *cameraVC = cameraNaviVC.viewControllers[0];
    cameraVC.postPhoto = postPhoto;
    cameraVC.postName = postName;
    cameraVC.postDiscription = postDiscription;
    cameraVC.postId = postId;
    cameraVC.isEdit = YES;
    [self.navigationController pushViewController:cameraVC animated:YES];
}

-(void)wantListButtonPushed{
    WantListViewController *wantListVC = [[WantListViewController alloc] init];
    NSMutableArray *wantListArray = [mono[@"wantListArray"] mutableCopy];
    wantListVC.wantListArray = wantListArray;
    [self.navigationController pushViewController:wantListVC animated:YES];
}


-(void)wantButtonPushed{
    
    NSMutableArray *wantListArray = [mono[@"wantListArray"] mutableCopy];
    if(!wantListArray)
        wantListArray = [[NSMutableArray alloc] init];
    
    if([wantButton.titleLabel.text isEqualToString:@"WANT!"]){
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"StarBucks" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            wantButton.titleLabel.text = @"WANTED!";
            dic[@"user"] = [PFUser currentUser];
            dic[@"value"] = @"StarBucks";
            [wantListArray addObject:dic];
            mono[@"wantListArray"] = wantListArray;
            [mono saveInBackground];
            
            [wantMonoArray addObject:postId];
            [ud setObject:wantMonoArray forKey:@"wantMonoArray"];
            [ud synchronize];
        }]];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate     *nowDate  = [NSDate date];
        NSDate *birthday = [[NSUserDefaults standardUserDefaults] objectForKey:@"birthday"];
        NSInteger   year     = [[calendar components:NSCalendarUnitYear
                                            fromDate:birthday
                                              toDate:nowDate
                                             options:0] year];
        if(year > 18)
            [alert addAction:[UIAlertAction actionWithTitle:@"Lunch" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                wantButton.titleLabel.text = @"WANTED!";
                dic[@"user"] = [PFUser currentUser];
                dic[@"value"] = @"Lunch";
                [wantListArray addObject:dic];
                mono[@"wantListArray"] = wantListArray;
                [mono saveInBackground];
                
                [wantMonoArray addObject:postId];
                [ud setObject:wantMonoArray forKey:@"wantMonoArray"];
                [ud synchronize];
            }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Ability" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            wantButton.titleLabel.text = @"WANTED!";
            dic[@"user"] = [PFUser currentUser];
            dic[@"value"] = @"Ability";
            [wantListArray addObject:dic];
            mono[@"wantListArray"] = wantListArray;
            [mono saveInBackground];
            
            [wantMonoArray addObject:postId];
            [ud setObject:wantMonoArray forKey:@"wantMonoArray"];
            [ud synchronize];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"user", [PFUser currentUser]];
        NSDictionary *dic = [[wantListArray filteredArrayUsingPredicate:predicate] firstObject];
        NSInteger index = [wantListArray indexOfObject:dic];
        [wantListArray removeObjectAtIndex:index];
        mono[@"wantListArray"] = wantListArray;
        [mono saveInBackground];
        
        [wantMonoArray removeObject:postId];
        [ud setObject:wantMonoArray forKey:@"wantMonoArray"];
        [ud synchronize];
        wantButton.titleLabel.text = @"WANT!";
    }
}


@end
