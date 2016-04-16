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

@synthesize postId,postUserId,postUsername,postName,postDiscription,postPhoto,profileImage,postUser,mono,postState,postNum,friendNum,abilityStr,fromNotif;

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
    
    [wantMonoArray removeAllObjects];
    [ud setObject:wantMonoArray forKey:@"wantMonoArray"];
    [ud synchronize];
    
    if([wantMonoArray containsObject:postId])
        isWant = YES;
    else
        isWant = NO;
    
    [wantListButton addTarget:self action:@selector(wantListButtonPushed) forControlEvents:UIControlEventTouchUpInside];
    [optionButton addTarget:self action:@selector(tappedOption) forControlEvents:UIControlEventTouchUpInside];
    [doneButton addTarget:self action:@selector(doneButtonPushed) forControlEvents:UIControlEventTouchUpInside];
    [undoneButton addTarget:self action:@selector(undoneButtonPushed) forControlEvents:UIControlEventTouchUpInside];
    [wantButton addTarget:self action:@selector(wantButtonPushed) forControlEvents:UIControlEventTouchUpInside];
    
    if(fromNotif){
        [self getMono];
        return;
    }
    
    monoLabel.text = postName;
    detailLabel.text = postDiscription;
    monoImageView.image = postPhoto;
    
    if([postUserId isEqualToString:[PFUser currentUser].objectId]){
        wantButton.hidden = YES;
        if([postState isEqualToString:@"Sale"]){
            doneButton.hidden = YES;
            undoneButton.hidden = YES;
            stateImageView.hidden = YES;
        }else if([postState isEqualToString:@"Negotiation"]){
            wantListButton.hidden = YES;
            stateImageView.image = [UIImage imageNamed:@"negotiationLabel"];
        }else if([postState isEqualToString:@"SoldOut"]){
            doneButton.hidden = YES;
            undoneButton.hidden = YES;
            wantListButton.hidden = YES;
            stateImageView.image = [UIImage imageNamed:@"soldOutLabel"];
        }
    }else{
        optionButton.hidden = YES;
        wantListButton.hidden = YES;
        doneButton.hidden = YES;
        undoneButton.hidden = YES;
        if([postState isEqualToString:@"Sale"]){
            stateImageView.hidden = YES;
        }else if([postState isEqualToString:@"Negotiation"]){
            wantButton.hidden = YES;
            stateImageView.image = [UIImage imageNamed:@"negotiationLabel"];
        }else if([postState isEqualToString:@"SoldOut"]){
            wantButton.hidden = YES;
            stateImageView.image = [UIImage imageNamed:@"soldOutLabel"];
        }
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
        isWant = YES;
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
        myPageVC.postNum = postNum;
        myPageVC.friendNum = friendNum;
        myPageVC.abilityStr = abilityStr;
        [self.navigationController pushViewController:myPageVC animated:YES];
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FriendPage" bundle:[NSBundle mainBundle]];
        FriendPageViewController *friendPageVC = [storyboard instantiateInitialViewController];
        friendPageVC.profileImage = profileImage;
        friendPageVC.username = postUsername;
        friendPageVC.friendUser = postUser;
        friendPageVC.postNum = postNum;
        friendPageVC.friendNum = friendNum;
        friendPageVC.abilityStr = abilityStr;
        [self.navigationController pushViewController:friendPageVC animated:YES];
    }
}

