//
//  SFLTableViewCell.m
//  superfling
//
//  Created by Daniele Bogo on 12/05/2016.
//  Copyright © 2016 Daniele Bogo. All rights reserved.
//

#import "SFLTableViewCell.h"


@interface SFLTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;


@end

@implementation SFLTableViewCell

+ (NSString *)cellIdentifier
{
    return [NSString stringWithFormat:@"k%@Identifier", NSStringFromClass(self)];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundImageView.clipsToBounds = YES;
}


#pragma mark - Public methods

- (void)setTitle:(NSString *)title userName:(NSString *)userName
{
    self.titleLabel.text = [title copy];
    self.usernameLabel.text = [userName copy];
}


@end
