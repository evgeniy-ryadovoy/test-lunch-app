//
//  ViewController.m
//  TestLunchApp
//
//  Created by Evgeniy on 11.03.15.
//  Copyright (c) 2015 Evgeniy. All rights reserved.
//

#import "ViewController.h"
#import "AddPhotoViewController.h"

@interface ViewController () <UITextFieldDelegate, UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *lunchNameTextField;
@property (strong, nonatomic) IBOutlet UITextView *lunchDescriptionTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lunchNameTextField.delegate = self;
    self.lunchDescriptionTextView.delegate = self;
    
    if (!self.lunch) {
        self.lunch = [[LunchObject alloc] init];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.lunch = nil;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    //validate fields
    if ([identifier isEqualToString:@"addPhoto"]) {
        BOOL isValid = [self validateFields];
        
        if (!isValid) {
            [self showError];
        }
        
        return isValid;
    }
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"addPhoto"]) {
        self.lunch.lunchName = self.lunchNameTextField.text;
        self.lunch.lunchDesc = self.lunchDescriptionTextView.text;
        AddPhotoViewController *vc = segue.destinationViewController;
        vc.lunch = self.lunch;
    }
}

- (BOOL)validateFields {
    
    return ([self.lunchNameTextField.text length] &&
            [self.lunchDescriptionTextView.text length]);
}

- (void)showError {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please insert lunch name and description"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
    
    [alertView show];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

@end
