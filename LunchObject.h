//
//  LunchObject.h
//  TestLunchApp
//
//  Created by Evgeniy on 13.03.15.
//  Copyright (c) 2015 Evgeniy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LunchObject : NSObject

@property NSString *lunchName;
@property NSString *lunchDesc;
@property NSMutableArray *lunchImages;

- (void)saveLunch;
+ (LunchObject *)loadLunch:(NSDictionary *)diskLunchItem;

@end
