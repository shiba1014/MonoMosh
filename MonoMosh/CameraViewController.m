//
//  CameraViewController.m
//  MonoMosh
//
//  Created by 嶋本夏海 on 2016/02/02.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import "CameraViewController.h"
#import "TimeLineViewController.h"
#import <Parse/Parse.h>

@interface CameraViewController ()
@end

@implementation CameraViewController

@synthesize postPhoto,postName,postDiscription,postId,isEdit;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.delegate = self;
    hud.mode = MBProgressHUDModeIndeterminate;
    
    nameTextField.delegate = self;
    nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    nameTextField.placeholder = @"Title";
    
    detailTextView.delegate = self;
    [[detailTextView layer] setCornerRadius:10.0];
    [detailTextView setClipsToBounds:YES];
    [[detailTextView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[detailTextView layer] setBorderWidth:0.5];
    detailTextView.text = @"Discription";
    detailTextView.textColor = [UIColor lightGrayColor];
    [self.view addSubview:detailTextView];
    
    // initWithBarButtonSystemItemに、表示したいアイコンを指定
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Done"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(doneBtnPushed)];
    
    // ナビゲーションバーに追加する。
    self.navigationItem.rightBarButtonItem = rightButton;
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Cancel"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(cancelPost)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    if(isEdit){
        imageView.image = postPhoto;
        nameTextField.text = postName;
        detailTextView.text = postDiscription;
        detailTextView.textColor = [UIColor blackColor];
    }
}

-(void)openCamera {
    YCameraViewController *camController = [[YCameraViewController alloc] initWithNibName:@"YCameraViewController" bundle:nil];
    camController.delegate=self;
    [self presentViewController:camController animated:YES completion:^{
        // completion code
    }];
}


-(void)viewWillAppear:(BOOL)animated {
    if (!isPosted && !isEdit) {
        [self openCamera];
    }
}

-(void)didFinishPickingImage:(UIImage *)image
{
    imageView.image = image;
    isPosted = YES;
}

-(void)cancelPost{
    UIAlertController *alert=   [UIAlertController
                                 alertControllerWithTitle:@"Warning!"
                                 message:@"編集内容を破棄します。よろしいですか?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   //Handel your yes please button action here
                                   if(!isEdit)
                                       self.tabBarController.selectedIndex = 0;
                                   else{
                                       [self.navigationController popViewControllerAnimated:YES];
                                       isEdit = YES;
                                   }
                                   imageView.image = nil;
                                   nameTextField.text = nil;
                                   detailTextView.text = nil;
                                   isPosted = NO;
                               }];
    UIAlertAction *cancelButton = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleDestructive
                                   handler:^(UIAlertAction * _Nonnull action) {
                                       
                                   }];
    
    [alert addAction:cancelButton];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)doneBtnPushed {
    if(detailTextView.isFirstResponder || nameTextField.isFirstResponder){
        [UIView animateWithDuration:0.6f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             // animation
                             self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 200, self.view.frame.size.width, self.view.frame.size.height);
                             
                         }
                         completion:^(BOOL finished){
                             // アニメーションが終わった後実行する処理
                             
                         }];
        
        [detailTextView resignFirstResponder];
        [nameTextField resignFirstResponder];
    }
    
    if([nameTextField.text isEqualToString:@""] || [detailTextView.text isEqualToString:@""]){
        UIAlertController *alert=   [UIAlertController
                                     alertControllerWithTitle:@"Miss!"
                                     message:@"空欄があります"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       //Handel your yes please button action here
                                       NSLog(@"OK");
                                       
                                   }];
        
        
        [alert addAction:okButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if(!isEdit)
        [self saveToParse];
    else
        [self changePost];
}

-(void)saveToParse{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    PFObject *object = [PFObject objectWithClassName:@"PostObject"];
    object[@"postName"] = nameTextField.text;
    object[@"postDiscription"] = detailTextView.text;
    object[@"postUser"] = [PFUser currentUser];
    NSData *imageData = UIImagePNGRepresentation(imageView.image);
    PFFile *imageFile = [PFFile fileWithName:@"monoPhoto" data:imageData];
    object[@"postPhoto"] = imageFile;
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            });
            self.tabBarController.selectedIndex = 0;
            
            UIAlertController *alert=   [UIAlertController
                                         alertControllerWithTitle:@"Completed!"
                                         message:@"投稿しました"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           //Handel your yes please button action here
                                           NSLog(@"OK");
                                           
                                       }];
            
            
            [alert addAction:okButton];
            [self presentViewController:alert animated:YES completion:nil];
            
            imageView.image = nil;
            nameTextField.text = nil;
            detailTextView.text = nil;
            isPosted = NO;
        }else{
            NSLog(@"Error:%@",error);
        }
    }];
}

-(void)changePost{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"PostObject"];
    [query whereKey:@"objectId" equalTo:postId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if(!error){
            isEdit = NO;
            object[@"postName"] = nameTextField.text;
            object[@"postDiscription"] = detailTextView.text;
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(succeeded){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                    });
                    
                    UIAlertController *alert=   [UIAlertController
                                                 alertControllerWithTitle:@"Completed!"
                                                 message:@"変更を保存しました"
                                                 preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *okButton = [UIAlertAction
                                               actionWithTitle:@"OK"
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
                                               {
                                                   //Handel your yes please button action here
                                                   NSLog(@"OK");
                                                   [self.navigationController popViewControllerAnimated:YES];
                                                   
                                                   imageView.image = nil;
                                                   nameTextField.text = nil;
                                                   detailTextView.text = nil;
                                                   isPosted = NO;
                                               }];
                    
                    
                    [alert addAction:okButton];
                    [self presentViewController:alert animated:YES completion:nil];
                    }
            }];
        }else{
            NSLog(@"Error:%@",error);
        }
    }];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if(!detailTextView.isFirstResponder) {
        [UIView animateWithDuration:0.6f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             // animation
                             self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 200, self.view.frame.size.width, self.view.frame.size.height);
                             
                         }
                         completion:^(BOOL finished){
                             // アニメーションが終わった後実行する処理
                             
                         }];
    }
    NSLog(@"textFieldShouldBeginEditing");
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    
    
    [UIView animateWithDuration:0.6f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         // animation
                         self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 200, self.view.frame.size.width, self.view.frame.size.height);
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    [textField resignFirstResponder];
    NSLog(@"textFieldShouldReturn");
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if (!nameTextField.isFirstResponder) {
        
        [UIView animateWithDuration:0.1f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             // animation
                             self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 200, self.view.frame.size.width, self.view.frame.size.height);
                             
                         }
                         completion:^(BOOL finished){
                             // アニメーションが終わった後実行する処理
                             
                         }];
    }
    
    NSLog(@"textViewShouldBeginEditing");
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (nameTextField.isFirstResponder || detailTextView.isFirstResponder) {
        

    [UIView animateWithDuration:0.1f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         // animation
                         self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 200, self.view.frame.size.width, self.view.frame.size.height);
                         
                     }
                     completion:^(BOOL finished){
                         // アニメーションが終わった後実行する処理
                         
                     }];
    }
    
    [nameTextField resignFirstResponder];
    [detailTextView resignFirstResponder];
    
    NSLog(@"touchesBegan");
}

-(void)yCameraControllerDidCancel{
    // Called when user clicks on "X" button to close YCameraViewController
    self.tabBarController.selectedIndex = 0;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Discription"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Discription";
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

/*
-(void)yCameraControllerdidSkipped{
    // Called when user clicks on Skip button on YCameraViewController view
}
 */


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
