//
//  VDVVideoListViewController.m
//  VidView
//
//  Created by Myles Tan on 13-04-27.
//  Copyright (c) 2013 Myles Tan. All rights reserved.
//

#import "VDVVideoListViewController.h"
#import "VDVVideoDetailViewController.h"
#import "VDVVideoListCell.h"

static NSString *videoListCellIdentifier = @"VIDCELL";

@interface VDVVideoListViewController () <VDVYouTubeVideoListDelegate>

@property (retain, nonatomic) VDVYouTubeAPIINterface *videoList;
@property (retain, nonatomic) NSArray* videoArray;

-(void)dispatchPopulateVideoDetailArrayRequest;

@end

@implementation VDVVideoListViewController 

#pragma mark - Initializer

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
    // UI setup
    self.title = @"Video View";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Go Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    // Delegate settings
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    self.videoList = [VDVYouTubeAPIINterface Singleton];
    [self.videoList setDelegate:self];
    
    // Initial view setup
    self.tableView.hidden = YES;
    
    // Grab videos on a different thread to not block UI
    [self dispatchPopulateVideoDetailArrayRequest];
       
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 275.0; // Same as in Interface Builder
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.videoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Register nib for custom cell
    static BOOL nibsRegistered = NO;
    if (!nibsRegistered){
        UINib *videoListNib = [UINib nibWithNibName:@"VDVVideoListCell" bundle:nil];
        [tableView registerNib:videoListNib forCellReuseIdentifier:videoListCellIdentifier];
        nibsRegistered = YES;
    }
    
    VDVVideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:videoListCellIdentifier];
    
    // Configure the cell
    NSDictionary *cellData = [self.videoArray objectAtIndex:[indexPath row]];
    cell.title.text = [cellData objectForKey:@"title"];
    cell.author.text = [@"By " stringByAppendingString:[cellData objectForKey:@"author"]];
    cell.thumbnailView.image = [UIImage imageWithData:[[[cellData objectForKey:@"thumbnails"] objectAtIndex:0] objectForKey:@"image-data"]];
    
    // Style the cell
    [cell.contentView setBackgroundColor:[UIColor colorWithWhite:220.f/225.f alpha:1.f]];
    
    //webview
    NSString *videoID = [cellData objectForKey:@"videoid"];
    NSString *embedHTML = @"<html><head></head><body style=\"margin:0\"><iframe width=\"%i\" height=\"%i\" src=\"http://www.youtube.com/embed/%@?rel=0\" frameborder=\"0\" allowfullscreen></iframe></body></html>";
    int videoWidth = cell.videoWebView.frame.size.width;
    int videoHeight = cell.videoWebView.frame.size.height;
    NSString *html = [NSString stringWithFormat:embedHTML, videoWidth, videoHeight, videoID];
    [cell.videoWebView loadHTMLString:html baseURL:nil];
    
//    cell.thumbnailView.hidden = NO;
//    cell.videoWebView.userInteractionEnabled = NO;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Deselect the row
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - YouTube Video List

-(void)dispatchPopulateVideoDetailArrayRequest{
    [self.activityIndicator startAnimating];
    self.statusLabel.text = @"Loading";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self.videoList populateVideoDetailArrayFromYouTube];
    });
}

#pragma mark - YouTube Video List Delegate

-(void)populateVideoDetailArraySuccess{
    self.videoArray = self.videoList.videoArray;
    
    [self.tableView reloadData];
    [self.loadingView removeFromSuperview];
    [self.loadingShadowView removeFromSuperview];
    self.tableView.hidden = NO;
}

-(void)populateVideoDetailArrayFailed{
    [self.activityIndicator stopAnimating];
    [self.statusLabel setText:@"Sorry, there was an error."];
    self.tryAgainButton.hidden = FALSE;
}

#pragma mark - IBActions

-(IBAction)tryAgainButtonPressed:(UIButton *)sender{
    [self dispatchPopulateVideoDetailArrayRequest];
}

#pragma mark - Memory

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
