//
//  CustomPointAnnotation.h
//  TestLunchApp
//
//  Created by Evgeniy on 13.03.15.
//  Copyright (c) 2015 Evgeniy. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface CustomPointAnnotation : MKPointAnnotation

@property PFObject *lunchItem;

@end
