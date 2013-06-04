//
//  VDVYouTubeAPIInterface.m
//  VidView
//
//  Created by Myles Tan on 13-04-27.
//  Copyright (c) 2013 Myles Tan. All rights reserved.
//

#import "VDVYouTubeAPIINterface.h"


static VDVYouTubeAPIINterface *sharedSingleton;

static NSString *devKey = @"AIzaSyAla5kWpBhMFoMB4LtZwarDtOpDDcde1zg";
static NSString *searchTerm = @"health";
static int numResults = 10;


@interface VDVYouTubeAPIINterface()

-(NSMutableURLRequest*)_youTubeJsonFeedRequestForNumberOfResults:(int)numResults searchTerm:(NSString*)searchTerm withDevKey:(NSString*)devKey;
-(NSData*)_youTubeAPIRequestWithRequest:(NSMutableURLRequest*)request;
-(void)_parseYouTubeAPIResponseData:(NSData*)jsonData;

@end


@implementation VDVYouTubeAPIINterface

#pragma mark - Initialization

+ (VDVYouTubeAPIINterface* ) Singleton
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        sharedSingleton = [[VDVYouTubeAPIINterface alloc] init];
    }
    return sharedSingleton;
}

#pragma mark - Public

-(void)populateVideoDetailArrayFromYouTube{
    NSMutableURLRequest *urlRequest = [self _youTubeJsonFeedRequestForNumberOfResults:numResults searchTerm:searchTerm withDevKey:devKey];
    
    NSData *jsonResponseData = nil;
    jsonResponseData = [self _youTubeAPIRequestWithRequest:urlRequest];
    
    if (!jsonResponseData) {
        NSLog(@"Class %@: populateVideoDetailArrayFromYouTube returned nil", [self class]);
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.delegate populateVideoDetailArrayFailed];
        });
    } else {
        [self _parseYouTubeAPIResponseData:jsonResponseData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate populateVideoDetailArraySuccess];
        });
    }
}

#pragma mark - Private
#pragma mark API Request
- (NSMutableURLRequest*)_youTubeJsonFeedRequestForNumberOfResults:(int)numResults searchTerm:(NSString*)searchTerm withDevKey:(NSString*)devKey{
    
    // Setup URL
    NSString *theURL = [NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/videos?q=%@&alt=json&max-results=%i&format=5&key=%@", searchTerm, numResults, devKey];
    NSURL*URL = [NSURL URLWithString:theURL];
    
    // Setup request
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
    [request setURL:URL];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setTimeoutInterval:30];
    
    return request;
}

#pragma mark API Response
-(NSData*)_youTubeAPIRequestWithRequest:(NSMutableURLRequest*)request{
    NSError* error = nil;
    NSURLResponse* response = nil;
    
    // Make request
    NSData* jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error) {
        NSLog(@"Class %@: An error occurred with makeYouTubeAPIRequestWithRequest:, error: %@",[self class],[error localizedDescription]);
        return nil;
    } else {
        NSLog(@"JSON request successful.");
        return jsonData;
    }
}

#pragma mark Response Parsing

-(void)_parseYouTubeAPIResponseData:(NSData*)jsonData{
    
    // Handle response
    NSDictionary *responseDictionary = [[NSMutableDictionary alloc] initWithDictionary:[jsonData objectFromJSONData]];
    NSArray *responseVideosArray = [[NSMutableArray alloc] initWithArray:[[responseDictionary objectForKey:@"feed"] objectForKey:@"entry" ]]; // Isolates video entries from overhead data
    
    // Pull out necessary information and pre-cache the images for faster loading in table view.
    NSMutableArray *newVideoArray = [[NSMutableArray alloc] init];
    
    // Pull out necessary information and pre-cache the images for faster loading in table view.
    for (int i = 0; i < [responseVideosArray count]; i++) {
        
        NSMutableDictionary *currentVideoDictionary = [responseVideosArray objectAtIndex:i];        NSMutableDictionary *newCurrentVideoDictionary = [[NSMutableDictionary alloc] init]; //to be populated with useful info
        
        [newCurrentVideoDictionary setObject:[[currentVideoDictionary objectForKey:@"title"] objectForKey:@"$t"] forKey:@"title"];
        
        [newCurrentVideoDictionary setObject:[[[[currentVideoDictionary objectForKey:@"author"] objectAtIndex:0] objectForKey:@"name"] objectForKey:@"$t" ] forKey:@"author"];
        
        [newCurrentVideoDictionary setObject:[[currentVideoDictionary objectForKey:@"content"] objectForKey:@"$t"] forKey:@"description"];
        
        NSString *rawURL = [[[currentVideoDictionary objectForKey:@"link"] objectAtIndex:0] objectForKey:@"href"];
        [newCurrentVideoDictionary setObject:rawURL forKey:@"url"];
        
        //get the ID of the video for embedding
        NSString *videoURLID = [[currentVideoDictionary objectForKey:@"id"] objectForKey:@"$t"];
        NSString *videoID = [videoURLID stringByReplacingOccurrencesOfString:@"http://gdata.youtube.com/feeds/api/videos/" withString:@""];
        [newCurrentVideoDictionary setObject:videoID forKey:@"videoid"];
        
        NSMutableArray *tempThumbsArray = [[currentVideoDictionary objectForKey:@"media$group"] objectForKey:@"media$thumbnail"]; //thumb array of video we're looking into
        
        
        NSMutableArray *newThumbnailsArray = [[NSMutableArray alloc] init];
        
        // Add cached data for each thumbnail for faster loading
        for (int j = 0; j < [tempThumbsArray count]; j++) {
            NSMutableDictionary *thumbDictionary = [[NSMutableDictionary alloc] initWithDictionary:[tempThumbsArray objectAtIndex:j] copyItems:YES]; // Want all existing data
            
            NSString *imgURL = [[tempThumbsArray objectAtIndex:j] objectForKey:@"url"];
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]];
            [thumbDictionary setObject:imageData forKey:@"image-data"]; // Add data for image from URL
            
            [newThumbnailsArray addObject:thumbDictionary];
        }
        
        [newCurrentVideoDictionary setObject:newThumbnailsArray forKey:@"thumbnails"];
        
        [newVideoArray addObject:newCurrentVideoDictionary];
    }
    
    self.videoArray = newVideoArray;
}

@end
