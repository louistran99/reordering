//
//  CustomedCell.h
//  Postlets
//
//  Created by Louis Tran on 5/20/14.
//  Copyright (c) 2014 Zillow Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomedCell : UICollectionViewCell

@property (nonatomic,strong) UILabel *amenity;

-(void) updateCellWithSelection:(BOOL) selection;

@end
