//
//  FeedDataAssignmentUITests.m
//  FeedDataAssignmentUITests
//
//  Created by Richard Joseph on 19/03/18.
//  Copyright © 2018 Richard Joseph. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DataFeedTableViewController.h"

@interface FeedDataAssignmentUITests : XCTestCase
@property (nonatomic, strong) DataFeedTableViewController *testViewController;

@end

@implementation FeedDataAssignmentUITests

- (void)setUp {
    [super setUp];
    self.testViewController = [[DataFeedTableViewController alloc]init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.testViewController = nil;
    [super tearDown];
}

#pragma mark - View loading tests
-(void)testThatViewLoads
{
    XCTAssertNotNil(self.testViewController.view, @"View not initiated properly");
}

- (void)testParentViewHasTableViewSubview
{
    UIView *subview = self.testViewController.view;
    XCTAssertEqual(subview,self.testViewController.tableView, @"View does not have a table subview");
}

-(void)testThatTableViewLoads
{
    XCTAssertNotNil(self.testViewController.tableView, @"TableView not initiated");
}

#pragma mark - UITableView tests
- (void)testThatViewConformsToUITableViewDataSource
{
    XCTAssertTrue([self.testViewController conformsToProtocol:@protocol(UITableViewDataSource) ], @"View does not conform to UITableView datasource protocol");
}

- (void)testThatTableViewHasDataSource
{
    XCTAssertNotNil(self.testViewController.tableView.dataSource, @"Table datasource cannot be nil");
}

- (void)testThatViewConformsToUITableViewDelegate
{
    XCTAssertTrue([self.testViewController conformsToProtocol:@protocol(UITableViewDelegate) ], @"View does not conform to UITableView delegate protocol");
}

- (void)testTableViewIsConnectedToDelegate
{
    XCTAssertNotNil(self.testViewController.tableView.delegate, @"Table delegate cannot be nil");
}

- (void)testTableViewCellCreateCellsWithReuseIdentifier
{
    [[[XCUIApplication alloc] init].sheets[@"Error in connection"].buttons[@"OK"] tap];
    [[[XCUIApplication alloc] init].tables/*@START_MENU_TOKEN@*/.staticTexts[@"These Saturday night CBC broadcasts originally aired on radio in 1931. In 1952 they debuted on television and continue to unite (and divide) the nation each week."]/*[[".cells.staticTexts[@\"These Saturday night CBC broadcasts originally aired on radio in 1931. In 1952 they debuted on television and continue to unite (and divide) the nation each week.\"]",".staticTexts[@\"These Saturday night CBC broadcasts originally aired on radio in 1931. In 1952 they debuted on television and continue to unite (and divide) the nation each week.\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    [[[XCUIApplication alloc] init].tables/*@START_MENU_TOKEN@*/.staticTexts[@"Canada hopes to soon launch a man to the moon."]/*[[".cells.staticTexts[@\"Canada hopes to soon launch a man to the moon.\"]",".staticTexts[@\"Canada hopes to soon launch a man to the moon.\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.testViewController tableView:self.testViewController.tableView cellForRowAtIndexPath:indexPath];
    XCTAssertTrue([cell.reuseIdentifier isEqualToString:@"FeedTableCell"], @"Table does not create reusable cells");
}
@end
