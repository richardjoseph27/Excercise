//
//  FeedDataTableViewCell.m
//  FeedDataAssignment
//
//  Created by Richard Joseph on 20/03/18.
//  Copyright © 2018 Richard Joseph. All rights reserved.
//

#import "FeedDataTableViewCell.h"

@implementation FeedDataTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        //customize the cell
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.numberOfLines = 0;
        self.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.detailTextLabel.numberOfLines = 0;
    }
    return self;
}
@end

