//
//  VDVVideoListCell.h
//  VidView
//
//  Created by Myles Tan on 13-04-27.
//  Copyright (c) 2013 Myles Tan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VDVVideoListCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *title;
@property (nonatomic, retain) IBOutlet UILabel *author;

@property (nonatomic, retain) IBOutlet UIImageView *thumbnailView;

@property (nonatomic, retain) IBOutlet UIWebView *videoWebView;

@end
