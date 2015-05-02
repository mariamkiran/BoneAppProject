//
//  PainterView.m
//  Paint
//
//  Created by admin on 2/16/15.
//  Copyright (c) 2015 Innovazor. All rights reserved.
//

#import "PainterView.h"

@implementation PainterView
{
    UIBezierPath *path;
    UIImage *incrementalImage;
    CGPoint pts[5]; // to keep track of the four points of our Bezier segment
    uint ctr; // a counter variable to keep track of the point index
    UIColor *selectedColor;
    UIColor *prevColor;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        pLineWidth = 1;        
        selectedColor = [UIColor blackColor];
        prevColor = selectedColor;
        [self setMultipleTouchEnabled:NO];
        [self setBackgroundColor:[UIColor whiteColor]];
        path = [UIBezierPath bezierPath];
        [path setLineWidth:2.0];
        
    }
    return self;
    
}

- (void)pen
{
    pLineWidth = 1;
    selectedColor = prevColor;
}

- (void)changeColor:(NSNumber *)colorCode
{
    selectedColor = [self selColor:[colorCode integerValue]];
    prevColor = selectedColor;
}

- (void)painter
{ 
    pLineWidth = 15;
    selectedColor = prevColor;
}

- (void)erasePage
{
    pLineWidth = 15;
    selectedColor = [UIColor whiteColor];
}

- (void)clearPage
{
    incrementalImage = nil;
    [self drawBitmap];
    [self setNeedsDisplay];
}

- (NSString *)savePage:(NSNumber *)designId
{
    NSString *imgpath = [self saveImage];
    AppDelegate *deleg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [deleg updateDesign:designId :imgpath];
    return imgpath;
}

- (NSString *)saveImage
{
    NSDate *now = [[NSDate alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy-HH-mma"];
    NSString *theDate = [dateFormat stringFromDate:now];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",theDate]];
    UIImage *image = incrementalImage;
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:savedImagePath atomically:NO];
    return theDate;
}

- (void)drawRect:(CGRect)rect
{
    [incrementalImage drawInRect:rect];
    [selectedColor setStroke];
    [path stroke];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    ctr = 0;
    UITouch *touch = [touches anyObject];
    pts[0] = [touch locationInView:self];
    path.lineWidth = pLineWidth;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    ctr++;
    pts[ctr] = p;
    if (ctr == 4) // 4th point
    {
        pts[3] = CGPointMake((pts[2].x + pts[4].x)/2.0, (pts[2].y + pts[4].y)/2.0); // move the endpoint to the middle of the line joining the second control point of the first Bezier segment and the first control point of the second Bezier segment
        
        [path moveToPoint:pts[0]];
        [path addCurveToPoint:pts[3] controlPoint1:pts[1] controlPoint2:pts[2]]; // this is how a Bezier curve is appended to a path. We are adding a cubic Bezier from pt[0] to pt[3], with control points pt[1] and pt[2]
        [self setNeedsDisplay];
        pts[0] = pts[3];
        pts[1] = pts[4];
        ctr = 1;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self drawBitmap];
    [self setNeedsDisplay];
    pts[0] = [path currentPoint]; // let the second endpoint of the current Bezier segment be the first one for the next Bezier segment
    [path removeAllPoints];
    ctr = 0;
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

- (void)drawBitmap
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
    [selectedColor setStroke];
    if (!incrementalImage) // first time; paint background white
    {
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
        [[UIColor whiteColor] setFill];
        [rectpath fill];
    }
    [incrementalImage drawAtPoint:CGPointZero];
    [path stroke];
    incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

-(UIColor *)selColor:(NSInteger)seed
{
    switch (seed) {
        case 701:
            return [UIColor redColor];
            break;
        
        case 702:
            return [UIColor greenColor];
            break;
            
        case 703:
            return [UIColor yellowColor];
            break;
            
        case 704:
            return [UIColor grayColor];
            break;
            
        case 705:
            return [UIColor purpleColor];
            break;
            
        case 706:
            return [UIColor blackColor];
            break;
        default:
            break;
    }
    return [UIColor blackColor];
}

@end
