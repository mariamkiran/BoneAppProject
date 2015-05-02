//
//  ItemPicker.m
//  Paint
//
//  Created by admin on 2/14/15.
//  Copyright (c) 2015 Innovazor. All rights reserved.
//

#import "ItemPicker.h"

@implementation ItemPicker

@synthesize myPickerView,pickerItems,pDelegate;

- (UIPickerView*)showPicker:(NSMutableArray *)items pickerFrame:(CGRect)frame delegate:(id)deleg
{
    
    pickerItems = items;
    pDelegate = deleg;
    myPickerView = [[UIPickerView alloc] initWithFrame:frame];
    myPickerView.delegate = self;
    myPickerView.dataSource = self;
    myPickerView.showsSelectionIndicator = YES;
    [myPickerView setShowsSelectionIndicator:YES];
    [myPickerView setBackgroundColor:[UIColor grayColor]];
    return myPickerView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:        (NSInteger)component {
    // Handle the selection
    NSString *val;
    val = [pickerItems objectAtIndex:row];
    if (![val isEqualToString:@"Select Age"] && ![val isEqualToString:@"Select Gender"]) {
        [pDelegate pickerSelection:val];
    }
    else
    {
        [pDelegate pickerSelection:@""];
    }
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows = [pickerItems count];
    
    return numRows;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

 
 
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 37)];
    label.text = [pickerItems objectAtIndex:row];
    label.textAlignment = NSTextAlignmentCenter; //Changed to NS as UI is deprecated.
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:24];
    label.backgroundColor = [UIColor clearColor];
 
    return label;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 164;
    
    return sectionWidth;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    int sectionHeight = 60;
    
    return sectionHeight;
}
@end
