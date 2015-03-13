//
//  TakePhotoViewController.m
//  TestLunchApp
//
//  Created by Evgeniy on 13.03.15.
//  Copyright (c) 2015 Evgeniy. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "LunchObject.h"
#import "ViewController.h"

@interface TakePhotoViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *photoButton;

@end

@implementation TakePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        self.photoButton.enabled = NO;
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    chosenImage = [self imageWithImage:chosenImage scaledToSize:CGSizeMake(64, 64)];
    
    LunchObject *lunch = [[LunchObject alloc] init];
    [lunch.lunchImages addObject:chosenImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    self.tabBarController.selectedIndex = 0;
    UINavigationController *nc = (UINavigationController *)self.tabBarController.viewControllers[0];
    [nc popToRootViewControllerAnimated:NO];
    ViewController *vc = [nc viewControllers][0];
    vc.lunch = lunch;
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
