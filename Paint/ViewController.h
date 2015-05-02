//
//  ViewController.h
//  Paint
//
//  Created by admin on 2/10/15.
//  Copyright (c) 2015 Innovazor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ItemPicker.h"
#import "DesignCollection.h"
#import "PaintViewController.h"

@interface ViewController : UIViewController<PickerDelegate,UITextFieldDelegate>
{
    NSInteger picterType;
    //age=0,gender=1
    BOOL keyboardUp;
    BOOL pickerUp;
    BOOL delSelected;
    BOOL viewPushed;
}
@property(nonatomic,strong) IBOutlet UIView *infoForm;
@property(nonatomic,strong) IBOutlet UILabel *viewTitle;
@property(nonatomic,strong) IBOutlet UILabel *LblError;
@property(nonatomic,strong) IBOutlet UILabel *Lblstar;
@property(nonatomic,strong) IBOutlet UITextField *txtName;
@property(nonatomic,strong) IBOutlet UITextField *txtAge;
@property(nonatomic,strong) IBOutlet UITextField *txtGender;
@property(nonatomic,strong) IBOutlet UIButton *delBtn;
@property(nonatomic,strong) UIPickerView *myPicker;
@property(nonatomic,strong) ItemPicker *picker;
@property(nonatomic,strong) IBOutlet UIView *pickerToolView;
@property(nonatomic,strong) IBOutlet UICollectionView *designsCV;
@property(nonatomic,strong) DesignCollection *designCollection;

@end

