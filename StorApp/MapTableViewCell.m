//
//  MapTableViewCell.m
//  Stor
//
//  Created by Darran Hall on 11/5/16.
//  Copyright © 2016 Stor App. All rights reserved.
//

#import "MapTableViewCell.h"

@implementation MapTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundViews.layer.cornerRadius = 10.f;
    self.backgroundViews.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
