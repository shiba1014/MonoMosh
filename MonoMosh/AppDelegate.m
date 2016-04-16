//
//  AppDelegate.m
//  MonoMosh
//
//  Created by 嶋本夏海 on 2016/02/02.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <PFFacebookUtils.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios/guide#local-datastore
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"XpOipgfZqnOLY1saJ4wYeHK3ve0znOGo4YUhphss"
                  clientKey:@"cS8bYsh0nHHblhZsEV308ZS6c3njENlJUAdhZ4oc"];
    
    [PFFacebookUtils initializeFacebook];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:0.106 green:0.506 blue:0.243 alpha:1.000];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    NSString *channel = [NSString stringWithFormat:@"U%@",[PFUser currentUser].objectId];
    currentInstallation.channels = @[ channel ];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if(localNotification == nil) {
        return;
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSString *alertString = [[userInfo objectForKey:@"aps"] valueForKey:@"alert"];
    NSString *userId = [userInfo valueForKey:@"userId"];
    NSString *postId = [userInfo valueForKey:@"postId"];
    NSString *type = [userInfo valueForKey:@"type"];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber++;
    
    NSMutableArray *notifArray = [[NSMutableArray alloc] initWithArray:[ud arrayForKey:@"notif"]];
    NSMutableDictionary *notifDic = [NSMutableDictionary dictionary];
    
    if([type isEqualToString:@"want"]){
        
        PFQuery *query = [PFUser query];
        [query whereKey:@"objectId" equalTo:userId];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object,NSError *error){
            if(!error){
                [notifDic setObject:alertString forKey:@"alertStr"];
                [notifDic setObject:userId forKey:@"userId"];
                [notifDic setObject:postId forKey:@"postId"];
                [notifDic setObject:@"want" forKey:@"type"];
                [notifArray insertObject:notifDic atIndex:0];
                [ud setObject:notifArray forKey:@"notif"];
                [ud synchronize];
                
                PFFile *imageFile = object[@"profileImageFile"];
                [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error){
                    if(!error){
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@",object.objectId];
                        NSMutableDictionary *dic = [[[notifArray filteredArrayUsingPredicate:predicate] firstObject] mutableCopy];
                        NSUInteger index = [notifArray indexOfObject:dic];
                        [dic setObject:imageData forKey:@"image"];
                        [notifArray replaceObjectAtIndex:index withObject:dic];
                        [ud setObject:notifArray forKey:@"notifArray"];
                        [ud synchronize];
                    }
                }];
            }
        }];
    }else if([type isEqualToString:@"negotiation"]){
        PFQuery *query = [PFQuery queryWithClassName:@"PostObject"];
        [query whereKey:@"objectId" equalTo:postId];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if(!error){
                [notifDic setObject:alertString forKey:@"alertStr"];
                [notifDic setObject:userId forKey:@"userId"];
                [notifDic setObject:postId forKey:@"postId"];
                [notifDic setObject:@"negotiation" forKey:@"type"];
                [notifArray insertObject:notifDic atIndex:0];
                [ud setObject:notifArray forKey:@"notif"];
                [ud synchronize];
                PFFile *imageFile = object[@"postPhoto"];
                [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error){
                    if(!error){
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@",object.objectId];
                        NSMutableDictionary *dic = [[[notifArray filteredArrayUsingPredicate:predicate] firstObject] mutableCopy];
                        NSUInteger index = [notifArray indexOfObject:dic];
                        [dic setObject:imageData forKey:@"image"];
                        [notifArray replaceObjectAtIndex:index withObject:dic];
                        [ud setObject:notifArray forKey:@"notifArray"];
                        [ud synchronize];
                    }
                }];
            }
        }];
    }
        
        UIApplicationState applicationState = [[UIApplication sharedApplication] applicationState];
        if (applicationState == UIApplicationStateActive) {
            //TODO:フォアグラウンドだとバナーが出ない
            [PFPush handlePush:userInfo];
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }
    completionHandler(UIBackgroundFetchResultNewData);
}


@end
