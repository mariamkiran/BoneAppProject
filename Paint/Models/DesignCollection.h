//
//  DesignCollection.h
//  Paint
//
//  Created by admin on 2/14/15.
//  Copyright (c) 2015 Innovazor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface DesignCollection : NSObject<UICollectionViewDataSource,UICollectionViewDelegate>
{
    BOOL selected;
}
@property(nonatomic,strong) NSMutableArray *items;
@property(nonatomic,strong) NSMutableArray *delItems;
@property(nonatomic,strong) UICollectionView *colView;

-(void)selectCells:(BOOL)toggle;

@end
