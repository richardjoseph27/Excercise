//
//  ImageDownloader.m
//  FeedDataAssignment
//
//  Created by Richard Joseph on 20/03/18.
//  Copyright © 2018 Richard Joseph. All rights reserved.
//

#import "ImageDownloader.h"
#import "DataObject.h"

#define kAppIconSize 200

@interface ImageDownloader ()

@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;

@end

@implementation ImageDownloader

- (void)startDownload
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.dataObject.imageURLString]];
    
    // create an session data task to obtain and download the app icon
    _sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // in case we want to know the response status code
        //NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
        if (error != nil)
        {
            if ([error code] == NSURLErrorAppTransportSecurityRequiresSecureConnection)
            {
                // if you get error NSURLErrorAppTransportSecurityRequiresSecureConnection (-1022),
                // then your Info.plist has not been properly configured to match the target server.
                //
                abort();
            }
            //[self handleError:error];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
            
            // Set appIcon and clear temporary data/image
            UIImage *image = [[UIImage alloc] initWithData:data];
            self.dataObject.appIcon = image;
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
    }];
    [self.sessionTask resume];
}

// -------------------------------------------------------------------------------
//    cancelDownload
// -------------------------------------------------------------------------------
- (void)cancelDownload
{
    [self.sessionTask cancel];
    _sessionTask = nil;
}

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
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

@end
