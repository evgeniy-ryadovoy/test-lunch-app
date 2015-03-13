//
//  AddPhotoViewController.m
//  TestLunchApp
//
//  Created by Evgeniy on 11.03.15.
//  Copyright (c) 2015 Evgeniy. All rights reserved.
//
static int MAX_PHOTOS = 4;

#import "AddPhotoViewController.h"
#import "FinalViewController.h"

@interface AddPhotoViewController () <UICollectionViewDataSource,
                                      UICollectionViewDelegate,
                                      UIImagePickerControllerDelegate,
                                      UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *photosCollectionView;

@end

@implementation AddPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photosCollectionView.delegate = self;
    self.photosCollectionView.dataSource = self;
    
    if (!self.lunch) {
        self.lunch = [[LunchObject alloc] init];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.lunch = nil;
}

- (IBAction)addPhotoAction:(id)sender {
    
    if (self.lunch.lunchImages.count == MAX_PHOTOS) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"You can't add more photo"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        
        [alertView show];
        return;
    }
    
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    chosenImage = [self imageWithImage:chosenImage scaledToSize:CGSizeMake(64, 64)];
    
    [self.lunch.lunchImages addObject:chosenImage];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];

    //insert added photo to collection view
    [self.photosCollectionView performBatchUpdates:^{
        
        NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
        [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:([self.lunch.lunchImages count] - 1)
                                                          inSection:0]];
        [self.photosCollectionView insertItemsAtIndexPaths:arrayWithIndexPaths];
    } completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"finalScreen"]) {
        FinalViewController *vc = segue.destinationViewController;
        vc.lunch = self.lunch;
        vc.needSave = YES;
    }
}

// Resize images from library to decrease memory usage
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
