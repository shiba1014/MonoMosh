//
//  MMDatePickerView.h
//  MonoMosh
//
//  Created by Paul McCartney on 2016/03/29.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMDatePickerView : UIView

@property(weak, nonatomic)IBOutlet UIButton *doneButton;
@property(weak, nonatomic)IBOutlet UIDatePicker *datePicker;

+(instancetype)view;

@end
