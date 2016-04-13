//
//  MMTableViewCell.m
//  MonoMosh
//
//  Created by Paul McCartney on 2016/04/05.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import "MMTableViewCell.h"

@implementation MMTableViewCell

- (void)awakeFromNib {
    // Initialization code
    profileImageView.image = _profileImage;
    usernameLabel.text = _username;
}

-(void)setCell{
    profileImageView.image = _profileImage;
    usernameLabel.text = _username;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
