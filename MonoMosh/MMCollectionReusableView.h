//
//  MonoCollectionReusableView.h
//  MonoMosh
//
//  Created by Paul McCartney on 2016/02/06.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMCollectionReusableView : UICollectionReusableView{
    IBOutlet UIImageView *profileImageView;
    IBOutlet UILabel *usernameLabel,*pointLabel,*postNumLabel,*friendNumLabel,*abilityLabel;
}

@property(weak,nonatomic) NSString *username,*postNum,*friendNum,*abilityStr;
@property(weak,nonatomic) UIImage *profileImage;
@property(weak,nonatomic) IBOutlet UIButton *friendNumButton,*friendButton;

-(void)setHeader;

@end
