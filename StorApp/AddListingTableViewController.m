//
//  AddListingTableViewController.m
//  Stor
//
//  Created by Darran Hall on 11/5/16.
//  Copyright © 2016 Stor App. All rights reserved.
//

#import "AddListingTableViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AFNetworking/AFNetworking.h>
#import "AppDelegate.h"
#import "ISMessages/ISMessages/Classes/ISMessages.h"
#import <SGNavigationProgress/UINavigationController+SGProgress.h>

@interface AddListingTableViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *picker1;
@property (nonatomic, strong) UIPickerView *picker2;
@property (nonatomic, strong) NSArray *conditionArray;
@property (nonatomic, strong) NSArray *categoryArray;

@end

@implementation AddListingTableViewController

- (void)closeView {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

-(void)submitAndSend:(UIButton*)sender {

    sender.enabled = NO;
    sender.titleLabel.alpha = .6f;
    NSData *data = UIImageJPEGRepresentation(self.previewImage.image, .9f);
    [self uploadImageWithData:data];
    
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
        UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont fontWithName:@"Futura-Medium" size:19]];
        [tView setTextAlignment:NSTextAlignmentCenter];
        tView.numberOfLines=3;
    }
    // Fill the label text here
    if ([pickerView isEqual:_picker1]) {
    tView.text=[_categoryArray objectAtIndex:row];
    return tView;
    }
    
    if ([pickerView isEqual:_picker2]) {
        
        tView.text=[_conditionArray objectAtIndex:row];
        return tView;
    }
    return nil;
}

-(void)uploadImageWithData:(NSData*)imageData {
    NSString *string = [NSString stringWithFormat:@"%u", arc4random_uniform(512000000000)];
    
    [self.navigationController setSGProgressPercentage:0.f andTintColor:[UIColor whiteColor]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableSet *contentTypes = [[NSMutableSet alloc] initWithSet:manager.responseSerializer.acceptableContentTypes];
    [contentTypes addObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = contentTypes;
    [manager setTaskDidSendBodyDataBlock:^(NSURLSession *session, NSURLSessionTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        //during the progress
        double up = [[NSNumber numberWithLongLong:totalBytesSent] doubleValue];
        double total = [[NSNumber numberWithLongLong:totalBytesExpectedToSend] doubleValue];
        NSLog(@"%f of %f", up, total);
        NSLog(@"did a transfer");
        NSLog(@"%f progress", up/total);
        CGFloat upFloat = up/total;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.navigationController setSGProgressPercentage:upFloat*100 andTitle:@"Uploading..."];
            
        });
        
    }];
    
    [manager POST:[NSString stringWithFormat:@"http://192.73.235.134/upload.php"] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:imageData name:@"userfile" fileName:[NSString stringWithFormat:@"userfile%@.%@",string,@"jpg"] mimeType:[NSString stringWithFormat:@"userfile/%@",@"jpg"]];
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSString *url = [NSString stringWithFormat:@"http://192.73.235.134/img/userfile%@.%@",string, @"jpg"];
        NSString* newStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];

        NSLog(@"success! response: %@", newStr);
        
        [self signUpUserWithAvatarLink:url];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
}

