//
//  SFLRootViewController.m
//  superfling
//
//  Created by Daniele Bogo on 12/05/2016.
//  Copyright © 2016 Daniele Bogo. All rights reserved.
//

#import "SFLRootViewController.h"

@interface SFLRootViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation SFLRootViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self sfl_buildUI];
}


#pragma mark - Private methods

- (void)sfl_buildUI
{
    self.navigationItem.title = @"SuperFling";
}


@end
