//
//  DetailTableViewController.m
//  Stor
//
//  Created by Darran Hall on 11/5/16.
//  Copyright © 2016 Stor App. All rights reserved.
//

#import "DetailTableViewController.h"
#import "HeaderTableViewCell.h"
#import "MapTableViewCell.h"
#import "DescriptionTableViewCell.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "AppDelegate.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <PassKit/PassKit.h>
#import <PassKit/PKConstants.h>
#import "ISMessages/ISMessages/Classes/ISMessages.h"
@interface DetailTableViewController () <PKPaymentAuthorizationViewControllerDelegate>
@property (nonatomic) AppDelegate *delegate;
@property (nonatomic) CLLocationCoordinate2D eventLoc;
@property (nonatomic) BOOL approved;
@property (nonatomic, strong) UIButton *checkout;
@end

@implementation DetailTableViewController

- (void)closeView {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"unfadeButton" object:nil];
        
    }];
    
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    
    
    NSLog(@"Payment was authorized: %@", payment);
    
    // do an async call to the server to complete the payment.
    // See PKPayment class reference for object parameters that can be passed
    BOOL asyncSuccessful = FALSE;
    
    // When the async call is done, send the callback.
    // Available cases are:
    //    PKPaymentAuthorizationStatusSuccess, // Merchant auth'd (or expects to auth) the transaction successfully.
    //    PKPaymentAuthorizationStatusFailure, // Merchant failed to auth the transaction.
    //
    //    PKPaymentAuthorizationStatusInvalidBillingPostalAddress,  // Merchant refuses service to this billing address.
    //    PKPaymentAuthorizationStatusInvalidShippingPostalAddress, // Merchant refuses service to this shipping address.
    //    PKPaymentAuthorizationStatusInvalidShippingContact        // Supplied contact information is insufficient.
    
    if(asyncSuccessful) {
        completion(PKPaymentAuthorizationStatusSuccess);
        self.approved = YES;
        // do something to let the user know the status
        
        NSLog(@"Payment was successful");
        
        //        [Crittercism endTransaction:@"checkout"];
        
    } else {
        completion(PKPaymentAuthorizationStatusFailure);
        self.approved = NO;
        // do something to let the user know the status
        
        NSLog(@"Payment was unsuccessful");
        
    }
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UINib *nib = [UINib nibWithNibName:@"HeaderTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"HeaderCell"];
    UINib *nib1 = [UINib nibWithNibName:@"DescriptionTableViewCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"DescCell"];
    UINib *nib2 = [UINib nibWithNibName:@"MapTableViewCell" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:@"MapCell"];

    NSString *coords = [self.storageDict objectForKey:@"coords"];
    
    NSArray *coordsArr = [coords componentsSeparatedByString:@","];
    
    self.eventLoc = CLLocationCoordinate2DMake([coordsArr[0] doubleValue], [coordsArr[1] doubleValue]);

    
    _checkout = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.tableView.frame.size.width, 50)];
    
    [_checkout addTarget:self action:@selector(proceedToCheckout:) forControlEvents:UIControlEventTouchUpInside];
    [_checkout setTitle:[NSString stringWithFormat:@"Pay %@ for Item", [self.storageDict objectForKey:@"price"]] forState:UIControlStateNormal];
    _checkout.backgroundColor = [UIColor colorWithRed:63/255.f green:195/255.f blue:128/255.f alpha:1];
    _checkout.titleLabel.textColor = [UIColor whiteColor];
   [self.view addSubview:_checkout];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(closeView)];
        
        self.navigationItem.leftBarButtonItem = item;
        
    }
    
    NSLog(@"dict is: %@", self.storageDict);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.tableView.estimatedRowHeight = 200;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView reloadData];
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    self.tableView.tableFooterView = view;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.checkout.frame = CGRectMake(0, self.view.frame.size.height - 94, self.tableView.frame.size.width, 50);
    
}

