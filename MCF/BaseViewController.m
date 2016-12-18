//
//  BaseViewController.m
//  MCF
//
//  Created by LiuMingchuan on 2016/12/18.
//  Copyright © 2016年 LiuMingchuan. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //调整因版本问题出现的导航遮挡视图
    if ([[UIDevice currentDevice]systemVersion].doubleValue>7.0) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        [self.navigationController.navigationBar setTranslucent:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 检查是否输入

 @param tfs 输入框
 @return 结果
 */
- (Boolean) checkRequired:(NSArray*)tfs {
    for (UITextField *tf in tfs) {
        if ([@"" isEqualToString:tf.text]) {
            [tf becomeFirstResponder];
            return false;
        }
    }
    return true;
}

/**
 改变图片尺寸
 
 @param image 图片
 @param reSize 尺寸
 @return 改变后的图片
 */
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [reSizeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
