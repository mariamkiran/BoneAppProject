//
//  ViewController.m
//  Paint
//
//  Created by admin on 2/10/15.
//  Copyright (c) 2015 Innovazor. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize infoForm,
viewTitle,
txtName,
txtAge,
txtGender,
myPicker,
picker,
pickerToolView,
LblError,
Lblstar,
designsCV,
designCollection,
delBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeVars];
    [self showDesigns];
}

-(void)viewDidAppear:(BOOL)animated
{
    if (viewPushed) {
        [self showDesigns];
        viewPushed = false;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}

- (void)viewDidLayoutSubviews {
    if(keyboardUp || pickerUp)
        infoForm.frame=CGRectMake(infoForm.frame.origin.x,200, infoForm.frame.size.width, infoForm.frame.size.height);
}

- (void)keyboardWillShow:(NSNotification *)notification {
    keyboardUp = true;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    keyboardUp = false;
}

-(void)showDesigns
{
    designCollection = [[DesignCollection alloc] init];
    designsCV.dataSource = designCollection;
    designsCV.delegate = designCollection;
    
    AppDelegate *deleg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    designCollection.colView = designsCV;
    designCollection.items = [deleg fetchDesigns];
    if ([designCollection.items count]==0) {
        [self.viewTitle setText:@"Start a new design"];
        keyboardUp = true;
        [self animateForm];
    }
    else
        [self.viewTitle setText:@"Saved Designs"];
}

-(void)initializeVars
{ 
    keyboardUp = false;
    UIImage *image = [UIImage imageNamed:@"nav.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [delBtn setHidden:YES];
    [txtName setText:@""];
    [txtAge setText:@""];
    [txtGender setText:@""];
    [pickerToolView setHidden:YES];
    [LblError setText:@""];
    [Lblstar setText:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)addDesign:(id)sender
{
    [self animateForm];
}

-(IBAction)closeForm:(id)sender
{
    [self animateForm];
}

-(IBAction)selectAge:(id)sender
{
    [self refreshPicker];
    picterType = 0;
    keyboardUp = true;
    picker = [[ItemPicker alloc] init];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObject:@"Select Age"];
    for (int i=5; i<=100; i++) {
        
        [items addObject:[NSString stringWithFormat:@"%d",i]];
    }
    myPicker = [picker showPicker:items pickerFrame:CGRectMake(infoForm.frame.origin.x, infoForm.frame.origin.y+400, 500, 162) delegate:self];
    [pickerToolView setHidden:NO];
    
    [self.view addSubview:myPicker];
}

-(IBAction)selectGender:(id)sender
{
    [self refreshPicker];
    keyboardUp = true;
    picterType = 1;
    picker = [[ItemPicker alloc] init];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObject:@"Select Gender"];
    [items addObject:@"Male"];
    [items addObject:@"Female"];
    
    myPicker = [picker showPicker:items pickerFrame:CGRectMake(infoForm.frame.origin.x, infoForm.frame.origin.y+400, 500, 162) delegate:self];
    
    [pickerToolView setHidden:NO];
    [self.view addSubview:myPicker];
}

-(IBAction)hidePicker:(id)sender
{
    pickerUp = true;
    [self refreshPicker];
}

-(void)refreshPicker
{
    [txtName resignFirstResponder];
    [pickerToolView setHidden:YES];
    picker = nil;
    [myPicker removeFromSuperview];
    myPicker = nil;
}

-(IBAction)startDesigning:(id)sender
{
    if ([txtName.text isEqualToString:@""])
    {
        LblError.text = @"Please fill the required(*) fields";
        Lblstar.text =  @"*";
        return;
    }
    else if ([txtName.text integerValue])
    {
        LblError.text = @"Please enter the valid name";
        Lblstar.text =  @"*";
        return;
    }

    [LblError setText:@""];
    [Lblstar setText:@""];
    NSString *name = txtName.text;
    NSString *age = txtAge.text;
    NSString *gender = txtGender.text;
    [self animateForm];
    [txtName resignFirstResponder];
    
    AppDelegate *deleg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSNumber *designID = [deleg saveDesign:txtName.text :[txtAge.text integerValue] :[txtGender.text integerValue] :@""];
    txtName.text = @"";
    txtAge.text = @"";
    txtGender.text = @"";
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PaintViewController *vc = (PaintViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"PaintViewController"];
    vc.designId = designID;
    vc.designerName = name;
    vc.designerAge = age;
    vc.designerGender = gender;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mma"];
    NSString *theDate = [dateFormat stringFromDate:[NSDate date]];
    
    vc.designTime = theDate;
    [self.navigationController pushViewController:vc animated:YES];
    viewPushed = true;
}

-(IBAction)selectCVCells:(id)sender
{
    if ([designCollection.items count]==0) {
        return;
    }
    if (!delSelected) {
        [self.viewTitle setText:@"Select Designs to Delete"];
        delSelected = true;
        [delBtn setHidden:NO];
        [designCollection selectCells:YES];
    }
    else
    {
        [self.viewTitle setText:@"Saved Designs"];
        delSelected = false;
        [delBtn setHidden:YES];
        designCollection.delItems = nil;
        [designCollection selectCells:NO];
        [designCollection.colView reloadData];
    }
}

-(IBAction)deleteCVCells:(id)sender
{
    [self.viewTitle setText:@"Saved Designs"];
    delSelected = false;
    [delBtn setHidden:YES];
    AppDelegate *deleg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (NSMutableArray *ar in designCollection.delItems) {
        
        [deleg deleteDesign:[ar objectAtIndex:0]];
        [designCollection.items removeObject:ar];
    }
    designCollection.delItems = nil;
    [designCollection.colView reloadData];
}

-(void)pickerSelection:(NSString *)value
{
    if (picterType==0) {
        [txtAge setText:value];
    }
    else
    {
        [txtGender setText:value];
    }
}

-(void)animateForm
{
    [UIView beginAnimations:@"viewAnimation" context:nil];
    [UIView setAnimationDuration:.4];
    [UIView setAnimationDelegate:nil];
    if (infoForm.frame.origin.y==2000)
    {
        infoForm.frame=CGRectMake(infoForm.frame.origin.x,200, infoForm.frame.size.width, infoForm.frame.size.height);
    }
    else
    {
        infoForm.frame=CGRectMake(infoForm.frame.origin.x,2000, infoForm.frame.size.width, infoForm.frame.size.height);
    }
    [UIView commitAnimations];
}

//text field delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [LblError setText:@""];
    [Lblstar setText:@""];
}
 

@end
