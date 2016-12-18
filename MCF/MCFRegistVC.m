//
//  MCFRegistVC.m
//  MCF
//
//  Created by LiuMingchuan on 2016/12/18.
//  Copyright © 2016年 LiuMingchuan. All rights reserved.
//

#import "MCFRegistVC.h"
#import <Masonry.h>
#import <AFNetworking.h>
#import <MBProgressHUD.h>
#import "MCFMainVC.h"

@interface MCFRegistVC ()<MBProgressHUDDelegate> {
    
    UITextField *nick_name;
    UITextField *password;
    UITextField *passwordConfirm;
    UIButton *registBtn;
    UILabel *backItem;
    
    MBProgressHUD *HUD;

}

@end

@implementation MCFRegistVC

- (void)viewDidLoad {
    [super viewDidLoad];

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
        make.centerY.mas_equalTo(self.view).offset(-100);
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
    //------密码确认
    passwordConfirm = ({UITextField *tf = [[UITextField alloc]init];
        tf.secureTextEntry = YES;
        [tf setPlaceholder:@"密码确认"];
        UIView *leftV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        tf.leftViewMode = UITextFieldViewModeAlways;
        [tf setLeftView:leftV];
        tf;});
    [self.view addSubview:passwordConfirm];
    [passwordConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(30);
        make.right.mas_equalTo(self.view).offset(-30);
        make.top.mas_equalTo(password.mas_bottom).offset(20);
    }];
    UIView *line3 = [[UIView alloc]init];
    [line3 setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(1);
        make.left.mas_equalTo(password);
        make.width.mas_equalTo(password);
        make.top.mas_equalTo(passwordConfirm.mas_bottom).offset(0);
    }];
    //------注册按钮
    registBtn = ({UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:@"注册" forState:UIControlStateNormal];
        btn.layer.cornerRadius = 10;
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn.layer.borderWidth = 1;
        [btn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
        btn;});
    [self.view addSubview:registBtn];
    [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(80);
        make.right.mas_equalTo(self.view).offset(-80);
        make.top.mas_equalTo(passwordConfirm.mas_bottom).offset(30);
    }];
    //------跳转到登录
    backItem = ({UILabel *lbl = [[UILabel alloc]init];
        lbl.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backItemAction)];
        tapGesture.numberOfTapsRequired = 1;
        [lbl addGestureRecognizer:tapGesture];
        [lbl setFont:[UIFont systemFontOfSize:12]];
        [lbl setAttributedText:({NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:@"返回到登录"];
            [content addAttributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:[UIColor blueColor]} range:NSMakeRange(3, 2)];
            content;})];
        lbl;});
    [self.view addSubview:backItem];
    [backItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(registBtn.mas_bottom).offset(30);
    }];


    // Do any additional setup after loading the view from its nib.
}

- (void)backItemAction {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

/**
 注册事件
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
    if(![passwordConfirm.text isEqualToString:password.text]){
        HUD.mode = MBProgressHUDModeText;
        [HUD.label setText:@"密码不一致"];
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUD hideAnimated:YES];
            });
        });
        return;
    }
    [HUD.label setText:@"正在注册"];
    HUD.mode = MBProgressHUDModeIndeterminate;
    AFHTTPSessionManager *afn = [AFHTTPSessionManager manager];
    afn.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [afn POST:@"http://mcf.co.jp/user/reg" parameters:@{@"nick_name":nick_name.text,@"password":password.text} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HUD.mode = MBProgressHUDModeText;
        [HUD.label setText:[responseObject objectForKey:@"msg"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            sleep(1);
            [HUD hideAnimated:YES];
        });
        NSString *subCode = [responseObject objectForKey:@"subCode"];
        if ([@201 isEqual:subCode]) {
            //注册成功
            MCFMainVC *mainVC = [[MCFMainVC alloc]init];
            [UIApplication sharedApplication].keyWindow.rootViewController = mainVC;
            [self.navigationController pushViewController:mainVC animated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"err:%@",error);
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
