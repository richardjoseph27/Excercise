//
//  DataFeedTableViewController.h
//  FeedDataAssignment
//
//  Created by Richard Joseph on 19/03/18.
//  Copyright © 2018 Richard Joseph. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedDataRefreshControl.h"

@interface DataFeedTableViewController : UITableViewController{
    NSMutableArray *indexesToBeReloadedAfterImageDownload;
}

// the main data model for our UITableView
@property (nonatomic, strong) NSArray *feedData;
@property (nonatomic, strong) FeedDataRefreshControl *refreshControl;

@end
