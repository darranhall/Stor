//
//  ListingTableViewController.m
//  Stor
//
//  Created by Darran Hall on 11/4/16.
//  Copyright © 2016 Stor App. All rights reserved.
//

#import "ListingTableViewController.h"
#import "XXXRoundMenuButton.h"
#import "ListingTableViewCell.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "DetailTableViewController.h"
@interface ListingTableViewController () 
@property (nonatomic, strong) NSArray *storage;
@property (nonatomic, strong) XXXRoundMenuButton *roundMenu;

@end

@implementation ListingTableViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self getListings];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)getListings {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:@"http://192.73.235.134:8070/api/listings" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSArray *array = (NSArray*)responseObject;
        [self.tableView reloadData];
        self.storage = array;
        NSLog(@"JSON: %@", responseObject);
        [self.tableView reloadData];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 170;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.storage count];;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *temp = [self.storage objectAtIndex:indexPath.row];
    ListingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell"];
    
    if(!cell){
        
        UINib *nib = [UINib nibWithNibName:@"ListingTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"ListCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell"];
        
    }
    
    cell.listingTitle.text = [temp objectForKey:@"itemName"];
    [cell.listingImage setImageWithURL:[NSURL URLWithString:[temp objectForKey:@"imageUrl"]]];
    cell.priceLabel.text = [temp objectForKey:@"price"];
    cell.conditionLabel.text = [NSString stringWithFormat:@"Condition: %@", [temp objectForKey:@"condition"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cityStateLabel.text = [temp objectForKey:@"cityState"];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

}

#pragma mark -- YSLTransitionAnimatorDataSource
- (UIImageView *)pushTransitionImageView
{
    ListingTableViewCell *cell = (ListingTableViewCell *)[self.tableView cellForRowAtIndexPath:[[self.tableView indexPathsForSelectedRows] firstObject]];
    return cell.listingImage;
}

- (UIImageView *)popTransitionImageView
{
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
