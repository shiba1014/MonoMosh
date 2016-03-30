//
//  FriendPageViewController.h
//  MonoMosh
//
//  Created by Paul McCartney on 2016/02/07.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FriendPageViewController : UICollectionViewController{
    NSMutableArray *monoArray;
    UIButton *moreButton;
    UIActivityIndicatorView *indicator;
}

@property(strong,nonatomic) UIImage *profileImage;
@property(strong,nonatomic) NSString *username,*friendUserId,*friendUsername;
@property(strong,nonatomic) PFUser *friendUser;

@end
