//
//  MonoCollectionReusableView.m
//  MonoMosh
//
//  Created by Paul McCartney on 2016/02/06.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import "MMCollectionReusableView.h"

@implementation MMCollectionReusableView

- (void)awakeFromNib {
    // Initialization code
    profileImageView.image = self.profileImage;
    usernameLabel.text = self.username;
    postNumLabel.text = self.postNum;
    friendNumLabel.text = self.friendNum;
    abilityLabel.text = self.abilityStr;
}

-(void)setHeader{
    profileImageView.image = self.profileImage;
    usernameLabel.text = self.username;
    postNumLabel.text = self.postNum;
    friendNumLabel.text = self.friendNum;
    abilityLabel.text = self.abilityStr;
}

@end
