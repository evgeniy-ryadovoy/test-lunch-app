//
//  LunchListTableViewCell.h
//  TestLunchApp
//
//  Created by Evgeniy on 11.03.15.
//  Copyright (c) 2015 Evgeniy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LunchListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *lunchItemThumbnail;
@property (strong, nonatomic) IBOutlet UILabel *lunchItemName;
@property (strong, nonatomic) IBOutlet UILabel *lunchItemDesc;

@end
