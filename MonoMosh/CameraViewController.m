//
//  CameraViewController.m
//  MonoMosh
//
//  Created by 嶋本夏海 on 2016/02/02.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    YCameraViewController *camController = [[YCameraViewController alloc] initWithNibName:@"YCameraViewController" bundle:nil];
    camController.delegate=self;
    [self presentViewController:camController animated:YES completion:^{
        // completion code
    }];
}


-(void)didFinishPickingImage:(UIImage *)image{
    // Use image as per your need
    
    imgView = [[UIImageView alloc] initWithFrame:(CGRectMake(20, 80, 280, 280))];
    imgView.image = image;
    
    [self.view addSubview:imgView];
    
    
    
    nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 370, self.view.frame.size.width - 20, 30)];
    nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    nameTextField.delegate = self;
    [self.view addSubview:nameTextField];
    
    [nameTextField becomeFirstResponder];
    
    
    detailTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 410, self.view.frame.size.width - 20, 100)];
    detailTextField.borderStyle = UITextBorderStyleRoundedRect;
    detailTextField.delegate = self;
    [self.view addSubview:detailTextField];
    
    
    
    // initWithBarButtonSystemItemに、表示したいアイコンを指定します。
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                    target:self
                                    action:@selector(doneBtnPushed)];
    
    // ナビゲーションバーに追加する。
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
}

-(void)doneBtnPushed {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *contentsArray = [ud objectForKey:@"ud"];
    NSMutableArray *contentsMArray = [contentsArray mutableCopy];
    
    contentsMArray = [[NSMutableArray alloc] init];
    
    NSDictionary *contentsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                         imgView.image,@"image",
                         nameTextField.text,@"name",
                         detailTextField.text,@"contents",
                         nil];
    
    [contentsMArray addObject:contentsDic];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:contentsMArray];
    [ud setObject:data forKey:@"ud"];
    [ud synchronize];
    
    
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
    
    return;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)yCameraControllerdidSkipped{
    // Called when user clicks on Skip button on YCameraViewController view
}
-(void)yCameraControllerDidCancel{
    // Called when user clicks on "X" button to close YCameraViewController
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
