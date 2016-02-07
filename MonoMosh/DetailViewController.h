//
//  DetailViewController.h
//  MonoMosh
//
//  Created by Paul McCartney on 2016/02/05.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController<UITextViewDelegate>

@property(weak,nonatomic) IBOutlet UIImageView *profileImageView,*monoImageView;
@property(weak,nonatomic) IBOutlet UILabel *usernameLabel,*monoLabel,*detailLabel;
@property(weak,nonatomic) IBOutlet UIButton *optionButton,*wantButton;

@end
