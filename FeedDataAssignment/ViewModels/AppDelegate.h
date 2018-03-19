//
//  AppDelegate.h
//  FeedDataAssignment
//
//  Created by Richard Joseph on 19/03/18.
//  Copyright © 2018 Richard Joseph. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataParser.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// the queue to run our "ParseOperation"
@property (nonatomic, strong) NSOperationQueue *queue;

// the NSOperation driving the parsing of the RSS feed
@property (nonatomic, strong) DataParser *parser;

@end

