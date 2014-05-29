//
//  CellLayout.h
//  photoReordering
//
//  Created by Louis Tran on 5/22/14.
//  Copyright (c) 2014 Louis Tran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellLayout : UICollectionViewFlowLayout <UIGestureRecognizerDelegate>

@property (nonatomic,strong) NSIndexPath *longPressedCell;
@property (nonatomic,assign) CGPoint cellCenter;
@property (nonatomic,assign) CGFloat scale;
@property (nonatomic,assign) NSInteger cellCount;

@property (nonatomic) UILongPressGestureRecognizer *longPressRecognizer;


@end
