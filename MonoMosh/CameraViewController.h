//
//  CameraViewController.h
//  MonoMosh
//
//  Created by 嶋本夏海 on 2016/02/02.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "YCameraViewController.h"
#import "MBProgressHUD.h"

@interface CameraViewController : UIViewController <YCameraViewControllerDelegate,UITextFieldDelegate,UITextViewDelegate,MBProgressHUDDelegate> {

    IBOutlet UIImageView *imgView;
    IBOutlet UITextField *nameTextField;
    IBOutlet UITextView *detailTextView;
    
    BOOL isPosted;
    
    MBProgressHUD *hud;
}

@end