-(void)getPostUser{
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" equalTo:postUserId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        postUser = (PFUser *)object;
        postUsername = object[@"usernameForUser"];
        postNum = [NSString stringWithFormat:@"%@",object[@"postNum"]];
        friendNum = [NSString stringWithFormat:@"%@",object[@"friendNum"]];
        abilityStr = object[@"ability"];
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
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [mono deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                UIAlertController *finishAlert = [UIAlertController alertControllerWithTitle:@"" message:@"投稿を削除しました" preferredStyle:UIAlertControllerStyleAlert];
                [finishAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSArray *viewControllers = [self.navigationController viewControllers];
                    UIViewController *viewController = [viewControllers objectAtIndex:viewControllers.count -1];
                    if([viewController isMemberOfClass:[TimeLineViewController class]])
                    {
                        //TODO:更新できない
                        TimeLineViewController *timelineVC = (TimeLineViewController *)viewController;
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"postId == %@",postId];
                        NSMutableDictionary *dic = [[[timelineVC.monoArray filteredArrayUsingPredicate:predicate] firstObject] mutableCopy];
                        NSUInteger index = [timelineVC.monoArray indexOfObject:dic];
                        [timelineVC.monoArray removeObjectAtIndex:index];
                        [timelineVC loadMono];
                        
                    }else if([viewController isMemberOfClass:[MyPageViewController class]])
                    {
                        MyPageViewController *mypageVC = (MyPageViewController *)viewController;
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"postId == %@",postId];
                        NSMutableDictionary *dic = [[[mypageVC.monoArray filteredArrayUsingPredicate:predicate] firstObject] mutableCopy];
                        NSUInteger index = [mypageVC.monoArray indexOfObject:dic];
                        [mypageVC.monoArray removeObjectAtIndex:index];
                        [mypageVC loadMono];
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }]];
                [self presentViewController:finishAlert animated:YES completion:nil];
            }
        }];
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
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
    wantListVC.postId = postId;
    wantListVC.postName = postName;
    [self.navigationController pushViewController:wantListVC animated:YES];
}

-(void)wantButtonPushed{
    
    NSMutableArray *wantListArray = [mono[@"wantListArray"] mutableCopy];
    if(!wantListArray)
        wantListArray = [[NSMutableArray alloc] init];
    
    if(!isWant){
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"StarBucks" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            wantButton.imageView.image = [UIImage imageNamed:@"wantedButton"];
            dic[@"user"] = [PFUser currentUser];
            dic[@"userId"] = [PFUser currentUser].objectId;
            dic[@"value"] = @"StarBucks";
            [wantListArray addObject:dic];
            mono[@"wantListArray"] = wantListArray;
            [mono saveInBackground];
            
            [wantMonoArray addObject:postId];
            [ud setObject:wantMonoArray forKey:@"wantMonoArray"];
            [ud synchronize];
            
            [PFUser currentUser][@"wantMonoArray"] = wantMonoArray;
            [[PFUser currentUser] saveInBackground];
            
            PFPush *push = [[PFPush alloc] init];
            NSString *channel = [NSString stringWithFormat:@"U%@",postUserId];
            NSString *message = [NSString stringWithFormat:@"%@ wants %@",[PFUser currentUser][@"usernameForUser"],postName];
            NSDictionary *data = @{
                                   @"alert":message,
                                   @"userId":[PFUser currentUser].objectId,
                                   @"postId":postId,
                                   @"content-available": @1,
                                   @"type":@"want"
                                   };
            [push setChannel:channel];
            [push setData:data];
            [push sendPushInBackground];
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
                wantButton.imageView.image = [UIImage imageNamed:@"wantedButton"];
                dic[@"user"] = [PFUser currentUser];
                dic[@"userId"] = [PFUser currentUser].objectId;
                dic[@"value"] = @"Lunch";
                [wantListArray addObject:dic];
                mono[@"wantListArray"] = wantListArray;
                [mono saveInBackground];
                
                [wantMonoArray addObject:postId];
                [ud setObject:wantMonoArray forKey:@"wantMonoArray"];
                [ud synchronize];
                
                [PFUser currentUser][@"wantMonoArray"] = wantMonoArray;
                [[PFUser currentUser] saveInBackground];
                
                PFPush *push = [[PFPush alloc] init];
                NSString *channel = [NSString stringWithFormat:@"U%@",postUserId];
                NSString *message = [NSString stringWithFormat:@"%@ wants %@",[PFUser currentUser][@"usernameForUser"],postName];
                NSDictionary *data = @{
                                       @"alert":message,
                                       @"userId":[PFUser currentUser].objectId,
                                       @"postId":postId,
                                       @"content-available": @1,
                                       @"type":@"want"
                                       };
                [push setChannel:channel];
                [push setData:data];
                [push sendPushInBackground];
            }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Ability" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            wantButton.imageView.image = [UIImage imageNamed:@"wantedButton"];
            dic[@"user"] = [PFUser currentUser];
            dic[@"userId"] = [PFUser currentUser].objectId;
            dic[@"value"] = @"Ability";
            [wantListArray addObject:dic];
            mono[@"wantListArray"] = wantListArray;
            [mono saveInBackground];
            
            [wantMonoArray addObject:postId];
            [ud setObject:wantMonoArray forKey:@"wantMonoArray"];
            [ud synchronize];
            
            [PFUser currentUser][@"wantMonoArray"] = wantMonoArray;
            [[PFUser currentUser] saveInBackground];
            
            PFPush *push = [[PFPush alloc] init];
            NSString *channel = [NSString stringWithFormat:@"U%@",postUserId];
            NSString *message = [NSString stringWithFormat:@"%@ wants %@",[PFUser currentUser][@"usernameForUser"],postName];
            NSDictionary *data = @{
                                   @"alert":message,
                                   @"userId":[PFUser currentUser].objectId,
                                   @"postId":postId,
                                   @"content-available": @1,
                                   @"type":@"want"
                                   };
            [push setChannel:channel];
            [push setData:data];
            [push sendPushInBackground];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        
        isWant = YES;
    }else{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"userId", [PFUser currentUser].objectId];
        NSDictionary *dic = [[wantListArray filteredArrayUsingPredicate:predicate] firstObject];
        NSInteger index = [wantListArray indexOfObject:dic];
        [wantListArray removeObjectAtIndex:index];
        mono[@"wantListArray"] = wantListArray;
        [mono saveInBackground];
        
        [wantMonoArray removeObject:postId];
        [ud setObject:wantMonoArray forKey:@"wantMonoArray"];
        [ud synchronize];
        wantButton.imageView.image = [UIImage imageNamed:@"wantButton"];
        isWant = NO;
    }
}

