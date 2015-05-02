//
//  ItemPicker.h
//  Paint
//
//  Created by admin on 2/14/15.
//  Copyright (c) 2015 Innovazor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PickerDelegate <NSObject>

-(void)pickerSelection:(NSString *)value;

@end

@interface ItemPicker : NSObject<UIPickerViewDataSource,UIPickerViewDelegate>
{
    id pDelegate;
}
@property (strong, nonatomic) UIPickerView * myPickerView;
@property (strong, nonatomic) NSMutableArray * pickerItems;
@property (strong, nonatomic) id pDelegate;

- (UIPickerView*)showPicker:(NSMutableArray *)items pickerFrame:(CGRect)frame delegate:(id)deleg;
@end
