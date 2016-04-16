//
//  WantListViewController.h
//  MonoMosh
//
//  Created by Paul McCartney on 2016/04/11.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface WantListViewController : UITableViewController

@property NSMutableArray *wantListArray;
@property NSString *postId,*postName;

@end
