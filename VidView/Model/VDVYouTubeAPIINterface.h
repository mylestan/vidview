//
//  VDVYouTubeAPIInterface.h
//  VidView
//
//  Created by Myles Tan on 13-04-27.
//  Copyright (c) 2013 Myles Tan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"

@protocol VDVYouTubeVideoListDelegate <NSObject>

-(void)populateVideoDetailArraySuccess;
-(void)populateVideoDetailArrayFailed;

@end

@interface VDVYouTubeAPIINterface : NSObject

@property (retain, nonatomic) NSMutableArray* videoArray;

@property (nonatomic, retain) id <VDVYouTubeVideoListDelegate> delegate;

+(VDVYouTubeAPIINterface* )Singleton;
-(void)populateVideoDetailArrayFromYouTube;

@end
