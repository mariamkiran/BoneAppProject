//
//  PaintViewController.h
//  Paint
//
//  Created by admin on 2/15/15.
//  Copyright (c) 2015 Innovazor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PainterView.h"
#import <AVFoundation/AVFoundation.h> 
#import <AssetsLibrary/AssetsLibrary.h>
#import <MessageUI/MessageUI.h>

@interface PaintViewController : UIViewController<AVAudioRecorderDelegate, AVAudioPlayerDelegate,MFMailComposeViewControllerDelegate>
{
    BOOL mailSent;
}

@property (strong, nonatomic) AVAudioRecorder *audioRecorder;

@property(nonatomic,strong)IBOutlet UIView *highLighter;
@property(nonatomic,strong)IBOutlet UIButton *btnPen;
@property(nonatomic,strong)IBOutlet UIButton *btnColor;
@property(nonatomic,strong)IBOutlet UIButton *btnRubber;
@property(nonatomic,strong)IBOutlet UIButton *btnPaint;
@property(nonatomic,strong)IBOutlet UIButton *btnClear;
@property(nonatomic,strong)IBOutlet UIView *colorView;
@property(nonatomic,strong) NSMutableArray *colorPallet;
@property(nonatomic,strong) NSNumber *designId;
@property(nonatomic,strong) NSString *designerName;
@property(nonatomic,strong) NSString *designerAge;
@property(nonatomic,strong) NSString *designerGender;
@property(nonatomic,strong) NSString *designTime;
@property(nonatomic,strong)IBOutlet UILabel *lblName;
@end
