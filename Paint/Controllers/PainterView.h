//
//  PainterView.h
//  Paint
//
//  Created by admin on 2/16/15.
//  Copyright (c) 2015 Innovazor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface PainterView : UIView
{
    CGFloat pLineWidth;
}

-(UIColor *)selColor:(NSInteger)seed;
- (void)pen;
- (void)changeColor:(NSNumber *)colorCode;
- (void)painter;
- (void)erasePage;
- (void)clearPage;
- (NSString *)savePage:(NSNumber *)designId;

@end
