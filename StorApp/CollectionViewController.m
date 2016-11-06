//
//  CollectionViewController.m
//  Stor
//
//  Created by Darran Hall on 11/4/2016.
//  Copyright (c) 2016 Stor App. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionCell.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "DetailTableViewController.h"
#import "XXXRoundMenuButton.h"

@interface CollectionViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *storage;
@property (nonatomic, strong) XXXRoundMenuButton *roundMenu2;
@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"CollectionCell";

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{

}

- (void)viewDidAppear:(BOOL)animated
{
    
    [UIView animateWithDuration:.15f animations:^{
        
        self.roundMenu2.alpha = 1;
        
    }];

}

- (void)unfadeButton {
    
    [UIView animateWithDuration:.15 animations:^{
       
        _roundMenu2.alpha = 1;
        
    }];
    
}

- (void)viewDidLoad {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unfadeButton) name:@"unfadeButton" object:nil];
    
    self.roundMenu2 = [[XXXRoundMenuButton alloc] init];
    self.roundMenu2.frame = CGRectMake(self.view.frame.size.width - 145, self.view.frame.size.height - 145, 200, 200);

    self.roundMenu2.centerButtonSize = CGSizeMake(60, 60);
    self.roundMenu2.centerIconType = XXXIconTypeUserDraw;
    self.roundMenu2.tintColor = [UIColor whiteColor];
    self.roundMenu2.jumpOutButtonOnebyOne = YES;
    
    [self.roundMenu2 setDrawCenterButtonIconBlock:^(CGRect rect, UIControlState state) {
        
        if (state == UIControlStateNormal)
        {
            UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake((rect.size.width - 15)/2, rect.size.height/2 - 5, 15, 1)];
            [UIColor.whiteColor setFill];
            [rectanglePath fill];
            
            
            UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: CGRectMake((rect.size.width - 15)/2, rect.size.height/2, 15, 1)];
            [UIColor.whiteColor setFill];
            [rectangle2Path fill];
            
            UIBezierPath* rectangle3Path = [UIBezierPath bezierPathWithRect: CGRectMake((rect.size.width - 15)/2, rect.size.height/2 + 5, 15, 1)];
            [UIColor.whiteColor setFill];
            [rectangle3Path fill];
        }
    }];
    [self.roundMenu2 loadButtonWithIcons:@[
                                           [UIImage imageNamed:@"refresh.png"],
                                           [UIImage imageNamed:@"add.png"],
                                           [UIImage imageNamed:@"search.png"]
                                           
                                           ] startDegree:-M_PI layoutDegree:M_PI/2];
    
    [self.roundMenu2 setButtonClickBlock:^(NSInteger idx) {
        
        NSLog(@"button %@ clicked !",@(idx));
        
        if (idx == 1) {
            
            [self.navigationController presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"AddList"] animated:YES completion:^{
                
            }];
            
        }
        
        if (idx == 0) {
            
            [self getListings];
            
        }
    }];
    
    
    self.roundMenu2.tintColor = [UIColor whiteColor];
    
    self.roundMenu2.mainColor = [UIColor colorWithRed:30/255.f green:139/255.f blue:195/255.f alpha:1];
        
    [self.navigationController.view addSubview:self.roundMenu2];

    [super viewDidLoad];
    [self getListings];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (void)getListings {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:@"http://192.73.235.134:8070/api/listings" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSArray *array = (NSArray*)responseObject;
        self.storage = array;
        [self.collectionView reloadData];

        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.storage.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *temp = [self.storage objectAtIndex:indexPath.row];
    CollectionCell *cell = (CollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [cell.itemImage setImageWithURL:[NSURL URLWithString:[temp objectForKey:@"imageUrl"]]];
    cell.itemLabel.text = [temp objectForKey:@"itemName"];
    cell.conditionLabel.text = [NSString stringWithFormat:@"%@ - %@", [temp objectForKey:@"condition"], [temp objectForKey:@"price"]];
    cell.itemLabel.numberOfLines = 2;
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CollectionCell *cell = (CollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [UIView animateWithDuration:.15f animations:^{
        
        self.roundMenu2.alpha = 0;
        
    }];
    
    
    DetailTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
    UINavigationController *controller1 = [[UINavigationController alloc] initWithRootViewController:controller];
    
    controller.storageDict = [self.storage objectAtIndex:indexPath.row];
    controller.headerImage = cell.itemImage.image;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        controller1.modalPresentationStyle = UIModalPresentationFormSheet;
        
        [self presentViewController:controller1 animated:YES completion:^{
            
        }];

        
    } else {
        
        [self.navigationController pushViewController:controller animated:YES];
        
    }

}

#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    return CGSizeMake((self.view.frame.size.width / 4) - 9, (self.view.frame.size.width / 4) - 9);
    } else {
    return CGSizeMake((self.view.frame.size.width / 2) - 9, (self.view.frame.size.width / 2) - 9);
    }
}

#pragma mark -- YSLTransitionAnimatorDataSource
- (UIImageView *)pushTransitionImageView
{
    CollectionCell *cell = (CollectionCell *)[self.collectionView cellForItemAtIndexPath:[[self.collectionView indexPathsForSelectedItems] firstObject]];
    return cell.itemImage;
}

- (UIImageView *)popTransitionImageView
{
    return nil;
}


@end
