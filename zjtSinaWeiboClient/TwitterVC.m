//
//  TwitterVC.m
//  zjtSinaWeiboClient
//
//  Created by Zhu Jianting on 12-3-14.
//  Copyright (c) 2012年 WS. All rights reserved.
//

#import "TwitterVC.h"
#import "WeiBoMessageManager.h"
#import "Status.h"

@interface TwitterVC ()

@end

@implementation TwitterVC

@synthesize theScrollView;
@synthesize theImageView;
@synthesize TVBackView;
@synthesize countLabel;
@synthesize theTextView;
@synthesize mainView;
@synthesize locationButton;
@synthesize topicButton;
@synthesize photoButton;
@synthesize atButton;
@synthesize weiboID;
@synthesize commentID;

#pragma mark - Tool Methods
- (void)addPhoto
{
    UIImagePickerController * imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.navigationBar.tintColor = [UIColor colorWithRed:72.0/255.0 green:106.0/255.0 blue:154.0/255.0 alpha:1.0];
	imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	imagePickerController.delegate = self;
	imagePickerController.allowsEditing = NO;
	[self presentModalViewController:imagePickerController animated:YES];
	[imagePickerController release];
}

- (void)takePhoto
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                        message:@"该设备不支持拍照功能" 
                                                       delegate:nil 
                                              cancelButtonTitle:nil 
                                              otherButtonTitles:@"好", nil];
        [alert show];
        [alert release];
    }
    else
    {
        UIImagePickerController * imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = NO;
        [self presentModalViewController:imagePickerController animated:YES];
        [imagePickerController release];
    }
}

-(IBAction)addImageAlert
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"插入图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"系统相册",@"拍摄", nil];
    [alert show];
    [alert release];
}

- (void)send:(id)sender 
{
    NSString *content = theTextView.text;
    
    if (_isForComment) {
        [manager replyACommentWeiboId:weiboID commentID:commentID content:content];
    }
    else if (_isForReply) {
        
    }
    else if (_isForRepost) {
        [manager repost:weiboID content:content withComment:NO];
    }
    else 
    {
        UIImage *image = theImageView.image;
        if (content != nil && [content length] != 0)
        {
            if (!_shouldPostImage) {
                [manager postWithText:content];
            }
            else {
                [manager postWithText:content image:image];
            }
        }
    }
}

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _shouldPostImage = NO;
        manager = [WeiBoMessageManager getInstance];
    }
    return self;
}

- (IBAction)atButtonClicked:(id)sender {
    AtTableViewController *at = [[AtTableViewController alloc] initWithStyle:UITableViewStylePlain];
    at.delegate = self;
    [self.navigationController pushViewController:at animated:YES];
    [at release];
}

-(void)setupForReply
{
    locationButton.hidden = YES;
    photoButton.hidden = YES;
    theImageView.hidden = YES;
    _isForReply = YES;
}

-(void)setupForComment:(NSString*)comID weiboID:(NSString*)wbID
{
    locationButton.hidden = YES;
    photoButton.hidden = YES;
    theImageView.hidden = YES;
    _isForComment = YES;
    self.commentID = comID;
    self.weiboID = wbID;
}

-(void)setupForRepost:(NSString*)wbID
{
    locationButton.hidden = YES;
    photoButton.hidden = YES;
    theImageView.hidden = YES;
    _isForRepost = YES;
    self.weiboID = wbID;
}

- (void)dealloc {
    [commentID release];
    [weiboID release];
    [theScrollView release];
    [theImageView release];
    [theTextView release];
    [TVBackView release];
    [mainView release];
    [countLabel release];
    [locationButton release];
    [topicButton release];
    [photoButton release];
    [atButton release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *retwitterBtn = [[UIBarButtonItem alloc]initWithTitle:@"发送" 
                                                                    style:UIBarButtonItemStylePlain 
                                                                   target:self 
                                                                   action:@selector(send:)];
    self.navigationItem.rightBarButtonItem = retwitterBtn;
    [retwitterBtn release];
    
    theScrollView.contentSize = CGSizeMake(320, 410);
    theTextView.delegate = self;
    TVBackView.image = [[UIImage imageNamed:@"input_window.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:15];
    
    [manager getMetionsStatuses];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [theTextView becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPost:) name:MMSinaGotPostResult object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPost:) name:MMSinaGotRepost object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didComment:) name:MMSinaReplyAComment object:nil];
    
    // 键盘高度变化通知，ios5.0新增的  
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif
}

-(void)viewWillDisappear:(BOOL)animated 
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [self setTheScrollView:nil];
    [self setTheImageView:nil];
    [self setTheTextView:nil];
    [self setTVBackView:nil];
    [self setMainView:nil];
    [self setCountLabel:nil];
    [self setLocationButton:nil];
    [self setTopicButton:nil];
    [self setPhotoButton:nil];
    [self setAtButton:nil];
    [super viewDidUnload];
}

- (IBAction)getLocations:(id)sender {
    POIViewController *pVC = [[POIViewController alloc] initWithNibName:@"POIViewController" bundle:nil];
    pVC.hidesBottomBarWhenPushed = YES;
    pVC.delegate = self;
    [self.navigationController pushViewController:pVC animated:YES];
    [pVC release];
}
#pragma mark -

#pragma mark Responding to keyboard events

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
//    [self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if (keyboardRect.size.height == 252) 
    {
        CGRect frame = mainView.frame;
        frame.size.height = 165;
        mainView.frame = frame;
    }
    else if(keyboardRect.size.height == 216)
    {
        CGRect frame = mainView.frame;
        frame.size.height = 165 + 36;
        mainView.frame = frame;
    }
    [UIView commitAnimations];
}





- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    
    [animationDurationValue getValue:&animationDuration];
    
}

-(void)didPost:(NSNotification*)sender
{
    Status *sts = sender.object;
    if (sts.text != nil && [sts.text length] != 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(void)didComment:(NSNotification*)sender
{
    NSNumber *num = sender.object;
    if (num.boolValue == YES) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"评论失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    UIImage * image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    self.theImageView.image = image;
    _shouldPostImage = YES;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"index = %d",buttonIndex);
    if (buttonIndex == 1) 
    {
        [self addPhoto];
    }
    else if(buttonIndex == 2)
    {
        [self takePhoto];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    return YES;
}
//- (BOOL)textViewShouldEndEditing:(UITextView *)textView;

//- (void)textViewDidBeginEditing:(UITextView *)textView;
//- (void)textViewDidEndEditing:(UITextView *)textView;

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)textViewDidChange:(UITextView *)textView
{
    NSString *temp = textView.text;
    if (temp.length != 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    if (temp.length > 140) {  
        textView.text = [temp substringToIndex:140];  
    }  
    countLabel.text = [NSString stringWithFormat:@"%d",140 - theTextView.text.length];
}

//- (void)textViewDidChangeSelection:(UITextView *)textView;


-(void)poisCellDidSelected:(POI *)poi
{
    theTextView.text = [theTextView.text stringByAppendingFormat:@"我在这里：#%@#",poi.title];
}

-(void)atTableViewControllerCellDidClickedWithScreenName:(NSString*)name
{
    theTextView.text = [theTextView.text stringByAppendingFormat:@"@%@",name];
}

@end
