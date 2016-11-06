//
//  AppDelegate.m
//  Stor
//
//  Created by Darran Hall on 11/4/16.
//  Copyright © 2016 Stor App. All rights reserved.
//

#import "AppDelegate.h"
#import <AddressBook/AddressBook.h>
#import "ISMessages/ISMessages/Classes/ISMessages.h"
@interface AppDelegate () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *manager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Futura-Medium" size:18], NSFontAttributeName, nil]];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Futura-Medium" size:16], NSFontAttributeName, nil] forState:UIControlStateNormal];

    [[UILabel appearance] setSubstituteFontName:@"Futura-Medium"];


    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:30/255.f green:139/255.f blue:195/255.f alpha:1]];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    [self.manager requestWhenInUseAuthorization];
    self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    self.manager.distanceFilter = kCLDistanceFilterNone;
//    self.manager.allowsBackgroundLocationUpdates = YES;
    [self.manager startUpdatingLocation];

    
    // Override point for customization after application launch.
    return YES;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    NSLog(@"updating...");
    self.userCoords = [locations lastObject].coordinate;
    NSLog(@"current loc: %f, %f", self.userCoords.latitude, self.userCoords.longitude);
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:[locations lastObject]
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       for (CLPlacemark *placemark in placemarks) {
                           
                           self.userState = placemark.administrativeArea;
                           self.userCity = placemark.locality;
                           
                       }
                   }];
    
}

- (void)sendPaidMessage {
    
    [ISMessages showCardAlertWithTitle:@"Yay!" message:@"We've added this item to your tracker." iconImage:[UIImage imageNamed:@"isIconSuccess"] duration:5 hideOnSwipe:YES hideOnTap:YES alertType:ISAlertTypeSuccess alertPosition:ISAlertPositionBottom imageUrl:nil];
    
}

- (void)sendFailedMessage {
    
    ISMessages *card = [ISMessages cardAlertWithTitle:@"Whoops!" message:@"Looks like the payment didn't go through. Try another card?" iconImage:[UIImage imageNamed:@"isIconError"] duration:5 hideOnSwipe:YES hideOnTap:YES alertType:ISAlertTypeSuccess alertPosition:ISAlertPositionBottom imageUrl:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [card show:^{
            
        }];
        
    });
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
