//
//  ViewController.m
//  photoReordering
//
//  Created by Louis Tran on 5/22/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "CustomedCell.h"
#import "CellLayout.h"

static NSString *collectionCellID = @"cellColor";

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate> {
    NSMutableArray *arrayOfColors;

}

@end

@implementation ViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self createRandomizedColors];

    // set up uicollectionview
    [self.containerView registerClass:[CustomedCell class] forCellWithReuseIdentifier:collectionCellID];
    [self.containerView setCollectionViewLayout:[[CellLayout alloc] init]];
    
    // register to handle gestures
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [longPress setNumberOfTouchesRequired:1];
    [self.containerView addGestureRecognizer:longPress];
    
}

-(void) handleLongPress:(UILongPressGestureRecognizer*) sender {
    CGPoint touchLocation = [sender locationInView:self.containerView];
    NSIndexPath *indexPath = [self.containerView indexPathForItemAtPoint:touchLocation];
    CustomedCell *cell = (CustomedCell*)[self.containerView cellForItemAtIndexPath:indexPath];
    CellLayout *layout = (CellLayout*)self.containerView.collectionViewLayout;

    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.containerView performBatchUpdates:^{
            [layout setLongPressedCell:indexPath];
            [layout setCellCenter:cell.center];
            [layout setScale:1.2f];
        } completion:nil];
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [self.containerView performBatchUpdates:^{
            [layout setLongPressedCell:indexPath];
            [layout setCellCenter:cell.center];
            [layout setScale:1.0f];
        } completion:nil];
    
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectionViewDelegate
-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    
    UIColor *cellColor = [arrayOfColors objectAtIndex:indexPath.item];
    cell.backgroundView.backgroundColor = cellColor;
    return cell;
}


#pragma mark UICollectionViewDataSource
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return arrayOfColors.count;
}


#pragma mark Create Data
-(void) createRandomizedColors {
    NSInteger numberOfCells = 3;
    arrayOfColors = [[NSMutableArray alloc] init];
    for (int i = 0; i<numberOfCells; i++) {
        CGFloat r = (float)(rand()%256)/256;
        CGFloat g = (float)(rand()%256)/256;
        CGFloat b = (float)(rand()%256)/256;
        UIColor *cellColor = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
        [arrayOfColors addObject:cellColor];
    }
}

@end
