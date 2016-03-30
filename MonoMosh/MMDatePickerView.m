//
//  MMDatePickerView.m
//  MonoMosh
//
//  Created by Paul McCartney on 2016/03/29.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import "MMDatePickerView.h"

@implementation MMDatePickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)view
{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    id view = [nib instantiateWithOwner:self options:nil][0];
    return view;
}

- (void)awakeFromNib {
    // Initialization code
}

@end
