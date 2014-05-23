//
//  CellLayout.m
//  photoReordering
//
//  Created by Louis Tran on 5/22/14.
//  Copyright (c) 2014 Louis Tran. All rights reserved.
//

#import "CellLayout.h"

#define LARGE_CELL_WIDTH 300
#define SMALL_CELL_WIDTH 100
#define DX 10
#define DY 10

@implementation CellLayout

-(id) init {
    self = [super init];
    if (self) {
//        self.itemSize = CGSizeMake(SMALL_CELL_WIDTH, SMALL_CELL_WIDTH);
//        self.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
    }
    return self;
}


-(void) setLongPressedCell:(NSIndexPath *)longPressedCell {
    _longPressedCell = longPressedCell;
    [self invalidateLayout];
}

-(void) prepareLayout {
    [super prepareLayout];
    _cellCount = [self.collectionView numberOfItemsInSection:0];
    
    
//    CGSize size = self.collectionView.frame.size;
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
        if ([cellLayout.indexPath isEqual:_longPressedCell]) {
            cellLayout.center = _cellCenter;
            cellLayout.transform3D = CATransform3DMakeScale(_scale, _scale, 1.0f);
        }
    }
    
    return attributes;
}

//-(UICollectionViewLayoutAttributes*) initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
//    UICollectionViewLayoutAttributes *attributes;
//    if (itemIndexPath.section==0 && itemIndexPath.item==0) {
//        attributes.frame = CGRectMake(0, 0, LARGE_CELL_WIDTH, LARGE_CELL_WIDTH);
//        ;
//    } else {
//        attributes.size = CGSizeMake(SMALL_CELL_WIDTH, SMALL_CELL_WIDTH);
//    }
//    return attributes;
//}

-(UICollectionViewLayoutAttributes *) layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    if (indexPath.section==0 && indexPath.item==0) {
        attributes.size = CGSizeMake(LARGE_CELL_WIDTH, LARGE_CELL_WIDTH);
        attributes.center = CGPointMake(LARGE_CELL_WIDTH/2, LARGE_CELL_WIDTH/2);
    } else {
        attributes.size = CGSizeMake(SMALL_CELL_WIDTH, SMALL_CELL_WIDTH);
        CGPoint cellCenter = CGPointMake(0, 0);
        cellCenter.x = (SMALL_CELL_WIDTH+DX)/2 + (indexPath.item-1)*(SMALL_CELL_WIDTH+DX);
        NSInteger row = (NSInteger)(cellCenter.x/self.collectionView.frame.size.width);
        cellCenter.y = LARGE_CELL_WIDTH + (SMALL_CELL_WIDTH+DX)/2 + row*(SMALL_CELL_WIDTH+DX);
        cellCenter.x = (int)cellCenter.x % (int)self.collectionView.frame.size.width;
        attributes.center = cellCenter;
    }
    return attributes;
}

@end
