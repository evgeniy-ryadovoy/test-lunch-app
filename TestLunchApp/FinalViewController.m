//
//  FinalViewController.m
//  TestLunchApp
//
//  Created by Evgeniy on 11.03.15.
//  Copyright (c) 2015 Evgeniy. All rights reserved.
//

#import "FinalViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface FinalViewController () <UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lunchNameTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *lunchDescriptionTextLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *photosCollectionView;
@property (strong, nonatomic) IBOutlet UILabel *longtitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *timestampLabel;

@property CLLocationManager *locationManager;
@end

@implementation FinalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photosCollectionView.delegate = self;
    self.photosCollectionView.dataSource = self;
    
    if (!self.lunch) {
        self.lunch = [[LunchObject alloc] init];
    }
    
    if (!self.lunch.timestamp.length) {
        self.lunch.timestamp = [NSString stringWithFormat:@"%@", [NSDate date]];
    }
    
    self.lunchNameTextLabel.text = self.lunch.lunchName;
    self.lunchDescriptionTextLabel.text = self.lunch.lunchDesc;
    self.longtitudeLabel.text = [NSString stringWithFormat:@"%f", self.lunch.longtitude];
    self.latitudeLabel.text = [NSString stringWithFormat:@"%f", self.lunch.latitude];
    self.timestampLabel.text = self.lunch.timestamp;
    
    if (self.needSave) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
        self.navigationItem.title = self.lunch.lunchName;

        // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }

        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:@"Failed to Get Your Location"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [errorAlert show];
}

// Wait for location callbacks
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *loc = [locations lastObject];
    self.lunch.longtitude = loc.coordinate.longitude;
    self.lunch.latitude = loc.coordinate.latitude;
    [self updateFields];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.locationManager stopUpdatingLocation];
    
    if (self.needSave) {
        //TODO: make saving more user-friendly with some spinner
        [self.lunch saveLunch];
        self.needSave = NO;
    }
}

- (void)updateFields {
    self.longtitudeLabel.text = [NSString stringWithFormat:@"%f", self.lunch.longtitude];
    self.latitudeLabel.text   = [NSString stringWithFormat:@"%f", self.lunch.latitude];
    self.timestampLabel.text  = self.lunch.timestamp;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.lunch = nil;
    self.locationManager = nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.lunch.lunchImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    imageView.image = [self.lunch.lunchImages objectAtIndex:indexPath.row];
    
    return cell;
}

@end
