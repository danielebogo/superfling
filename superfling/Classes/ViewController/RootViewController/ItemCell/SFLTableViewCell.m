//
//  SFLTableViewCell.m
//  superfling
//
//  Created by Daniele Bogo on 12/05/2016.
//  Copyright © 2016 Daniele Bogo. All rights reserved.
//

#import "SFLTableViewCell.h"
#import "DBImageView.h"


@interface SFLTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet DBImageView *backgroundImageView;


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
}


#pragma mark - Public methods

- (void)setTitle:(NSString *)title userName:(NSString *)userName
{
    self.titleLabel.text = [title copy];
    self.usernameLabel.text = [userName copy];
}

- (void)setImageURL:(NSString *)imageURL
{
    [self.backgroundImageView setImageWithPath:[imageURL copy]];
}


@end
