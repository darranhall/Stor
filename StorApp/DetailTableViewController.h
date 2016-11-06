//
//  DetailTableViewController.h
//  Stor
//
//  Created by Darran Hall on 11/5/16.
//  Copyright © 2016 Stor App. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableViewController : UITableViewController
@property (nonatomic, strong) UIImage *headerImage;
@property (nonatomic, strong) NSDictionary *storageDict;

typedef NS_ENUM(NSInteger, SACategory)
{
    SACategoryElectronics,
    SACategoryPhones,
    SACategoryFurniture,
    SACategoryArt,
    SACategoryLifestyle
};

@end
