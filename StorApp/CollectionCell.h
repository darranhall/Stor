//
//  CollectionCell.h
//  YSLTransitionAnimatorDemo
//
//  Created by yamaguchi on 2015/05/13.
//  Copyright (c) 2015年 h.yamaguchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;

@property (nonatomic, weak) IBOutlet UIImageView *itemImage;
@property (nonatomic, weak) IBOutlet UILabel *itemLabel;

@end
