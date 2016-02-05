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

@interface CameraViewController : UIViewController <YCameraViewControllerDelegate,UITextFieldDelegate,UITextViewDelegate> {

    IBOutlet UIImageView *imgView;
    IBOutlet UITextField *nameTextField;
    IBOutlet UITextView *detailTextView;
    
    IBOutlet UIScrollView *scrollView;
}

@end
