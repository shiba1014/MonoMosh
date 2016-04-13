//
//  SearchViewController.h
//  MonoMosh
//
//  Created by Paul McCartney on 2016/04/13.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SearchViewController : UIViewController<UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UISegmentedControl *segmented;
    IBOutlet UICollectionView *collection;
    IBOutlet UITableView *table;
    PFQuery *query;
    UIActivityIndicatorView *indicator;
    NSMutableArray *resultArray;
}

@end
