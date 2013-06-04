//
//  VDVVideoListViewController.h
//  VidView
//
//  Created by Myles Tan on 13-04-27.
//  Copyright (c) 2013 Myles Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDVYouTubeAPIINterface.h"

@interface VDVVideoListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) IBOutlet UITableView* tableView;
@property (retain, nonatomic) IBOutlet UILabel *helpTextLabel;

@property (retain, nonatomic) IBOutlet UIView *loadingView;
@property (retain, nonatomic) IBOutlet UIView *loadingShadowView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) IBOutlet UILabel *statusLabel;
@property (retain, nonatomic) IBOutlet UIButton *tryAgainButton;

-(IBAction)tryAgainButtonPressed:(UIButton*)sender;



@end
