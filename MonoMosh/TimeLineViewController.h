//
//  FirstViewController.h
//  MonoMosh
//
//  Created by 嶋本夏海 on 2016/02/02.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLineViewController : UICollectionViewController<UICollectionViewDataSource,UICollectionViewDelegate>{
    UIButton *moreButton;
    UIActivityIndicatorView *indicator;
}

@property(strong,nonatomic) NSMutableArray *monoArray;

-(void)loadMono;

@end

