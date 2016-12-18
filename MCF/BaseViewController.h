//
//  BaseViewController.h
//  MCF
//
//  Created by LiuMingchuan on 2016/12/18.
//  Copyright © 2016年 LiuMingchuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (Boolean) checkRequired:(NSArray*)tfs;
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;
@end
