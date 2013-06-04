//
//  VDVVideoDetailViewController.h
//  VidView
//
//  Created by Myles Tan on 13-04-27.
//  Copyright (c) 2013 Myles Tan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VDVVideoDetailViewController : UIViewController

@property (retain, nonatomic) NSDictionary *videoDictionary;

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (retain, nonatomic) IBOutlet UILabel *authorLabel;

@property (retain, nonatomic) IBOutlet UIWebView *videoWebView;

@end
