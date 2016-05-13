//
//  SFLTableViewCell.h
//  superfling
//
//  Created by Daniele Bogo on 12/05/2016.
//  Copyright © 2016 Daniele Bogo. All rights reserved.
//

@import UIKit;

@interface SFLTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

+ (NSString *)cellIdentifier;

- (void)setTitle:(NSString *)title userName:(NSString *)userName;


@end
