//
//  CameraViewController.h
//  MonoMosh
//
//  Created by 嶋本夏海 on 2016/02/02.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCameraViewController.h"

@interface CameraViewController : UIViewController <YCameraViewControllerDelegate,UITextFieldDelegate> {
    
    UIImageView *imgView;
    UITextField *nameTextField;
    UITextField *detailTextField;
}

@end