-(void)signUpUserWithAvatarLink:(NSString*)string {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSString *coords = [NSString stringWithFormat:@"%f, %f", delegate.userCoords.latitude, delegate.userCoords.longitude];
    NSString *cityState = [NSString stringWithFormat:@"%@, %@", delegate.userCity, delegate.userState];
    [self.navigationController setSGProgressPercentage:100.f andTitle:@"Finalizing..."];

    NSString *initial = [NSString stringWithFormat:@"http://192.73.235.134:8070/api/listings?imageUrl=%@&itemName=%@&desc=%@&coords=%@&condition=%@&price=%@&category=%@&cityState=%@", string, self.itemField.text, self.descriptionField.text, coords, self.qualityField.text, self.priceField.text, self.categoryField.text, cityState];
    NSString *finalUrl = [initial stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableSet *contentTypes = [[NSMutableSet alloc] initWithSet:manager.responseSerializer.acceptableContentTypes];
    [contentTypes addObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = contentTypes;
    
    [manager POST:finalUrl parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.navigationController finishSGProgress];
        
        [self dismissViewControllerAnimated:YES completion:^{
            
            [ISMessages showCardAlertWithTitle:@"Done!" message:@"Your listing has been posted" iconImage:[UIImage imageNamed:@"isSuccessIcon"] duration:5 hideOnSwipe:YES hideOnTap:YES alertType:ISAlertTypeSuccess alertPosition:ISAlertPositionBottom imageUrl:nil];
            
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}




- (void)viewDidLoad {
    
    _categoryArray = [NSArray arrayWithObjects:@"Mobile Phones", @"Home and Furniture", @"Electronics", @"Lifestyle", @"Artistry", nil];
    
    _conditionArray = [NSArray arrayWithObjects:@"Very Used", @"Used", @"Good", @"Very Good", @"Mint", nil];
    

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(closeView)];
    
    UIButton *bottomButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
//    bottomButton.titleLabel.font = [UIFont fontWithName:@"Futura-Medium" size:17];
    [bottomButton setTitle:@"Submit!" forState:UIControlStateNormal];
    bottomButton.backgroundColor = [UIColor colorWithRed:63/255.f green:195/255.f blue:128/255.f alpha:1];
    bottomButton.titleLabel.textColor = [UIColor whiteColor];
    
    [bottomButton addTarget:self action:@selector(submitAndSend:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationController.view addSubview:bottomButton];
    
    self.navigationItem.leftBarButtonItem = item;
    
    [super viewDidLoad];
    self.itemField.font = [UIFont fontWithName:@"Futura-Medium" size:15];
    self.priceField.font = [UIFont fontWithName:@"Futura-Medium" size:15];
    self.qualityField.font = [UIFont fontWithName:@"Futura-Medium" size:15];
    self.categoryField.font = [UIFont fontWithName:@"Futura-Medium" size:15];
    self.descriptionField.font = [UIFont fontWithName:@"Futura-Medium" size:15];

    self.itemField.delegate = self;
    self.priceField.delegate = self;
    self.qualityField.delegate = self;
    self.categoryField.delegate = self;
    self.descriptionField.delegate = self;
    self.priceField.placeholder = @"Price of item";
    self.previewImage.image = [[UIImage imageNamed:@"blank"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.previewImage.tintColor = [UIColor whiteColor];
    self.previewImage.backgroundColor = [UIColor colorWithWhite:.8 alpha:1];
    self.previewImage.layer.cornerRadius = 10.f;
    self.previewImage.layer.masksToBounds = YES;
    
    self.picker1 = [[UIPickerView alloc] init];
    self.picker2 = [[UIPickerView alloc] init];

    _picker1.dataSource = self;
    _picker1.delegate = self;
    _picker2.delegate = self;
    _picker2.delegate = self;
    
    self.categoryField.inputView = _picker1;
    self.qualityField.inputView = _picker2;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSString *titleYouWant = [pickerView.delegate pickerView:pickerView titleForRow:row forComponent:0];
    if ([pickerView isEqual:_picker1])
        self.categoryField.text = titleYouWant;
    
    if ([pickerView isEqual:_picker2])
        self.qualityField.text = titleYouWant;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return NO;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return 5;
    
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if ([pickerView isEqual:_picker1]) {
        
        if (row == 0)
            return @"Mobile Phones";
        
        if (row == 1)
            return @"Home and Furniture";
        
        if (row == 2)
            return @"Electronics";
        
        if (row == 3)
            return @"Lifestyle";
        
        if (row == 4)
            return @"Artistry";
        
    }
    
    if ([pickerView isEqual:_picker2]) {
        
        if (row == 0)
            return @"Very Used";
        
        if (row == 1)
            return @"Used";
        
        if (row == 2)
            return @"Good";
        
        if (row == 3)
            return @"Very Good";
        
        if (row == 4)
            return @"Mint";
        
    }
    
    return nil;
    
}

- (IBAction)takePictureButton:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.allowsEditing = NO;
        [self presentViewController:picker animated:YES completion:nil];
        
    } else {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"I'm afraid there's no camera on this device!" delegate:nil cancelButtonTitle:@"Dang!" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker  didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *originalImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.previewImage.backgroundColor = [UIColor clearColor];
    
    self.previewImage.image = [originalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
