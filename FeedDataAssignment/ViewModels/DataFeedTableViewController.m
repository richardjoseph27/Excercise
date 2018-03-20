//
//  DataFeedTableViewController.m
//  FeedDataAssignment
//
//  Created by Richard Joseph on 19/03/18.
//  Copyright © 2018 Richard Joseph. All rights reserved.
//

#import "DataFeedTableViewController.h"
#import "ServiceConnection.h"
#import "FeedDataTableViewCell.h"
#import "ImageDownloader.h"

static NSString *CellIdentifier = @"FeedTableCell";
static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";

#pragma mark -

@interface DataFeedTableViewController () <UIScrollViewDelegate>

// the set of IconDownloader objects for each app
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
//@property (nonatomic, strong) NSMutableArray *indexesToBeReloadedAfterImageDownload;

@end

@interface DataFeedTableViewController ()
@end

@implementation DataFeedTableViewController

@synthesize refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[FeedDataRefreshControl alloc]init];
    [self.refreshControl addTarget:self
                            action:@selector(getFeedData)
                  forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = self.refreshControl;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feedData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedDataTableViewCell *cell = nil;
    
    NSUInteger nodeCount = self.feedData.count;
    
    if (nodeCount == 0 && indexPath.row == 0)
    {
        // add a placeholder cell while waiting on table data
        cell = [[FeedDataTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PlaceholderCellIdentifier];
    }
    else
    {
        cell = [[FeedDataTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        // Leave cells empty if there's no data yet
        if (nodeCount > 0)
        {
            // Set up the cell representing the app
            DataObject *dataObject = (self.feedData)[indexPath.row];
            cell.textLabel.text = dataObject.title;
            cell.detailTextLabel.text = dataObject.descriptionText;
            
            // Only load cached images; defer new downloads until scrolling ends
            if (dataObject.imageURLString.length != 0) {
                if (!dataObject.appIcon)
                {
                    if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
                    {
                        [self startIconDownload:dataObject forIndexPath:indexPath];
                    }
                    // if a download is deferred or in progress, return a placeholder image
                    cell.imageView.image = [UIImage imageNamed:@"placeHolder"];
                }
                else
                {
                    cell.imageView.image = dataObject.appIcon;
                }
            }else{
                //if image url is null set the placeholder.
                dataObject.appIcon = [UIImage imageNamed:@"placeHolder"];
                cell.imageView.image = dataObject.appIcon;
            }
        }
    }
    
    return cell;
}

#pragma mark - Table cell image support
- (void)startIconDownload:(DataObject *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"data pending: %@", appRecord.title);
    ImageDownloader *imageDownloader = (self.imageDownloadsInProgress)[indexPath];
    if (imageDownloader == nil)
    {
        imageDownloader = [[ImageDownloader alloc] init];
        imageDownloader.dataObject = appRecord;
        [imageDownloader setCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                [self.tableView beginUpdates];
                cell.imageView.image = appRecord.appIcon;
                [self.tableView endUpdates];
            });
            
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
        }];
        
        (self.imageDownloadsInProgress)[indexPath] = imageDownloader;
        [imageDownloader startDownload];
    }
}

// -------------------------------------------------------------------------------
//    loadImagesForOnscreenRows
//  This method is used in case the user scrolled into a set of cells that don't
//  have their images yet.
// -------------------------------------------------------------------------------
- (void)loadImagesForOnscreenRows
{
    if (self.feedData.count > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            DataObject *dataObject = (self.feedData)[indexPath.row];
            
            if (!dataObject.appIcon)
                // Avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:dataObject forIndexPath:indexPath];
            }
        }
    }
}


#pragma mark - UIScrollViewDelegate

// -------------------------------------------------------------------------------
//    scrollViewDidEndDragging:willDecelerate:
//  Load images for all onscreen rows when scrolling is finished.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadImagesForOnscreenRows];
    }
}

// -------------------------------------------------------------------------------
//    scrollViewDidEndDecelerating:scrollView
//  When scrolling stops, proceed to load the app icons that are on screen.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}


#pragma mark - Refresh table view by pull down

// -------------------------------------------------------------------------------
//    getFeedData:
//    this method will fetch the latest data from the server.
// -------------------------------------------------------------------------------
-(void) getFeedData{
    ServiceConnection *serviceConnection = [[ServiceConnection alloc]init];
    [serviceConnection setCompletionHandler:^(NSArray *refreshedData, NSString *navBarTitle) {
        if (refreshedData.count > 0) {
            self.feedData = refreshedData;
            [self refreshTableData];
        }else{
            [self.refreshControl endRefreshing];
        }
    }];
    [serviceConnection getFeedDataFromServer];
}

// -------------------------------------------------------------------------------
//    refreshTableData:
//    upon succesfful data retrieval refresh the table and dismisss refresh control
// -------------------------------------------------------------------------------
- (void)refreshTableData{
    // Reload table data
    
    [self.tableView reloadData];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                forKey:NSForegroundColorAttributeName];
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    self.refreshControl.attributedTitle = attributedTitle;
    [self.refreshControl endRefreshing];
}

@end

