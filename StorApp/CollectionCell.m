//
//  CollectionViewController.m
//  Stor
//
//  Created by Darran Hall on 11/4/2016.
//  Copyright (c) 2016 Stor App. All rights reserved.
//


#import "CollectionCell.h"
#import "NGAParallaxMotion.h"
@implementation CollectionCell

- (void)awakeFromNib {
    // Initialization code
    self.contentView.layer.cornerRadius = 7.0f;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.parallaxIntensity = 10;
    self.itemLabel.parallaxIntensity = 7;
    self.conditionLabel.parallaxIntensity = 7;
}

@end
