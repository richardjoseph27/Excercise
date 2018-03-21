//
//  FeedDataAssignmentTests.m
//  FeedDataAssignmentTests
//
//  Created by Richard Joseph on 19/03/18.
//  Copyright © 2018 Richard Joseph. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ServiceConnection.h"
#import "ImageDownloader.h"

@interface FeedDataAssignmentTests : XCTestCase
@property (nonatomic, strong) ServiceConnection *testServiceConnection;
@property (nonatomic, strong) ImageDownloader *testImageDownloader;

@end

@implementation FeedDataAssignmentTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.testServiceConnection = nil;
    self.testImageDownloader = nil;
}

- (void) testGetServerData{
    [self.testServiceConnection getFeedDataFromServer];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    //ServiceConnection *serviceConnectinoTest = [[ServiceConnection alloc] init];
    NSError *err = nil;
    [self.testServiceConnection handleError:err];
}

- (void)testPerformanceGetServerData {
    [self measureBlock:^{
        [self.testServiceConnection getFeedDataFromServer];
    }];
}

- (void)testImageDownload{
    // [self.imageDownloaderTest dataObject];
    XCTAssertNil([self.testImageDownloader dataObject], @"Data object is nil");
}

@end
