//
//  ListingTableViewCell.h
//  Stor
//
//  Created by Darran Hall on 11/4/16.
//  Copyright © 2016 Stor App. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *listingImage;
@property (weak, nonatomic) IBOutlet UILabel *listingTitle;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityStateLabel;

@end
