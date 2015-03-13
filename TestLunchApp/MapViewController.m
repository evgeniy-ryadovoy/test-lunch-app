//
//  MapViewController.m
//  TestLunchApp
//
//  Created by Evgeniy on 13.03.15.
//  Copyright (c) 2015 Evgeniy. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CustomPointAnnotation.h"
#import "FinalViewController.h"

@interface MapViewController () <MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView.delegate = self;
    
    if (!self.lunchItems) {
        self.lunchItems = [[NSArray alloc] init];
    }
     
    [self loadAnnotations];
}

- (void)loadAnnotations {
    
    for (PFObject *item in self.lunchItems) {
        CustomPointAnnotation *point = [[CustomPointAnnotation alloc] init];
        point.coordinate = CLLocationCoordinate2DMake([item[@"Latitude"] floatValue], [item[@"Longtitude"] floatValue]);
        point.title = item[@"Name"];
        point.lunchItem = item;
        [self.mapView addAnnotation:point];
        [self.mapView selectAnnotation:point animated:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.lunchItems = nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
 
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FinalViewController *vc = [sb instantiateViewControllerWithIdentifier:@"FinalViewController"];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        vc.lunch = [LunchObject loadLunch:((CustomPointAnnotation *)view.annotation).lunchItem];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            vc.needSave = NO;
            [self.navigationController pushViewController:vc animated:YES];
            
        });
    });
}
@end
