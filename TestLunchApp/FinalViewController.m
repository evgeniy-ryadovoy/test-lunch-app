//
//  FinalViewController.m
//  TestLunchApp
//
//  Created by Evgeniy on 11.03.15.
//  Copyright (c) 2015 Evgeniy. All rights reserved.
//

#import "FinalViewController.h"

@interface FinalViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *lunchNameTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *lunchDescriptionTextLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *photosCollectionView;

@end

@implementation FinalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photosCollectionView.delegate = self;
    self.photosCollectionView.dataSource = self;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.lunchNameTextLabel.text = [userDefaults objectForKey:@"lunchName"];
    self.lunchDescriptionTextLabel.text = [userDefaults objectForKey:@"lunchDesc"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.photosArray = nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photosArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    imageView.image = [self.photosArray objectAtIndex:indexPath.row];
    
    return cell;
}

@end
