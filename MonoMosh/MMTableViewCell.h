//
//  MMTableViewCell.h
//  MonoMosh
//
//  Created by Paul McCartney on 2016/04/05.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMTableViewCell : UITableViewCell{
    IBOutlet UIImageView *profileImageView;
    IBOutlet UILabel *usernameLabel;
}

@property(strong,nonatomic)UIImage *profileImage;
@property(weak,nonatomic) NSString *username;

@property IBOutlet UIImageView *valueImageView;

-(void)setCell;

@end
