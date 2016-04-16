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
    IBOutlet UIImageView *profileImageView,*monoImageView,*stateImageView;
    IBOutlet UILabel *usernameLabel,*monoLabel,*detailLabel;
    IBOutlet UIButton *optionButton,*wantListButton,*goodButton,*wantButton,*doneButton,*undoneButton;
    NSUserDefaults *ud;
    NSMutableArray *wantMonoArray;
    BOOL isWant;
}

@property(strong,nonatomic) NSString *postUserId,*postId,*postUsername,*postName,*postDiscription,*postState,*postNum,*friendNum,*abilityStr;
@property(strong,nonatomic) UIImage *postPhoto,*profileImage;
@property(strong,nonatomic) PFUser *postUser;
@property(strong,nonatomic) PFObject *mono;
@property BOOL isNegotiation,fromNotif;

-(IBAction)moveToUserPage;
-(void)giveMono;
-(void)changePostWithName:(NSString*)name andDiscription:(NSString*)discription;

@end
