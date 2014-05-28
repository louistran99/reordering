//
//  CustomedCell.m
//  Postlets
//
//  Created by Louis Tran on 5/20/14.
//  Copyright (c) 2014 Zillow Inc. All rights reserved.
//

#import "CustomedCell.h"
//#import "PostletColorUtils.h"
//#import "ColorUtils.h"

@implementation CustomedCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _amenity = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _amenity.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _amenity.textAlignment = NSTextAlignmentCenter;
        _amenity.font = [UIFont systemFontOfSize:11.0f];
        _amenity.highlightedTextColor = [UIColor whiteColor];
        _amenity.textColor = [UIColor lightGrayColor];
        _amenity.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_amenity];
        
        // normal background
        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = [UIColor whiteColor];
        [backgroundView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [backgroundView.layer setBorderWidth:0.5f];
        [backgroundView.layer setCornerRadius:2.0f];
        self.backgroundView = backgroundView;
        
        // highlighted background
//        UIView *selectedView = [[UIView alloc] init];
//        selectedView.backgroundColor = [UIColor orangeColor];
//        [selectedView.layer setCornerRadius:2.0f];
//        self.selectedBackgroundView = selectedView;
    }
    return self;
}

-(void) updateCellWithSelection:(BOOL) selection {
    if (selection) {
        self.selectedBackgroundView.alpha = 1.0f;
        self.backgroundView.alpha = 0.0f;
        _amenity.highlighted=YES;
//        self.selected=YES;
    } else {
        self.selectedBackgroundView.alpha = 0.0f;
        self.backgroundView.alpha = 1.0f;
        _amenity.highlighted=NO;
//        self.selected=NO;
    }
}
//
//-(void) updateCell {
//    if (self.selected) {
//        self.selectedBackgroundView.alpha = 1.0f;
//        self.backgroundView.alpha = 0.0f;
//    } else {
//        self.selectedBackgroundView.alpha = 0.0f;
//        self.backgroundView.alpha = 1.0f;
//    }
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
