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

@interface LunchListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *lunchListTableView;

@property NSMutableArray *lunchItems;
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
    // Find out the path of luncheList.plist
    NSString *path = [self.documentPath stringByAppendingPathComponent:@"lunchList.plist"];
    // Load the file content and read the data into arrays
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    self.lunchItems = [dict objectForKey:@"lunchItems"];
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
    
    NSDictionary *lunchItem = [self.lunchItems objectAtIndex:indexPath.row];
    
    LunchListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LunchListTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.lunchItemName.text = [lunchItem objectForKey:@"lunchName"];
    cell.lunchItemDesc.text = [lunchItem objectForKey:@"lunchDesc"];
    
    NSArray *imagePaths = [lunchItem objectForKey:@"lunchThumbnails"];
    
    if (imagePaths.count) {
        cell.lunchItemThumbnail.image = [UIImage imageNamed:[self.documentPath stringByAppendingPathComponent:imagePaths[0]]];
    }
    
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

    vc.lunch = [LunchObject loadLunch:[self.lunchItems objectAtIndex:indexPath.row]];
    vc.needSave = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
