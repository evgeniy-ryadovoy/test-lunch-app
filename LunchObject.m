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
    self.lunchImages = [[NSMutableArray alloc] init];
    return self;
}

- (void)saveLunch {
    NSString *imagePath = nil;
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    
    NSInteger count = self.lunchImages.count;
        
    for (NSInteger i = 0; i < count; ++i) {
        //Save images to separate files
        UIImage *photo = self.lunchImages[i];
        NSString *imageName = [NSString stringWithFormat:@"%@-%i.png", self.lunchName, i];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        imagePath = [path stringByAppendingPathComponent:imageName];
        NSData *data = UIImagePNGRepresentation(photo);
        [data writeToFile:imagePath atomically:YES];
        [photos addObject:imageName];
    }
    
    NSArray *keys = @[@"lunchName", @"lunchDesc", @"lunchThumbnails"];
    NSArray *values = @[self.lunchName, self.lunchDesc, photos];
    
    NSDictionary *lunchItem = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    
    // Find out the path of luncheList.plist
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"lunchList.plist"];
    
    if ([manager isWritableFileAtPath:path]) {
        NSMutableDictionary* dataDict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        NSMutableArray *lunchItems = [dataDict objectForKey:@"lunchItems"];
        [lunchItems addObject:lunchItem];
        [dataDict writeToFile:path atomically:NO];
    }
}

//Load lunch object from list item
+ (LunchObject *)loadLunch:(NSDictionary *)diskLunchItem {
    LunchObject *newLunchObject = [[LunchObject alloc] init];
    newLunchObject.lunchName = [diskLunchItem objectForKey:@"lunchName"];
    newLunchObject.lunchDesc = [diskLunchItem objectForKey:@"lunchDesc"];
    
    NSArray *lunchImages = [diskLunchItem objectForKey:@"lunchThumbnails"];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    for (NSString *imageName in lunchImages) {
        NSString *imagePath = [path stringByAppendingPathComponent:imageName];
        [newLunchObject.lunchImages addObject:[UIImage imageNamed:imagePath]];
    }
    
    return newLunchObject;
}

@end
