//
//  VDVVideoListCell.m
//  VidView
//
//  Created by Myles Tan on 13-04-27.
//  Copyright (c) 2013 Myles Tan. All rights reserved.
//

#import "VDVVideoListCell.h"

@implementation VDVVideoListCell

#pragma mark - Initialize

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Selection

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
