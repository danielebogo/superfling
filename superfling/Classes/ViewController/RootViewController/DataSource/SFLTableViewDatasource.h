//
//  SFLTableViewDatasource.h
//  superfling
//
//  Created by Daniele Bogo on 12/05/2016.
//  Copyright © 2016 Daniele Bogo. All rights reserved.
//

@import UIKit;

@class SFLItem;

@interface SFLTableViewDatasource : NSObject <UITableViewDataSource>

@property (nonatomic, strong) NSArray <SFLItem *>*items;

@end
