//
//  SFLTableViewDatasource.m
//  superfling
//
//  Created by Daniele Bogo on 12/05/2016.
//  Copyright © 2016 Daniele Bogo. All rights reserved.
//

#import "SFLTableViewDatasource.h"
#import "SFLItem.h"
#import "SFLTableViewCell.h"


@implementation SFLTableViewDatasource


#pragma mark - UItableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SFLTableViewCell cellIdentifier] forIndexPath:indexPath];
    [cell setTitle:self.items[indexPath.row].title userName:self.items[indexPath.row].userName];
    return cell;
}

@end
