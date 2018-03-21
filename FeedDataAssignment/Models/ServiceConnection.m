//
//  ServiceConnection.m
//  FeedDataAssignment
//
//  Created by Richard Joseph on 20/03/18.
//  Copyright © 2018 Richard Joseph. All rights reserved.
//

#import "ServiceConnection.h"
#import "AppDelegate.h"
#import "ServerConstants.h"

@implementation ServiceConnection

- (void) getFeedDataFromServer{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kServerURL]];
    
    // create an session data task json feed
    NSURLSessionDataTask *sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // in case we want to know the response status code
        //NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
        if (error != nil)
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
                if ([error code] == NSURLErrorAppTransportSecurityRequiresSecureConnection)
                {
                    // if you get error NSURLErrorAppTransportSecurityRequiresSecureConnection (-1022),
                    // then your Info.plist has not been properly configured to match the target server.
                    //
                    abort();
                }
                else
                {
                    [self handleError:error];
                }
            }];
        }
        else
        {
            // create the queue to run our ParseOperation
            self.queue = [[NSOperationQueue alloc] init];
            
            // create an ParseOperation (NSOperation subclass) to parse the JSON feed data so that the UI is not blocked
            _parser = [[DataParser alloc] initWithData:data];
            
            __weak ServiceConnection *weakSelf = self;
            
            self.parser.errorHandler = ^(NSError *parseError) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    [weakSelf handleError:parseError];
                });
            };
            
            // referencing parser from within its completionBlock would create a retain cycle
            __weak DataParser *weakParser = self.parser;
            
            self.parser.completionBlock = ^(void) {
                // The completion block may execute on any thread.  Because operations
                // involving the UI are about to be performed, they execute on the main thread.
                //
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    if (weakParser.feedList != nil)
                    {
                        // call completion handler to tell our client that our icon is ready for display
                        if (self.completionHandler != nil)
                        {
                            weakSelf.completionHandler(weakParser.feedList, weakParser.navBarTitle);
                        }
                    }
                });
                
                // we are finished with the queue and our ParseOperation
                weakSelf.queue = nil;
            };
            
            [self.queue addOperation:self.parser]; // this will start the "ParseOperation"
        }
    }];
    
    [sessionTask resume];
    
    // show in the status bar that network activity is starting
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)handleError:(NSError *)error
{
    NSString *errorMessage = [error localizedDescription];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error in connection", @"")
                                                                   message:errorMessage
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"")
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
                                                         // dissmissal of alert completed
                                                     }];
    
    [alert addAction:OKAction];
    UIBarButtonItem *button;
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    alert.popoverPresentationController.barButtonItem = button;
    alert.popoverPresentationController.sourceView = vc.view;
    
    if(vc.presentedViewController == nil) {
        [vc presentViewController:alert animated:YES completion:nil];
    }
}

@end
