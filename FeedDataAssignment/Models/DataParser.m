//
//  DataParser.m
//  FeedDataAssignment
//
//  Created by Richard Joseph on 20/03/18.
//  Copyright © 2018 Richard Joseph. All rights reserved.
//

#import "DataParser.h"
#import "DataObject.h"
#import "ServerConstants.h"

#define kRowDataIsEmpty 3

@interface DataParser()
// Redeclare feedList so we can modify it within this class
@property (nonatomic, strong) NSArray *feedList;

@end

@implementation DataParser

- (instancetype)initWithData:(NSData *)data
{
    self = [super init];
    if (self != nil)
    {
        _dataToParse = data;
    }
    return self;
}

-(void)main{
    
    NSMutableArray *allFeedDataArray = [[NSMutableArray alloc] init];
    NSError *JSONError = nil;
    id json = [NSJSONSerialization JSONObjectWithData:[[[NSString alloc] initWithData:_dataToParse encoding:NSASCIIStringEncoding] dataUsingEncoding:NSUTF8StringEncoding] options:0 error: &JSONError];
    if (JSONError) {
        NSLog(@"Json parsing error");
    }else{
        NSArray* dataRowArray = [json objectForKey:kParsingKeyDataRows];
        self.navBarTitle = [json objectForKey:kParsingKeyMainTitle];
        
        for (int index = 0; index < dataRowArray.count; index++)
        {
            DataObject *dataObject = [[DataObject alloc] init];
            NSDictionary *dict = (NSDictionary *)[dataRowArray objectAtIndex: index];
            int allDataEmptyCheck = 0;
            
            if ([dict objectForKey:kParsingKeyTitle] == (id)[NSNull null]) {
                dataObject.title = @"";
                allDataEmptyCheck ++;
            }else{
                dataObject.title = [dict objectForKey:kParsingKeyTitle];
            }
            
            if ([dict objectForKey:kParsingKeyDescriptionText] == (id)[NSNull null]) {
                dataObject.descriptionText = @"";
                allDataEmptyCheck ++;
            }else{
                dataObject.descriptionText = [dict objectForKey:kParsingKeyDescriptionText];
            }
            
            if ([dict objectForKey:kParsingKeyImageURLString] == (id)[NSNull null]) {
                dataObject.imageURLString = @"";
                allDataEmptyCheck ++;
            }else{
                dataObject.imageURLString = [dict objectForKey:kParsingKeyImageURLString];
            }
            
            if (kRowDataIsEmpty == allDataEmptyCheck) {
                NSLog(@"no data available for this row");
            }else{
                [allFeedDataArray addObject: dataObject];
            }
        }
    }
    if (![self isCancelled])
    {
        // Set appRecordList to the result of our parsing
        self.feedList = [NSArray arrayWithArray:allFeedDataArray];
    }
}

@end
