//
//  TwitterVC.h
//  zjtSinaWeiboClient
//
//  Created by Zhu Jianting on 12-3-14.
//  Copyright (c) 2012年 WS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterVC : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView *imageV;
}
@property (retain, nonatomic) IBOutlet UIImageView *imageV;

@end
