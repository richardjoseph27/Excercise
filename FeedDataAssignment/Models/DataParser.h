//
//  DataParser.h
//  FeedDataAssignment
//
//  Created by Richard Joseph on 20/03/18.
//  Copyright © 2018 Richard Joseph. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataParser : NSOperation

// A block to call when an error is encountered during parsing.
@property (nonatomic, copy) void (^errorHandler)(NSError *error);
@property (nonatomic, strong) NSString *navBarTitle;
@property (nonatomic, strong, readonly) NSArray *feedList;
@property (nonatomic, strong) NSData *dataToParse;

// The initializer for this NSOperation subclass.
- (instancetype)initWithData:(NSData *)data;

@end


