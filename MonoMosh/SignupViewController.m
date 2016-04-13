//
//  SignupViewController.m
//  MonoMosh
//
//  Created by Paul McCartney on 2016/03/10.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import "SignupViewController.h"
#import "InitialSettingViewController.h"
#import "MBProgressHUD.h"

@interface SignupViewController ()

-(IBAction)facebook:(id)sender;
-(IBAction)twitter:(id)sender;

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)facebook:(id)sender{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    FBSDKLoginManager *manager = [[FBSDKLoginManager alloc] init];
    
//    [manager logInWithReadPermissions:@[@"public_profile",@"user_birthday",@"user_friends"] handler:
//     ^(FBSDKLoginManagerLoginResult *result, NSError *error) {

    [PFFacebookUtils logInWithPermissions:@[@"public_profile",@"user_birthday",@"user_friends"] block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(!user){
            NSLog(@"error%@",error);
        }else if (user.isNew){
            NSLog(@"signup with facebook");
            
            UIAlertController *ac =
            [UIAlertController alertControllerWithTitle:nil
                                                message:@"登録が完了いたしました"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction =
            [UIAlertAction actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       NSLog(@"OK button tapped.");
                                       InitialSettingViewController *ISVC = [[InitialSettingViewController alloc] init];
                                       [self presentViewController:ISVC animated:YES completion:nil];
                                   }];
            
            [ac addAction:okAction];
            [self presentViewController:ac animated:YES completion:nil];
            
        }else{
            NSLog(@"success login  with facebook");
            
            UIAlertController *ac =
            [UIAlertController alertControllerWithTitle:nil
                                                message:@"ログインが完了いたしました"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction =
            [UIAlertAction actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       NSLog(@"OK button tapped.");
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                   }];
            
            [ac addAction:okAction];
            [self presentViewController:ac animated:YES completion:nil];
        }
    }];
//     }];
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
