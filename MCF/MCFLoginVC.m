//
//  MCFLoginVC.m
//  MCF
//
//  Created by LiuMingchuan on 2016/12/18.
//  Copyright © 2016年 LiuMingchuan. All rights reserved.
//

#import "MCFLoginVC.h"
#import <Masonry.h>
#import <MBProgressHUD.h>
#import <AFNetworking.h>
#import "MCFRegistVC.h"
#import "MCFMainVC.h"



@interface MCFLoginVC ()<MBProgressHUDDelegate> {
    UITextField *nick_name;
    UITextField *password;
    UIButton *loginBtn;
    UILabel *jumpToRegistLbl;
    
    MBProgressHUD *HUD;
}

@end

@implementation MCFLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //------昵称
    nick_name = ({UITextField *tf = [[UITextField alloc]init];
        [tf setPlaceholder:@"昵称/邮箱/手机号"];
        UIView *leftV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        tf.leftViewMode = UITextFieldViewModeAlways;
        [tf setLeftView:leftV];
        tf;});
    [self.view addSubview:nick_name];
    [nick_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(30);
        make.right.mas_equalTo(self.view).offset(-30);
        make.centerY.mas_equalTo(self.view).offset(-50);
    }];
    UIView *line1 = [[UIView alloc]init];
    [line1 setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(1);
        make.left.mas_equalTo(nick_name);
        make.width.mas_equalTo(nick_name);
        make.top.mas_equalTo(nick_name.mas_bottom).offset(0);
    }];
    //------密码
    password = ({UITextField *tf = [[UITextField alloc]init];
        tf.secureTextEntry = YES;
        [tf setPlaceholder:@"密码"];
        UIView *leftV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        tf.leftViewMode = UITextFieldViewModeAlways;
        [tf setLeftView:leftV];
        tf;});
    [self.view addSubview:password];
    [password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(30);
        make.right.mas_equalTo(self.view).offset(-30);
        make.top.mas_equalTo(nick_name.mas_bottom).offset(20);
    }];
    UIView *line2 = [[UIView alloc]init];
    [line2 setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(1);
        make.left.mas_equalTo(password);
        make.width.mas_equalTo(password);
        make.top.mas_equalTo(password.mas_bottom).offset(0);
    }];
    //------登录按钮
    loginBtn = ({UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:@"登录" forState:UIControlStateNormal];
        btn.layer.cornerRadius = 10;
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn.layer.borderWidth = 1;
        [btn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
        btn;});
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(80);
        make.right.mas_equalTo(self.view).offset(-80);
        make.top.mas_equalTo(password.mas_bottom).offset(30);
    }];
    //------跳转到注册
    jumpToRegistLbl = ({UILabel *lbl = [[UILabel alloc]init];
        lbl.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToRegistAction)];
        tapGesture.numberOfTapsRequired = 1;
        [lbl addGestureRecognizer:tapGesture];
        [lbl setFont:[UIFont systemFontOfSize:12]];
        [lbl setAttributedText:({NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:@"没有账户，去注册"];
            [content addAttributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:[UIColor blueColor]} range:NSMakeRange(6, 2)];
            content;})];
        lbl;});
    [self.view addSubview:jumpToRegistLbl];
    [jumpToRegistLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(loginBtn.mas_bottom).offset(30);
    }];
}

/**
 登录事件
 */
- (void)loginBtnAction {
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    if (![self checkRequired:@[nick_name,password]]) {
        HUD.mode = MBProgressHUDModeText;
        [HUD.label setText:@"必须输入项目"];
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUD hideAnimated:YES];
            });
        });
        return;
    }
    [HUD.label setText:@"正在登录"];
    HUD.mode = MBProgressHUDModeIndeterminate;
    AFHTTPSessionManager *afn = [AFHTTPSessionManager manager];
    afn.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [afn POST:@"http://mcf.co.jp/user/login" parameters:@{@"nick_name":nick_name.text,@"password":password.text} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HUD.mode = MBProgressHUDModeText;
        [HUD.label setText:[responseObject objectForKey:@"msg"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            sleep(1);
            [HUD hideAnimated:YES];
        });
        NSString *subCode = [responseObject objectForKey:@"subCode"];
        if ([@201  isEqual: subCode]) {
            //登录成功
            MCFMainVC *mainVC = [[MCFMainVC alloc]init];
            UINavigationController *rootVC = [[UINavigationController alloc]initWithRootViewController:mainVC];
            [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
            [self.navigationController pushViewController:rootVC animated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"err:%@",error);
    }];
    
    
}


/**
 跳转到注册
 */
- (void)jumpToRegistAction {
    MCFRegistVC *regVC = [[MCFRegistVC alloc]init];
    [self presentViewController:regVC animated:YES completion:^{
        
    }];
}

/**
 HUD代理
 
 @param hud HUD
 */
-(void)hudWasHidden:(MBProgressHUD *)hud {
    [hud removeFromSuperview];
    hud = nil;
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
