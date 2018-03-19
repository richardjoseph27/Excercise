//
//  AppDelegate.m
//  FeedDataAssignment
//
//  Created by Richard Joseph on 19/03/18.
//  Copyright © 2018 Richard Joseph. All rights reserved.
//

#import "AppDelegate.h"
#import "DataFeedTableViewController.h"
#import "ServiceConnection.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    DataFeedTableViewController *viewController = [[DataFeedTableViewController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController: viewController];
    self.window.rootViewController = navController;
    
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    
    ServiceConnection *serviceConnection = [[ServiceConnection alloc]init];
    [serviceConnection setCompletionHandler:^(NSArray *refreshedData, NSString *navBarTitle) {
        if (refreshedData.count > 0) {
            viewController.feedData = refreshedData;
            viewController.navigationController.navigationBar.topItem.title = navBarTitle;
            [viewController.tableView reloadData];
        }else{
            NSLog(@"No data available to show");
        }
    }];
    [serviceConnection getFeedDataFromServer];
    
    // show in the status bar that network activity is starting
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
