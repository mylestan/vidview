//
//  VDVVideoDetailViewController.m
//  VidView
//
//  Created by Myles Tan on 13-04-27.
//  Copyright (c) 2013 Myles Tan. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

#import "VDVVideoDetailViewController.h"

@interface VDVVideoDetailViewController ()

@end

@implementation VDVVideoDetailViewController

#pragma mark - View Controller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Video Details";
    
    // Format webview to prevent the video from bouncing
    self.videoWebView.scrollView.scrollEnabled = NO;
    self.videoWebView.scrollView.bounces = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Populating the view
// Override property setter to automatically populate view
- (void)setVideoDictionary:(NSDictionary *)videoDict{
    _videoDictionary = videoDict;
    
    [self populateViewWithVideoDictionary];
}

- (void) populateViewWithVideoDictionary{
    // populate text fields
    self.titleLabel.text = [self.videoDictionary objectForKey:@"title"];
    self.descriptionTextView.text = [self.videoDictionary objectForKey:@"description"];
    self.authorLabel.text = [@"By: " stringByAppendingString:[self.videoDictionary objectForKey:@"author"]];
    
    // Video Embedding
    NSString *videoID = [self.videoDictionary objectForKey:@"videoid"];
    NSString *embedHTML = @"<html><head></head><body style=\"margin:0\"><iframe width=\"%i\" height=\"%i\" src=\"http://www.youtube.com/embed/%@?rel=0&\" frameborder=\"0\" allowfullscreen></iframe></body></html>";
    int videoWidth = (int)self.videoWebView.frame.size.width;
    int videoHeight = (int)self.videoWebView.frame.size.height;
    NSString *html = [NSString stringWithFormat:embedHTML, videoWidth, videoHeight, videoID];
    [self.videoWebView loadHTMLString:html baseURL:nil];
}

@end
