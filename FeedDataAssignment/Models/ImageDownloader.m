//
//  ImageDownloader.m
//  FeedDataAssignment
//
//  Created by Richard Joseph on 20/03/18.
//  Copyright © 2018 Richard Joseph. All rights reserved.
//

#import "ImageDownloader.h"
#import "DataObject.h"

#import "ImageDownloader.h"
#import "DataObject.h"

static const int kAppIconSize = 200;

@interface ImageDownloader ()

@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;

@end

@implementation ImageDownloader

- (void)startDownloadTask
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.dataObject.imageURLString]];
    // create an session data task to obtain and download the app icon
    _sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // in case we want to know the response status code
        
        if (error != nil)
        {
            if ([error code] == NSURLErrorAppTransportSecurityRequiresSecureConnection)
            {
                // if you get error NSURLErrorAppTransportSecurityRequiresSecureConnection (-1022),
                // then your Info.plist has not been properly configured to match the target server.
                //
                abort();
            }
            //in case of error set default image
            self.dataObject.appIcon = [UIImage imageNamed:@"placeHolder"];
            [self handleError:error];
            if (self.completionHandler != nil)
            {
                self.completionHandler();
            }
            [self cancelDownload];
        }else{
            if ([(NSHTTPURLResponse *)response statusCode] != 200) {
                //handle status code 404, 403, 400 error set default image
                self.dataObject.appIcon = [UIImage imageNamed:@"placeHolder"];
                [self handleError:error];
                if (self.completionHandler != nil)
                {
                    self.completionHandler();
                }
                [self cancelDownload];
            }else{
                [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                    
                    // Set appIcon and clear temporary data/image
                    UIImage *image = [[UIImage alloc] initWithData:data];
                    self.dataObject.appIcon = image;
                    //scale image wrt aspect ratio
                    if (image.size.width > kAppIconSize)
                    {
                        self.dataObject.appIcon = [self imageWithImage:image scaledToWidth:kAppIconSize];
                    }
                    else
                    {
                        self.dataObject.appIcon = image;
                    }
                    
                    // call our completion handler to tell our client that our icon is ready for display
                    if (self.completionHandler != nil)
                    {
                        self.completionHandler();
                    }
                }];
            }
        }
    }];
    [self.sessionTask resume];
}

- (void)cancelDownload
{
    [self.sessionTask cancel];
    _sessionTask = nil;
}

//scale the image without disturbing the aspect ratio
-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)startDownload{
    NSMutableArray *currentTasks = [[NSMutableArray alloc]init];
    [[NSURLSession sharedSession] getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        for (NSURLSessionDataTask *task in dataTasks)
        {
            [currentTasks addObject:[NSString stringWithFormat:@"%@", task.originalRequest.URL]];
        }
        //check if the download is already in progress.
        if (![currentTasks containsObject:self.dataObject.imageURLString]) {
            [self startDownloadTask];
        }
    }];
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
