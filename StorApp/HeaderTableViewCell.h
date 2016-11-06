//
//  HeaderTableViewCell.h
//  Stor
//
//  Created by Darran Hall on 11/5/16.
//  Copyright © 2016 Stor App. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *backgroundViews;

@end
