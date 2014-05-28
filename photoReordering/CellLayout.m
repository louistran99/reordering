//
//  CellLayout.m
//  photoReordering
//
//  Created by Louis Tran on 5/22/14.
//  Copyright (c) 2014 Louis Tran. All rights reserved.
//

#import "CellLayout.h"

#define LARGE_CELL_WIDTH 260
#define SMALL_CELL_WIDTH 100
#define DX 10
#define DY 10


@interface CellLayout () {
    NSMutableArray *localAttributes;
//    NSMutableArray *cellCenters;
//    CGPoint _sCellMargin;    // subsequent cell
//    CGPoint _pCellMargin;    // primary cell
}
@end

@implementation CellLayout

-(id) init {
    self = [super init];
    if (self) {
//        self.itemSize = CGSizeMake(SMALL_CELL_WIDTH, SMALL_CELL_WIDTH);
//        self.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
        localAttributes = [NSMutableArray array];
    }
    return self;
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

-(void) prepareLayout {
    [super prepareLayout];
    _cellCount = [self.collectionView numberOfItemsInSection:0];
    
    
//    [localAttributes addObject:[self setUpMainCellLayout:CGSizeMake(LARGE_CELL_WIDTH, LARGE_CELL_WIDTH)]];
    
    NSArray *secondaryAttributes = [self setUpSecondaryCellLayouts:CGSizeMake(SMALL_CELL_WIDTH, SMALL_CELL_WIDTH)];
    [localAttributes addObjectsFromArray:secondaryAttributes];
    
}

// we only handle vertical scrolling for now...  we'll need generalize this method to handle horizontal scrolling
-(NSArray*) setUpSecondaryCellLayouts: (CGSize) size {
    
    NSMutableArray *attributesToReturn = [[NSMutableArray alloc] init];
//    UICollectionViewLayoutAttributes *mainCellLayout = [self setUpMainCellLayout:CGSizeMake(LARGE_CELL_WIDTH, LARGE_CELL_WIDTH)];
    
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    NSInteger numberOfColumns = screenSize.size.width / size.width;
    NSInteger dxSum = (NSInteger) screenSize.size.width % (NSInteger) size.width;
    CGFloat horizontalSpacing = dxSum/(2*numberOfColumns);
    
//    CGFloat yOffset = mainCellLayout.frame.size.height;
//    if (CGSizeEqualToSize(size,mainCellLayout.frame.size)) {
//         ;// we don't have a main cell
//        yOffset = 0.0f;
//    } else {
//        ;// we have a main cell
//        yOffset = mainCellLayout.frame.size.height;
////        [attributesToReturn addObject:mainCellLayout];
//    }

    
    for (NSInteger index=0; index < _cellCount; index++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        NSInteger col = (index)%numberOfColumns;
        NSInteger row = index/numberOfColumns;
        CGFloat x = (1+2*col)*size.width/2 + (1+2*col)*horizontalSpacing;
        CGFloat y = (1+2*row)*size.height/2 + (1+2*row)*horizontalSpacing + 320;
        attribute.center = CGPointMake(x, y);
        attribute.size = CGSizeMake(size.width, size.height);
        [attributesToReturn addObject:attribute];
    }
    return attributesToReturn;
}


-(UICollectionViewLayoutAttributes *) setUpSecondaryCell: (CGSize) size atIndexPath:(NSIndexPath*) index {
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:index];

    
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    NSInteger numberOfColumns = screenSize.size.width / size.width;
    NSInteger dxSum = (NSInteger) screenSize.size.width / (NSInteger) size.width;
    CGFloat horizontalSpacing = dxSum/(2*numberOfColumns);
    
    NSIndexPath *mainCellIndex = [NSIndexPath indexPathForItem:0 inSection:0];
    UICollectionViewLayoutAttributes *mainCellLayout = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:mainCellIndex];
    if (CGSizeEqualToSize(size, mainCellLayout.frame.size)) {
    
    } else {
    
    }
    
    
    return attribute;
}

-(UICollectionViewLayoutAttributes *) setUpMainCellLayout:(CGSize) size {
//    UICollectionViewLayoutAttributes *attribute = [[UICollectionViewLayoutAttributes alloc] init];
    
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
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    
    if (indexPath.section==0 && indexPath.item==0) {
        attributes = [self setUpMainCellLayout:CGSizeMake(LARGE_CELL_WIDTH, LARGE_CELL_WIDTH)];
//        attributes = [localAttributes objectAtIndex:indexPath.item];
    } else {
        attributes = [localAttributes objectAtIndex:indexPath.item];
    
    }
    
    return attributes;
    
}

@end
