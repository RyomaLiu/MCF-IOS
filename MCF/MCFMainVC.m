//
//  MCFMainVC.m
//  MCF
//
//  Created by LiuMingchuan on 2016/12/18.
//  Copyright © 2016年 LiuMingchuan. All rights reserved.
//

#import "MCFMainVC.h"

@interface MCFMainVC ()

@end

@implementation MCFMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"MCF"];
    UIImage *icon;
    NSString *iconUrl = [[NSUserDefaults standardUserDefaults]objectForKey:@"ICON_URL"];
    if (!iconUrl || [@"" isEqualToString:iconUrl]) {
        icon = [UIImage imageNamed:@"icon"];
    } else {
        icon = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:iconUrl]]];
    }
    self.navigationItem.leftBarButtonItem = ({UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[self reSizeImage:icon toSize:CGSizeMake(30, 30)] style:UIBarButtonItemStylePlain target:self action:nil];
        item;
    });
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
