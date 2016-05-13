//
//  SFLRootViewController.m
//  superfling
//
//  Created by Daniele Bogo on 12/05/2016.
//  Copyright © 2016 Daniele Bogo. All rights reserved.
//

#import "SFLRootViewController.h"
#import "SFLContentManager.h"
#import "SFLTableViewCell.h"
#import "SFLTableViewDatasource.h"

#import "NSObject+ObjectValidation.h"

@interface SFLRootViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) SFLContentManager *contentManager;
@property (nonatomic, strong) SFLTableViewDatasource *dataSource;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end


@implementation SFLRootViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _dataSource = [SFLTableViewDatasource new];
    
    _contentManager = [SFLContentManager newContentManagerWithNetworkBaseURLString:@"http://challenge.superfling.com/"];
    _dataSource.items = [NSArray arrayWithArray:[_contentManager savedItems]];
    
    [self sfl_buildUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self sfl_loadItemsForcingReload:NO];
}


#pragma mark - Private methods

- (void)sfl_buildUI
{
    self.navigationItem.title = @"SuperFling";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView.dataSource = self.dataSource;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
    
    UINib *cellNib = [UINib nibWithNibName:@"SFLTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:[SFLTableViewCell cellIdentifier]];
    
    self.refreshControl = [UIRefreshControl new];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(sfl_reloadData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (void)sfl_loadItemsForcingReload:(BOOL)forcingReload
{
    __weak typeof(self)weakSelf = self;
    
    [self.activityIndicator startAnimating];
    
    [_contentManager fetchSaveItemsWithCompletionBlock:^(BOOL success, NSArray<SFLItem *> *items, NSError *error) {
        if (success) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf)strongSelf = weakSelf;
                
                [strongSelf.activityIndicator stopAnimating];
                [strongSelf.refreshControl endRefreshing];
                
                if ([items sfl_isValidObject]) {
                    strongSelf.dataSource.items = [NSArray arrayWithArray:items];
                } else {
                    strongSelf.dataSource.items = [NSArray arrayWithArray:[weakSelf.contentManager savedItems]];
                }
                
                [strongSelf.tableView reloadData];
                [UIView animateWithDuration:.3 animations:^{
                    strongSelf.tableView.alpha = 1.0;
                }];
            });
            
        } else {
            [weakSelf.activityIndicator stopAnimating];
            [weakSelf.refreshControl endRefreshing];
        }
    } forcingReload:forcingReload];
}

- (void)sfl_reloadData
{
    [self sfl_loadItemsForcingReload:YES];
}


@end
