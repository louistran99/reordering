//
//  CellLayout.m
//  photoReordering
//
//  Created by Louis Tran on 5/22/14.
//  Copyright (c) 2014 Louis Tran. All rights reserved.
//

#import "CellLayout.h"

#import "CustomedCell.h"

#define LARGE_CELL_WIDTH 260
#define SMALL_CELL_WIDTH 70
#define DX 10
#define DY 10


@interface CellLayout ()



@end

@implementation CellLayout

-(id) init {
    self = [super init];
    if (self) {
//        self.itemSize = CGSizeMake(SMALL_CELL_WIDTH, SMALL_CELL_WIDTH);
//        self.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
//        localAttributes = [NSMutableArray array];
//        [self setupGestureRecognizers];
    }
    return self;
}


-(void) setupGestureRecognizers {
    _longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressed:)];
    [_longPressRecognizer setNumberOfTapsRequired:1];
    _longPressRecognizer.enabled = YES;
    _longPressRecognizer.delegate = self;
    [self.collectionView addGestureRecognizer:_longPressRecognizer];
    

}


-(void) handleLongPressed:(UILongPressGestureRecognizer*) sender {
    CGPoint touchLocation = [sender locationInView:self.collectionView];
    NSIndexPath *index = [self.collectionView indexPathForItemAtPoint:touchLocation];
    CustomedCell *cell = (CustomedCell*)[self.collectionView cellForItemAtIndexPath:index];
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.collectionView performBatchUpdates:^{
            _longPressedCell = index;
            _scale = 1.2f;
            _cellCenter = cell.center;
        } completion:nil];
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [self.collectionView performBatchUpdates:^{
            _longPressedCell = index;
            _scale = 1.0f;
            _cellCenter = cell.center;
        } completion:nil];
    }
}



-(void) setLongPressedCell:(NSIndexPath *)longPressedCell {
    _longPressedCell = longPressedCell;
    [self invalidateLayout];
}



-(CGSize) collectionViewContentSize {
    return self.collectionView.frame.size;
}

-(NSArray*) layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [NSMutableArray array];
    for (NSInteger i=0; i<_cellCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    for (UICollectionViewLayoutAttributes *cellLayout in attributes) {
        cellLayout.zIndex = 0;
        if ([cellLayout.indexPath isEqual:_longPressedCell]) {
            cellLayout.center = _cellCenter;
            cellLayout.transform3D = CATransform3DMakeScale(_scale, _scale, 1.0f);
            cellLayout.zIndex = 1;
        }
    }
    return attributes;
}


-(void) prepareLayout {
    [super prepareLayout];
    _cellCount = [self.collectionView numberOfItemsInSection:0];
//    [self setupGestureRecognizers];
    
    
}

// we only handle vertical scrolling for now...  we'll need generalize this method to handle horizontal scrolling
-(UICollectionViewLayoutAttributes *) setUpSecondaryCell: (CGSize) size atIndexPath:(NSIndexPath*) index {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:index];

    CGRect screenSize = [[UIScreen mainScreen] bounds];
    NSInteger numberOfColumns = screenSize.size.width / size.width;
    NSInteger dxSum = screenSize.size.width - numberOfColumns*size.width;
    CGFloat horizontalSpacing = dxSum/(2*numberOfColumns);
    NSInteger col = index.item % numberOfColumns;
    NSInteger row = index.item / numberOfColumns;
    
    UICollectionViewLayoutAttributes *mainCellLayout = [self setUpMainCellLayout:CGSizeMake(LARGE_CELL_WIDTH, LARGE_CELL_WIDTH)];
    if (!CGSizeEqualToSize(size, mainCellLayout.frame.size)) {
        col = (index.item-1) % numberOfColumns; // we have a main cell
        NSInteger numCellsPerMainCell = mainCellLayout.frame.size.height/size.height + .5;
        row = (index.item-1) / numberOfColumns + numCellsPerMainCell;
    }
    CGFloat x = (1+2*col)*size.width/2 + (1+2*col)*horizontalSpacing;
    CGFloat y = (1+2*row)*size.height/2 + (1+2*row)*horizontalSpacing;
    attributes.center = CGPointMake(x, y);
    attributes.size = size;
    return attributes;
}

-(UICollectionViewLayoutAttributes *) setUpMainCellLayout:(CGSize) size {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attribute.size = size;
    CGPoint center = CGPointMake(0, 0);
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    center.x = (screenSize.size.width - size.width)/2 + size.width/2;
    center.y = center.x;
    attribute.center = CGPointMake(center.x, center.x);
    return attribute;
}


-(UICollectionViewLayoutAttributes *) layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attributes;// = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    if (indexPath.section==0 && indexPath.item==0) {
        attributes = [self setUpMainCellLayout:CGSizeMake(LARGE_CELL_WIDTH, LARGE_CELL_WIDTH)];
    } else {
        attributes = [self setUpSecondaryCell:CGSizeMake(SMALL_CELL_WIDTH, SMALL_CELL_WIDTH) atIndexPath:indexPath];
    }
    return attributes;
    
}

#pragma mark UIGestureRecognizerDelegate
-(BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    if ([_longPressRecognizer isEqual:gestureRecognizer]) {
//        if (_longPressedCell) {
//            return YES;
//        }
//    }
//    return NO;
    return YES;
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    if ([_longPressRecognizer isEqual:gestureRecognizer]) {
//        return YES;
//    }
    return YES;
}





@end