- (void)proceedToCheckout:(id)sender {

    if([PKPaymentAuthorizationViewController canMakePayments]) {
        
        NSLog(@"Woo! Can make payments!");
        
        PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
        
        NSString *amount = [self.storageDict objectForKey:@"price"];
        NSString *newAmount = [amount stringByReplacingOccurrencesOfString:@"$" withString:@""];
        NSString *newAmount1 = [newAmount stringByReplacingOccurrencesOfString:@"," withString:@""];


        double itemCost = [newAmount1 doubleValue];
        
        double multiplier = 0.0;
        
        if ([[_storageDict objectForKey:@"category"] isEqualToString:@"Home and Furniture"]) {
            
            multiplier = 1.25;
            
        }
        
        if ([[_storageDict objectForKey:@"category"] isEqualToString:@"Electronics"]) {
            
            multiplier = 1.15;
            
        }
        
        if ([[_storageDict objectForKey:@"category"] isEqualToString:@"Mobile Phones"]) {
            
            multiplier = 1.12;
            
        }
        
        if ([[_storageDict objectForKey:@"category"] isEqualToString:@"Artistry"]) {
            
            multiplier = 1.1;
            
        }
        
        if ([[_storageDict objectForKey:@"category"] isEqualToString:@"Lifestyle"]) {
            
            multiplier = 1.15;
            
        }
        
        double totalCost = itemCost * multiplier;
        
        double shippingCost = itemCost * (multiplier - 1);

        
        NSLog(@"numbers %f, %f, string value %@", itemCost, shippingCost, [self.storageDict objectForKey:@"price"]);
        
        NSDecimalNumber *num = [[NSDecimalNumber alloc] initWithDouble:itemCost];
        
        NSDecimalNumber *num1 = [[NSDecimalNumber alloc] initWithDouble:shippingCost];
        
        NSDecimalNumber *total = [[NSDecimalNumber alloc] initWithDouble:totalCost];
        
        PKPaymentSummaryItem *widget1 = [PKPaymentSummaryItem summaryItemWithLabel:[self.storageDict objectForKey:@"itemName"]
                                                                            amount:num];
        
        PKPaymentSummaryItem *widget2 = [PKPaymentSummaryItem summaryItemWithLabel:@"Delivery Fees"
                                                                            amount:num1];
        
        PKPaymentSummaryItem *totaldec = [PKPaymentSummaryItem summaryItemWithLabel:@"Stor Delivery"
                                                                            amount:total];

        request.paymentSummaryItems = @[widget1, widget2, totaldec];
        request.countryCode = @"US";
        request.currencyCode = @"USD";
        request.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa, PKPaymentNetworkDiscover];
        request.merchantIdentifier = @"merchant.us.storapp.Stor";
        request.merchantCapabilities = PKMerchantCapabilityDebit;
        
        PKPaymentAuthorizationViewController *paymentPane = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
        paymentPane.delegate = self;
        [self presentViewController:paymentPane animated:TRUE completion:nil];
        
    } else {
        NSLog(@"This device cannot make payments");
    }

    
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    NSLog(@"Finishing payment view controller");
    
    // hide the payment window
    
    [controller dismissViewControllerAnimated:TRUE completion:^{
        
        if (_approved == YES) {
            
            [_delegate sendPaidMessage];
            
        } else {
            
            [_delegate sendFailedMessage];

        }
        
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 200.f;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect frame = self.checkout.frame;
    frame.origin.y = scrollView.contentOffset.y + self.tableView.frame.size.height - self.checkout.frame.size.height;
    self.checkout.frame = frame;
    
    [self.view bringSubviewToFront:self.checkout];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        HeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell" forIndexPath:indexPath];
        
        if(!cell){
            
            UINib *nib = [UINib nibWithNibName:@"HeaderTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:@"HeaderCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
            
        }
        
        [cell.backgroundImageView setImageWithURL:[NSURL URLWithString:[self.storageDict objectForKey:@"imageUrl"]]];
        cell.descriptionLabel.text = [self.storageDict objectForKey:@"itemName"];
        
        return cell;
        
    }
    
    if (indexPath.row == 1) {
        
        DescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DescCell" forIndexPath:indexPath];
        
        if(!cell){
            
            UINib *nib = [UINib nibWithNibName:@"DescriptionTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:@"DescCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"DescCell"];
            
        }
        
        cell.descriptionLabel.text = [self.storageDict objectForKey:@"description"];
        cell.conditionLabel.text = [self.storageDict objectForKey:@"condition"];
        return cell;
        
    }
    
    if (indexPath.row == 2) {
        
        MapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MapCell" forIndexPath:indexPath];
        
        if(!cell){
            
            UINib *nib = [UINib nibWithNibName:@"MapTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:@"MapCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"MapCell"];
            
        }
        
        cell.cityStateLabel.text = [self.storageDict objectForKey:@"cityState"];
        
        MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.eventLoc];
        MKPlacemark *userMark = [[MKPlacemark alloc] initWithCoordinate:self.delegate.userCoords];
        
        [directionsRequest setSource:[[MKMapItem alloc] initWithPlacemark:userMark]];
        [directionsRequest setDestination:[[MKMapItem alloc] initWithPlacemark:placemark]];
        directionsRequest.transportType = MKDirectionsTransportTypeAutomobile;
        MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
            if (error) {
                NSLog(@"Error %@", error.description);
            } else {
                MKRoute *routeDetails = response.routes.lastObject;
//                cell.milesLabel.text = [NSString stringWithFormat:@"%0.1f", routeDetails.distance/1609.344];
                long eta = routeDetails.expectedTravelTime / 60;
//                cell.etaLabel.text = [NSString stringWithFormat:@"%ld", eta];
                
            }
        }];
        
        MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
        
        MKCoordinateSpan span = {
            .006000000,
            .006000000
        };
        
        options.region = MKCoordinateRegionMake(self.eventLoc, span);
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            options.size = CGSizeMake(768, 500);
        else
            options.size = CGSizeMake(414, 210);

        options.scale = [UIScreen mainScreen].scale;
        
        
        
        MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
        dispatch_queue_t executeOnBackground = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        [snapshotter startWithQueue:executeOnBackground completionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!error) {
                    cell.mapImage.image = snapshot.image;
                }
            });
        }];

        
        return cell;
        
    }
    
    return nil;
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
