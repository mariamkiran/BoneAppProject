//
//  PaintViewController.m
//  Paint
//
//  Created by admin on 2/15/15.
//  Copyright (c) 2015 Innovazor. All rights reserved.
//

#import "PaintViewController.h"

@interface PaintViewController ()
{
    NSString *soundFilePath;
    NSString *imgFilePath;
}
@end

@implementation PaintViewController

@synthesize highLighter,
btnPen,
btnColor,
btnRubber,
btnPaint,
btnClear,
colorView,
colorPallet,
designId,
designerName,
lblName,
designTime,
designerAge,
designerGender;

@synthesize audioRecorder = _audioRecorder;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeVars];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)initializeVars
{
    [lblName setText:designerName];
    [self.colorView setHidden:YES];
    highLighter.layer.cornerRadius = 5;
    highLighter.layer.masksToBounds = true;
    self.colorPallet = [[NSMutableArray alloc] initWithObjects:@"red.png",@"green.png",@"yellow.png",@"gray.png",@"purple.png",@"black.png", nil];
    [self startRecording];
    mailSent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)back:(id)sender
{
    if (mailSent)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Do you want to mail your design?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"Discard", nil];
        [av show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self sendDesign];
    }
    else
    {
        if (_audioRecorder.recording)
        {
            [_audioRecorder stop];
        }
        AppDelegate *deleg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [deleg deleteDesign:designId];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(IBAction)penClicked:(id)sender
{
    [self highlighterPos:108];
    [((PainterView*)self.view) pen];
    if (self.colorView.frame.origin.x==84)
    {
        [self animateColorView];
    }
}

-(IBAction)colorClicked:(id)sender
{
    [self highlighterPos:187];
    [self animateColorView]; 
}

-(IBAction)nextColorClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [btnColor setImage:[UIImage imageNamed:[self.colorPallet objectAtIndex:btn.tag%100-1]] forState:UIControlStateNormal];
    
    NSNumber *colorCode = [NSNumber numberWithInteger:btn.tag];
    
    [((PainterView*)self.view) changeColor:colorCode];
    [self animateColorView];
}

-(IBAction)rubberClicked:(id)sender
{
    [self highlighterPos:350];
    [((PainterView*)self.view) erasePage];
    if (self.colorView.frame.origin.x==84)
    {
        [self animateColorView];
    }
}

-(IBAction)paintClicked:(id)sender
{
    [self highlighterPos:270];
    [((PainterView*)self.view) painter];
    if (self.colorView.frame.origin.x==84)
    {
        [self animateColorView];
    }
}

-(IBAction)clearClicked:(id)sender
{
    [self highlighterPos:428];
    [((PainterView*)self.view) clearPage];
    if (self.colorView.frame.origin.x==84)
    {
        [self animateColorView];
    }
}

-(IBAction)doneClicked:(id)sender
{
    if (self.colorView.frame.origin.x==84)
    {
        [self animateColorView];
    }
    [self sendDesign];
}

-(void)sendDesign
{
    mailSent = YES;
    imgFilePath = [((PainterView*)self.view) savePage:designId];
    
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    imgFilePath = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",imgFilePath]];
    
    [self stopRecording];
}

-(void)highlighterPos:(NSInteger)yPos
{
    highLighter.frame = CGRectMake(highLighter.frame.origin.x, yPos, highLighter.frame.size.width, highLighter.frame.size.height);
}

-(void)animateColorView
{
    [UIView beginAnimations:@"viewAnimation" context:nil];
    [UIView setAnimationDuration:.2];
    [UIView setAnimationDelegate:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.colorView cache:false];
    if (self.colorView.frame.origin.x==-500)
    {
        [self.colorView setHidden:NO];
        self.colorView.frame = CGRectMake(84, self.colorView.frame.origin.y, self.colorView.frame.size.width, self.colorView.frame.size.height);
    }
    else
    {
        self.colorView.frame = CGRectMake(-500, self.colorView.frame.origin.y, self.colorView.frame.size.width, self.colorView.frame.size.height);
        [self.colorView setHidden:YES];
    }
    [UIView commitAnimations];
}

-(void)startRecording
{
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    soundFilePath = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"sound%@.caf",designId]];
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16],
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2],
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0],
                                    AVSampleRateKey,
                                    nil];
    
    NSError *error = nil;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                        error:nil];
    
    _audioRecorder = [[AVAudioRecorder alloc]
                      initWithURL:soundFileURL
                      settings:recordSettings
                      error:&error];
    
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
    } else {
        [_audioRecorder prepareToRecord];
    }
    
    if (!_audioRecorder.recording)
    {
        [_audioRecorder record];
    }
}

-(void)stopRecording
{
    
    if (_audioRecorder.recording)
    {
        [_audioRecorder stop];
        [self showEmail];
    }
}

- (void)showEmail {
    
    NSString *emailTitle = [NSString stringWithFormat:@"%@: %@",designerName,designTime];
    NSString *messageBody = [NSString stringWithFormat:@"Designer Name:      %@\n",designerName];
    messageBody = [messageBody stringByAppendingString:[NSString stringWithFormat:@"Designer Age:          %@\n",designerAge]];
    messageBody = [messageBody stringByAppendingString:[NSString stringWithFormat:@"Designer Gender:    %@\n",designerGender]];
    messageBody = [messageBody stringByAppendingString:[NSString stringWithFormat:@"Design Time:            %@\n",designTime]];
    
    NSArray *toRecipents = [NSArray arrayWithObject:@"ignitenations77@gmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    if([MFMailComposeViewController canSendMail])
    {
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        NSData *fileData = [NSData dataWithContentsOfFile:soundFilePath];
        NSData *fileDataImg = [NSData dataWithContentsOfFile:imgFilePath];
        
        // Add attachment
        [mc addAttachmentData:fileData mimeType:@"audio/x-caf" fileName:@"Sound.caf"];
        [mc addAttachmentData:fileDataImg mimeType:@"image/png" fileName:@"Image.png"];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    }
    else
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Cannot send mail." message:@"Please add an account in iPhone Settings(Settings->Mail,Contacts,Calenders->Add Account) to enable mail function. " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [av show];
    }
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
