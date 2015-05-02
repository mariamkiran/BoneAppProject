//
//  DesignCollection.m
//  Paint
//
//  Created by admin on 2/14/15.
//  Copyright (c) 2015 Innovazor. All rights reserved.
//

#import "DesignCollection.h"

@implementation DesignCollection

@synthesize items,
colView,
delItems;

#pragma mark -
#pragma mark UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return [items count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *myCell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:@"MyCell"
                                    forIndexPath:indexPath];
    myCell.layer.borderWidth=0.0f;
    myCell.layer.borderColor=[UIColor clearColor].CGColor;
    
    NSMutableArray *design = [items objectAtIndex:indexPath.row];
    NSString *strName = [design objectAtIndex:1];
    NSDate *date = [design objectAtIndex:5];
    
    UILabel *lblName = (UILabel *)[myCell viewWithTag:1];
    UILabel *lblDate = (UILabel *)[myCell viewWithTag:3];
    UIImageView *imgView = (UIImageView *)[myCell viewWithTag:2];
    if (![[design objectAtIndex:4] isEqualToString:@""])
    {
        imgView.image = [UIImage imageNamed:[self getPath:[design objectAtIndex:4]]];
    }
    else
        imgView.image = nil;
    [lblName setText:strName];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mma"];
    NSString *theDate = [dateFormat stringFromDate:date];
    NSLog(@"ff %@",[design objectAtIndex:4]);
    [lblDate setText:theDate];
    
    return myCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!selected) {
        return;
    }
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderWidth=5.0f;
    cell.layer.borderColor=[UIColor redColor].CGColor;
    cell.layer.cornerRadius = 5;
    cell.layer.masksToBounds = true;
    
    if (!delItems) {
        delItems = [[NSMutableArray alloc] init];
    }
    [delItems addObject:[items objectAtIndex:indexPath.row]];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)selectCells:(BOOL)toggle
{
    if (toggle)
    {
        selected = YES;
        [self.colView setAllowsMultipleSelection:YES];
    }
    else
    {
        selected = NO;
        [self.colView setAllowsMultipleSelection:NO];
        for(NSIndexPath *iP in self.colView.indexPathsForSelectedItems)
        {
            [self.colView deselectItemAtIndexPath:iP animated:NO];
        } 
    }
}

-(NSString *)getPath:(NSString *)path
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",path]];
    return savedImagePath;
}

@end
