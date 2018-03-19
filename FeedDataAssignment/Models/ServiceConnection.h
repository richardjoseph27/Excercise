//
//  ServiceConnection.h
//  FeedDataAssignment
//
//  Created by Richard Joseph on 20/03/18.
//  Copyright © 2018 Richard Joseph. All rights reserved.

#import <Foundation/Foundation.h>
#import "DataParser.h"
#import "DataObject.h"

@interface ServiceConnection : NSObject

// the queue to run our "ParseOperation"
@property (nonatomic, strong) NSOperationQueue *queue;

// the NSOperation driving the parsing of the Json
@property (nonatomic, strong) DataParser *parser;

@property (nonatomic, copy) void (^completionHandler)(NSArray *refreshedData, NSString *navBarTitle);

-(void) getFeedDataFromServer;
- (void)handleError:(NSError *)error;

@end
