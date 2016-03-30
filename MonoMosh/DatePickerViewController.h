//
//  DatePickerViewController.h
//  MonoMosh
//
//  Created by Paul McCartney on 2016/03/16.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerViewControllerDelegate;

@interface DatePickerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) id<DatePickerViewControllerDelegate> delegate;

-(IBAction)closePickerView:(id)sender;

@end

@protocol DatePickerViewControllerDelegate <NSObject>

-(void)applySelectedString:(NSDate *)str;
-(void)closePickerView:(DatePickerViewController *)controller;

@end