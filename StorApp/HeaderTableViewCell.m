//
//  HeaderTableViewCell.m
//  Stor
//
//  Created by Darran Hall on 11/5/16.
//  Copyright © 2016 Stor App. All rights reserved.
//

#import "HeaderTableViewCell.h"

@implementation HeaderTableViewCell

- (void)awakeFromNib {
    self.backgroundViews.layer.cornerRadius = 10.f;
    self.backgroundViews.layer.masksToBounds = YES;
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
