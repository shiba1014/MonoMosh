//
//  MonoCollectionReusableView.h
//  MonoMosh
//
//  Created by Paul McCartney on 2016/02/06.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonoCollectionReusableView : UICollectionReusableView

@property(weak,nonatomic) IBOutlet UIImageView *profileImage;
@property(weak,nonatomic) IBOutlet UILabel *usernameLabel,*pointLabel,*postNumLabel;
@property(weak,nonatomic) IBOutlet UIButton *friendNumButton,*friendButton;


@end