-(void)doneButtonPushed{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"モノを交渉成立とします。よろしいですか?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        stateImageView.backgroundColor = [UIColor magentaColor];
        doneButton.hidden = YES;
        undoneButton.hidden = YES;
        NSArray *viewControllers = [self.navigationController viewControllers];
        UIViewController *viewController = [viewControllers objectAtIndex:viewControllers.count -1];
        if([viewController isMemberOfClass:[TimeLineViewController class]]){
            TimeLineViewController *timelineVC = (TimeLineViewController *)viewController;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"postId == %@",postId];
            NSMutableDictionary *dic = [[[timelineVC.monoArray filteredArrayUsingPredicate:predicate] firstObject] mutableCopy];
            NSUInteger index = [timelineVC.monoArray indexOfObject:dic];
            dic[@"postState"] = @"SoldOut";
            timelineVC.monoArray[index] = dic;
            [timelineVC loadMono];
        }else if([viewController isMemberOfClass:[MyPageViewController class]]){
            MyPageViewController *mypageVC = (MyPageViewController *)viewController;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"postId == %@",postId];
            NSMutableDictionary *dic = [[[mypageVC.monoArray filteredArrayUsingPredicate:predicate] firstObject] mutableCopy];
            NSUInteger index = [mypageVC.monoArray indexOfObject:dic];
            dic[@"postState"] = @"SoldOut";
            mypageVC.monoArray[index] = dic;
            [mypageVC loadMono];
        }
        mono[@"postState"] = @"SoldOut";
        [mono saveInBackground];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
//    PFPush *push = [[PFPush alloc] init];
//    NSString *channel = [NSString stringWithFormat:@"U%@",postUserId];
//    NSString *message = [NSString stringWithFormat:@"The negotiation of %@ is completed!",postName];
//    NSDictionary *data = @{
//                           @"alert":message,
//                           @"userId":[PFUser currentUser].objectId,
//                           @"postId":postId,
//                           @"content-available": @1,
//                           @"type":@"negotiation"
//                           };
//    [push setChannel:channel];
//    [push setData:data];
//    [push sendPushInBackground];
}

