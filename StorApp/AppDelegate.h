//
//  AppDelegate.h
//  Stor
//
//  Created by Darran Hall on 11/4/16.
//  Copyright © 2016 Stor App. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+Helper.h"
#import <CoreLocation/CoreLocation.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) CLLocationCoordinate2D userCoords;
@property (nonatomic, strong) NSString *userState;
@property (nonatomic, strong) NSString *userCity;

- (void)sendPaidMessage;
- (void)sendFailedMessage;


@end

