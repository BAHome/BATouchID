//
//  LoginViewController.m
//  BATouchID
//
//  Created by boai on 2017/5/25.
//  Copyright © 2017年 boai. All rights reserved.
//

#import "LoginViewController.h"

#import "BATouchIDLoginVC.h"
#import "NSString+BAKit.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "BATouchID.h"

#import "SettingVC.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)handleButtonAction:(UIButton *)sender;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI
{
    [self checkIsAlreadyOpenTouchID];

    self.title = @"登 录";

}

- (void)checkIsAlreadyOpenTouchID
{
    id isLogin = [kUserDefaults objectForKey:kIsLogin];
    id isOpenTouchID = [kUserDefaults objectForKey:kIsOpenTouchID];
    
    if ([isLogin intValue] == 1)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(handleNaviAction)];

        [self.loginButton setTitle:@"已登录" forState:UIControlStateNormal];
        
        if ([isOpenTouchID intValue] == 1)
        {
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:[BATouchIDLoginVC new]];
            [self presentViewController:navi animated:YES completion:nil];
        }
    }
}

- (void)handleNaviAction
{
    [self.navigationController pushViewController:[SettingVC new] animated:YES];
}

- (IBAction)handleButtonAction:(UIButton *)sender
{
    NSUserDefaults *defaults = kUserDefaults;
    id isLogin = [defaults objectForKey:kIsLogin];
    if ([isLogin intValue] == 0)
    {
        [kUserDefaults setObject:[NSNumber numberWithBool:YES] forKey:kIsLogin];
        BAKit_ShowAlertWithMsg_ios8(@"登录成功！");
        [self.loginButton setTitle:@"已登录" forState:UIControlStateNormal];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self checkIsSupportTouchID];
        });
    }
    else
    {
        BAKit_ShowAlertWithMsg_ios8(@"您已经登录过！");
    }
}

- (void)checkIsSupportTouchID
{
    [UIAlertController ba_alertControllerShowAlertInViewController:self withTitle:@"登录成功！" mutableAttributedTitle:nil message:@"是否设置指纹登录或者手势登录？" mutableAttributedMessage:nil buttonTitlesArray:@[@"取 消", @"确 定"] buttonTitleColorArray:@[[UIColor greenColor], [UIColor redColor]] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1)
        {
            [self.navigationController pushViewController:[SettingVC new] animated:YES];
        }
        else
        {
            return ;
        }
        
        return;
    }];
}

@end
