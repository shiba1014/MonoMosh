//
//  CameraViewController.m
//  MonoMosh
//
//  Created by 嶋本夏海 on 2016/02/02.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import "CameraViewController.h"
#import "TimeLineViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self openCamera];
    
}

-(void)openCamera {
    YCameraViewController *camController = [[YCameraViewController alloc] initWithNibName:@"YCameraViewController" bundle:nil];
    camController.delegate=self;
    [self presentViewController:camController animated:YES completion:^{
        // completion code
    }];
}


-(void)viewWillAppear:(BOOL)animated {
    if (isPosted == NO) {
        [self openCamera];
    }
    
}

-(void)didFinishPickingImage:(UIImage *)image{
    
    imgView.image = image;
    
    nameTextField.delegate = self;
    nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    detailTextView.delegate = self;
    [[detailTextView layer] setCornerRadius:10.0];
    [detailTextView setClipsToBounds:YES];
    
    [[detailTextView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[detailTextView layer] setBorderWidth:0.5];
    
    [self.view addSubview:detailTextView];
    
    
    
    // initWithBarButtonSystemItemに、表示したいアイコンを指定
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                    target:self
                                    action:@selector(doneBtnPushed)];
    
    // ナビゲーションバーに追加する。
    self.navigationItem.rightBarButtonItem = rightButton;
    
    isPosted = YES;
}

-(void)doneBtnPushed {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *contentsArray = [ud objectForKey:@"ud"];
    NSMutableArray *contentsMArray = [contentsArray mutableCopy];
    
    contentsMArray = [[NSMutableArray alloc] init];
    
    NSDictionary *contentsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 imgView.image,@"image",
                                 nameTextField.text,@"name",
                                 detailTextView.text,@"contents",
                                 nil];
    
    [contentsMArray addObject:contentsDic];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:contentsMArray];
    [ud setObject:data forKey:@"ud"];
    [ud synchronize];
    
    self.tabBarController.selectedIndex = 0;
    
    
    UIAlertController *alert=   [UIAlertController
                                 alertControllerWithTitle:@"完了"
                                 message:@"投稿完了！"
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
    
    imgView.image = nil;
    nameTextField.text = nil;
    detailTextView.text = nil;
    isPosted = NO;
    
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
                         // アニメーションが終わった後実行する処理
                         
                     }];
    
    [textField resignFirstResponder];
    NSLog(@"textFieldShouldReturn");
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if (!nameTextField.isFirstResponder) {
        
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
