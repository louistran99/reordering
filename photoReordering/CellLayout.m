//
//  CellLayout.m
//  photoReordering
//
//  Created by Louis Tran on 5/22/14.
//  Copyright (c) 2014 Louis Tran. All rights reserved.
//

#import "CellLayout.h"

#define LARGE_CELL_WIDTH 260
#define SMALL_CELL_WIDTH 70
#define DX 10
#define DY 10


@interface CellLayout () {
    NSMutableArray *attributes;
    NSMutableArray *cellCenters;
    CGPoint _sCellMargin;    // subsequent cell
    CGPoint _pCellMargin;    // primary cell
}
@end

@implementation CellLayout

-(id) init {
    self = [super init];
    if (self) {
//        self.itemSize = CGSizeMake(SMALL_CELL_WIDTH, SMALL_CELL_WIDTH);
//        self.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
        attributes = [[NSMutableArray alloc] init];
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
//    CGRect screenSize = [[UIScreen mainScreen] bounds];
    

    
//    _sCellMargin = CGPointMake(0, 0);
//    
//    NSInteger numOfColumns = screenSize.size.width/SMALL_CELL_WIDTH;
//    NSInteger dXSum = (NSInteger)screenSize.size.width % SMALL_CELL_WIDTH;
//    CGFloat dX = dXSum/numOfColumns; // horizontal space between cells
//    CGFloat dY = DY;
//    
//    cellCenters = [[NSMutableArray alloc] init];

//    CGPoint Center = CGPointMake(0.0f, 0.0f);
    
    
    UICollectionViewLayoutAttributes *attribute = [self setUpMainCellLayout:CGSizeMake(LARGE_CELL_WIDTH, LARGE_CELL_WIDTH)];
    [attributes addObject:attribute];
    
    NSArray *secondaryAttributes = [self setUpSecondaryCellLayouts:CGSizeMake(SMALL_CELL_WIDTH, SMALL_CELL_WIDTH)];
    [attributes addObjectsFromArray:secondaryAttributes];
    
//    NSInteger secondaryCellIndex = 1;
//    for (NSInteger index=0; index < _cellCount-secondaryCellIndex; index++) {
//        NSInteger col = (index)%numOfColumns;
//        CGFloat x = (1+2*col)*SMALL_CELL_WIDTH/2 + (1+2*col)*dX;
//        NSInteger row = index/numOfColumns;
//        CGFloat y = LARGE_CELL_WIDTH + 2*dY + (1+2*row)*dY;
//        attribute.size = CGSizeMake(SMALL_CELL_WIDTH, SMALL_CELL_WIDTH);
//        attribute.center = CGPointMake(x, y);
//        [attributes addObject:attribute];
//    }
//    
//    
//    _sCellMargin.x = 0;
//    _sCellMargin.y = 0.0f;
//    _pCellMargin.x = (screenSize.size.width - LARGE_CELL_WIDTH)/2;
//    _pCellMargin.y = DY;
    
}

// we only handle vertical scrolling for now...  we'll need generalize this method to handle horizontal scrolling
-(NSArray*) setUpSecondaryCellLayouts: (CGSize) size {
    NSMutableArray *attributesToReturn = [[NSMutableArray alloc] init];
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    NSInteger numberOfColumns = screenSize.size.width / size.width;
    NSInteger dxSum = (NSInteger) screenSize.size.width % (NSInteger) size.width;
    CGFloat horizontalSpacing = dxSum/(2*numberOfColumns);
    UICollectionViewLayoutAttributes *attribute;
    
    for (NSInteger index=0; index < _cellCount; index++) {
        NSInteger col = (index)%numberOfColumns;
        NSInteger row = index/numberOfColumns;
        CGFloat x = (1+2*col)*size.width/2 + (1+2*col)*horizontalSpacing;
        CGFloat y = (1+2*row)*size.height/2 + (1+2*row)*horizontalSpacing;
        
        attribute.center = CGPointMake(x, y);
        attribute.size = CGSizeMake(size.width, size.height);
        [attributesToReturn addObject:attribute];
    }
    return attributesToReturn;
}

-(UICollectionViewLayoutAttributes *) setUpMainCellLayout:(CGSize) size {
    UICollectionViewLayoutAttributes *attribute;
    attribute.size = size;

    CGPoint center = CGPointMake(0, 0);
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    center.x = (screenSize.size.width - size.width)/2;
    center.y = (screenSize.size.height - size.height)/2;
    attribute.center = center;
    
    return attribute;
}


-(UICollectionViewLayoutAttributes *) layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    if (indexPath.section==0 && indexPath.item==0) {
        attributes.size = CGSizeMake(LARGE_CELL_WIDTH, LARGE_CELL_WIDTH);
        attributes.center = CGPointMake(LARGE_CELL_WIDTH/2 + _pCellMargin.x,
                                        LARGE_CELL_WIDTH/2 + _pCellMargin.y);
    } else {
        attributes.size = CGSizeMake(SMALL_CELL_WIDTH, SMALL_CELL_WIDTH);
        CGPoint cellCenter = CGPointMake(0, 0);
        cellCenter.x = (SMALL_CELL_WIDTH+DX)/2 + (indexPath.item-1)*(SMALL_CELL_WIDTH+DX);
        NSInteger columns = (int)self.collectionView.frame.size.width / SMALL_CELL_WIDTH;
        CGFloat dx = (self.collectionView.frame.size.width - columns*SMALL_CELL_WIDTH)/columns;
        
        
        NSInteger row = (NSInteger)(cellCenter.x/self.collectionView.frame.size.width);
        cellCenter.y = LARGE_CELL_WIDTH + (SMALL_CELL_WIDTH+DX)/2 + row*(SMALL_CELL_WIDTH+DX);
        cellCenter.x = (int)cellCenter.x % (int)self.collectionView.frame.size.width;
        attributes.center = cellCenter;
    }
    return attributes;
}

@end
