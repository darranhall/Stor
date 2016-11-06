//
//  AddListingTableViewController.h
//  Stor
//
//  Created by Darran Hall on 11/5/16.
//  Copyright © 2016 Stor App. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDFCurrencyTextField.h"

@interface AddListingTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *categoryField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;
@property (weak, nonatomic) IBOutlet UITextField *qualityField;
@property (weak, nonatomic) IBOutlet JDFCurrencyTextField *priceField;
@property (weak, nonatomic) IBOutlet UITextField *itemField;
@property (weak, nonatomic) IBOutlet UIImageView *previewImage;

@end
