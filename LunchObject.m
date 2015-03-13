//
//  LunchObject.m
//  TestLunchApp
//
//  Created by Evgeniy on 13.03.15.
//  Copyright (c) 2015 Evgeniy. All rights reserved.
//

#import "LunchObject.h"
#import <UIKit/UIKit.h>

@implementation LunchObject

- (id)init {
    self = [super init];
    self.lunchName = [[NSString alloc] init];
    self.lunchDesc = [[NSString alloc] init];
    self.longtitude = 0;
    self.latitude = 0;
    self.timestamp = [[NSString alloc] init];
    self.lunchImages = [[NSMutableArray alloc] init];
    return self;
}

- (void)saveLunch {
    NSInteger count = self.lunchImages.count;
    
    PFObject *object = [PFObject objectWithClassName:@"Lunch"];
    object[@"Name"] = self.lunchName;
    object[@"Description"] = self.lunchDesc;
    object[@"Longtitude"] = [NSNumber numberWithFloat:self.longtitude];
    object[@"Latitude"] = [NSNumber numberWithFloat:self.latitude];
    object[@"Created"] = self.timestamp;
    
    for (NSInteger i = 0; i < count; ++i) {
        //Save images to separate files
        UIImage *photo = self.lunchImages[i];
        NSData *data = UIImagePNGRepresentation(photo);
        PFFile *imageFile = [PFFile fileWithName:@"image.png" data:data];
        NSString *fieldName = [NSString stringWithFormat:@"Photo%i", (i+1)];
        object[fieldName] = imageFile;
    }
    
    [object saveInBackground];
}

//Load lunch object from list item. Method should be called in async queue
+ (LunchObject *)loadLunch:(PFObject *)diskLunchItem {
    __block LunchObject *newLunchObject = [[LunchObject alloc] init];
    newLunchObject.lunchName = diskLunchItem[@"Name"];
    newLunchObject.lunchDesc = diskLunchItem[@"Description"];
    newLunchObject.longtitude = [diskLunchItem[@"Longtitude"] floatValue];
    newLunchObject.latitude = [diskLunchItem[@"Latitude"] floatValue];
    newLunchObject.timestamp = diskLunchItem[@"Created"];
    
    NSMutableArray *lunchImages = [NSMutableArray arrayWithObjects:diskLunchItem[@"Photo1"],
                                                                   diskLunchItem[@"Photo2"],
                                                                   diskLunchItem[@"Photo3"],
                                                                   diskLunchItem[@"Photo4"], nil];
    
    for (PFFile *imageFile in lunchImages) {
        NSData *imageData = [imageFile getData];
        [newLunchObject.lunchImages addObject:[UIImage imageWithData:imageData]];
    }
    
    return newLunchObject;
}

@end
