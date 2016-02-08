//
//  ThirdViewController.h
//  MonoMosh
//
//  Created by 嶋本夏海 on 2016/02/02.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotifViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray *notifArray, *imgArray, *labelArray;
    UIImage *profileImage;
    NSString *userName, *monoName;
    int point;
    
    IBOutlet UITableView *table;
    
}

@end