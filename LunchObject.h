//
//  LunchObject.h
//  TestLunchApp
//
//  Created by Evgeniy on 13.03.15.
//  Copyright (c) 2015 Evgeniy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LunchObject : NSObject

@property NSString *lunchName;
@property NSString *lunchDesc;
@property NSMutableArray *lunchImages;
@property CGFloat longtitude;
@property CGFloat latitude;
@property NSString *timestamp;

- (void)saveLunch;
+ (LunchObject *)loadLunch:(PFObject *)diskLunchItem;

@end
