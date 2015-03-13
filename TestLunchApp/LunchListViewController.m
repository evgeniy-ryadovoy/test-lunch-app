//
//  LunchListViewController.m
//  TestLunchApp
//
//  Created by Evgeniy on 11.03.15.
//  Copyright (c) 2015 Evgeniy. All rights reserved.
//

#import "LunchListViewController.h"
#import "LunchListTableViewCell.h"
#import "FinalViewController.h"
#import <Parse/Parse.h>

@interface LunchListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *lunchListTableView;
@property (strong, nonatomic) IBOutlet UILabel *loadingLabel;

@property NSArray *lunchItems;
@property NSString *documentPath;

@end

@implementation LunchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.lunchListTableView.delegate = self;
    self.lunchListTableView.dataSource = self;
    self.documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)viewWillAppear:(BOOL)animated {
    // Data can be cashed..
    [self loadLunchList];
}

- (void)loadLunchList {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        PFQuery *query = [PFQuery queryWithClassName:@"Lunch"];
        self.lunchItems = [query findObjects];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.loadingLabel.hidden = YES;
            self.lunchListTableView.hidden = NO;
            [self.lunchListTableView reloadData];
        });
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.lunchItems = nil;
    self.documentPath = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lunchItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"listItem";
    
    PFObject *lunchItem = [self.lunchItems objectAtIndex:indexPath.row];
    
    LunchListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LunchListTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.lunchItemName.text = lunchItem[@"Name"];
    cell.lunchItemDesc.text = lunchItem[@"Description"];
    
    PFFile *imageFile = lunchItem[@"Photo1"];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            cell.lunchItemThumbnail.image = [UIImage imageWithData:imageData];
        }
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FinalViewController *vc = [sb instantiateViewControllerWithIdentifier:@"FinalViewController"];

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        vc.lunch = [LunchObject loadLunch:[self.lunchItems objectAtIndex:indexPath.row]];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            vc.needSave = NO;
            [self.navigationController pushViewController:vc animated:YES];

        });
    });
}

@end
