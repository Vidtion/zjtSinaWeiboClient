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
@synthesize theTextView;

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
    UIImage *image = theImageView.image;
    if (content != nil && [content length] != 0) {
        if (!_shouldPostImage) {
            [manager postWithText:content];
        }
        else {
            [manager postWithText:content image:image];
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

- (void)dealloc {
    [theScrollView release];
    [theImageView release];
    [theTextView release];
    [TVBackView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *retwitterBtn = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send:)];
    self.navigationItem.rightBarButtonItem = retwitterBtn;
    [retwitterBtn release];
    
    theScrollView.contentSize = CGSizeMake(320, 410);
    
    TVBackView.image = [[UIImage imageNamed:@"input_window.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:15];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPost:) name:MMSinaGotPostResult object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [theTextView becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated 
{
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPost:) name:MMSinaGotPostResult object:nil];
    [self setTheScrollView:nil];
    [self setTheImageView:nil];
    [self setTheTextView:nil];
    [self setTVBackView:nil];
    [super viewDidUnload];
}

-(void)didPost:(NSNotification*)sender
{
    Status *sts = sender.object;
    if (sts.text != nil && [sts.text length] != 0) {
        [self.navigationController popViewControllerAnimated:YES];
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


@end
