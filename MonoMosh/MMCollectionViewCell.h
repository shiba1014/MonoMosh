//
//  MonoCollectionViewCell.h
//  MonoMosh
//
//  Created by Paul McCartney on 2016/02/03.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMCollectionViewCell : UICollectionViewCell

@property(weak, nonatomic) IBOutlet UIImageView *imageView,*shadowImage;
@property(weak, nonatomic) IBOutlet UILabel *monoName;
@end
