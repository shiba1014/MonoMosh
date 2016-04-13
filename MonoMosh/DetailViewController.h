//
//  DetailViewController.h
//  MonoMosh
//
//  Created by Paul McCartney on 2016/02/05.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface DetailViewController : UIViewController<UITextViewDelegate>{
    IBOutlet UIImageView *profileImageView,*monoImageView;
    IBOutlet UILabel *usernameLabel,*monoLabel,*detailLabel;
    IBOutlet UIButton *optionButton,*wantListButton,*goodButton,*wantButton;
    NSUserDefaults *ud;
    NSMutableArray *wantMonoArray;
}

@property(strong,nonatomic) NSString *postUserId,*postId,*postUsername,*postName,*postDiscription;
@property(strong,nonatomic) UIImage *postPhoto,*profileImage;
@property(strong,nonatomic) PFUser *friendUser;
@property(strong,nonatomic) PFObject *mono;

-(IBAction)moveToUserPage;

@end