-(void)undoneButtonPushed{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"モノを交渉不成立とします。よろしいですか? \n(不成立になると再び受取手を募集します)" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //TODO:wantListを初期化するかどうか
        stateImageView.backgroundColor = [UIColor cyanColor];
        doneButton.hidden = YES;
        undoneButton.hidden = YES;
        wantListButton.hidden = NO;
        NSArray *viewControllers = [self.navigationController viewControllers];
        UIViewController *viewController = [viewControllers objectAtIndex:viewControllers.count -1];
        if([viewController isMemberOfClass:[TimeLineViewController class]]){
            TimeLineViewController *timelineVC = (TimeLineViewController *)viewController;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"postId == %@",postId];
            NSMutableDictionary *dic = [[[timelineVC.monoArray filteredArrayUsingPredicate:predicate] firstObject] mutableCopy];
            NSUInteger index = [timelineVC.monoArray indexOfObject:dic];
            dic[@"postState"] = @"Sale";
            timelineVC.monoArray[index] = dic;
            [timelineVC loadMono];
        }else if([viewController isMemberOfClass:[MyPageViewController class]]){
            MyPageViewController *mypageVC = (MyPageViewController *)viewController;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"postId == %@",postId];
            NSMutableDictionary *dic = [[[mypageVC.monoArray filteredArrayUsingPredicate:predicate] firstObject] mutableCopy];
            NSUInteger index = [mypageVC.monoArray indexOfObject:dic];
            dic[@"postState"] = @"Sale";
            mypageVC.monoArray[index] = dic;
            [mypageVC loadMono];
        }
        mono[@"postState"] = @"SoldOut";
        [mono saveInBackground];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
//    PFPush *push = [[PFPush alloc] init];
//    NSString *channel = [NSString stringWithFormat:@"U%@",postUserId];
//    NSString *message = [NSString stringWithFormat:@"The negotiation of %@ is failed...",postName];
//    NSDictionary *data = @{
//                           @"alert":message,
//                           @"userId":[PFUser currentUser].objectId,
//                           @"postId":postId,
//                           @"content-available": @1,
//                           @"type":@"negotiation"
//                           };
//    [push setChannel:channel];
//    [push setData:data];
//    [push sendPushInBackground];
}

-(void)giveMono{
    stateImageView.backgroundColor = [UIColor yellowColor];
    wantListButton.hidden = YES;
    doneButton.hidden = NO;
    undoneButton.hidden = NO;
    mono[@"postState"] = @"Negotiation";
    [mono saveInBackground];
}

-(void)changePostWithName:(NSString*)name andDiscription:(NSString*)discription{
    monoLabel.text = name;
    detailLabel.text = discription;
//    mono[@"postName"] = name;
//    mono[@"postDiscription"] = discription;
//    [mono saveInBackground];
}

-(void)getMono{
    PFQuery *query = [PFQuery queryWithClassName:@"PostObject"];
    [query whereKey:@"objectId" equalTo:postId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if(!error){
            mono = object;
            postName = object[@"postName"];
            monoLabel.text = postName;
            postDiscription = object[@"postDiscription"];
            detailLabel.text = postDiscription;
            PFUser *postUser = object[@"postUser"];
            postUserId = postUser.objectId;
            postState = object[@"postState"];
            PFFile *imageFile = object[@"postPhoto"];
            [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                if(!error){
                    postPhoto = [UIImage imageWithData:data];
                    monoImageView.image = postPhoto;
                }
            }];
            
            if([postUserId isEqualToString:[PFUser currentUser].objectId]){
                wantButton.hidden = YES;
                if([postState isEqualToString:@"Sale"]){
                    doneButton.hidden = YES;
                    undoneButton.hidden = YES;
                    stateImageView.hidden = YES;
                }else if([postState isEqualToString:@"Negotiation"]){
                    wantListButton.hidden = YES;
                    stateImageView.image = [UIImage imageNamed:@"negotiationLabel"];
                }else if([postState isEqualToString:@"SoldOut"]){
                    doneButton.hidden = YES;
                    undoneButton.hidden = YES;
                    wantListButton.hidden = YES;
                    stateImageView.image = [UIImage imageNamed:@"soldOutLabel"];
                }
            }else{
                optionButton.hidden = YES;
                wantListButton.hidden = YES;
                doneButton.hidden = YES;
                undoneButton.hidden = YES;
                if([postState isEqualToString:@"Sale"]){
                    stateImageView.hidden = YES;
                }else if([postState isEqualToString:@"Negotiation"]){
                    wantButton.hidden = YES;
                    stateImageView.image = [UIImage imageNamed:@"negotiationLabel"];
                }else if([postState isEqualToString:@"SoldOut"]){
                    wantButton.hidden = YES;
                    stateImageView.image = [UIImage imageNamed:@"soldOutLabel"];
                }
            }
        }
    }];
}

@end
