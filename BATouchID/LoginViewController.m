//
//  LoginViewController.m
//  BATouchID
//
//  Created by boai on 2017/5/25.
//  Copyright © 2017年 boai. All rights reserved.
//

#import "LoginViewController.h"

#import "TouchIDLoginVC.h"
#import "NSString+BAKit.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "BATouchID.h"

static NSString * const kIsLogin = @"kIsLogin";
static NSString * const kIsOpenTouchID = @"kIsOpenTouchID";

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UIView *touchIDView;

@property (weak, nonatomic) IBOutlet UISwitch *switchButton;


- (IBAction)handleButtonAction:(UIButton *)sender;
- (IBAction)handleSwithcAction:(UISwitch *)sender;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}


- (void)setupUI
{
    self.title = @"登 录";
    self.touchIDView.hidden = NO;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id isLogin = [defaults objectForKey:kIsLogin];
    id isShow = [defaults objectForKey:kIsOpenTouchID];
    
    if ([isShow intValue] == 0)
    {
        self.switchButton.on = NO;
    }
    else
    {
        self.switchButton.on = YES;
    }
    if ([isLogin intValue] == 1)
    {
        [self.loginButton setTitle:@"已登录" forState:UIControlStateNormal];
        
        if ([isShow intValue] != 0)
        {
            [self presentViewController:[TouchIDLoginVC new] animated:YES completion:nil];
        }
    }
    
}

- (IBAction)handleButtonAction:(UIButton *)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id isLogin = [defaults objectForKey:kIsLogin];
    if ([isLogin intValue] == 0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kIsLogin];
        BAKit_ShowAlertWithMsg_ios8(@"登录成功！");
        [self.loginButton setTitle:@"已登录" forState:UIControlStateNormal];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self test];
        });
    }
    else
    {
        BAKit_ShowAlertWithMsg_ios8(@"您已经登录过！");

    }
}

- (IBAction)handleSwithcAction:(UISwitch *)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id isLogin = [defaults objectForKey:kIsLogin];
//    id isShow = [defaults objectForKey:kIsOpenTouchID];
    if ([isLogin intValue] == 0)
    {
        BAKit_ShowAlertWithMsg_ios8(@"请您先登录后再开启指纹登录！");
        self.switchButton.on = NO;
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kIsOpenTouchID];
        if (sender.on)
        {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kIsOpenTouchID];
            self.switchButton.on = YES;
            [self presentViewController:[TouchIDLoginVC new] animated:YES completion:nil];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:kIsOpenTouchID];
            self.switchButton.on = NO;
        }
    }
}

- (void)test
{
    LAContext *context = [[LAContext alloc] init]; // 初始化上下文对象
    
    NSInteger policy;
    if (IOS_VERSION < 9.0 && IOS_VERSION >= 8.0)
    {
        policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    }
    else
    {
        policy = LAPolicyDeviceOwnerAuthentication;
    }
    
    NSError *error = nil;
    // 判断设备是否支持指纹识别功能
    if ([context canEvaluatePolicy:policy error:&error])
    {
        // 支持指纹验证
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录成功！" message:@"是否启用指纹登录" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"稍后" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击了稍后按钮！");
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        UIAlertAction *startUseAction = [UIAlertAction actionWithTitle:@"启用" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击了启用指纹按钮！");
            [self dismissViewControllerAnimated:YES completion:nil];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            id isShow = [defaults objectForKey:kIsOpenTouchID];
            if ([isShow intValue] == 0)
            {
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kIsOpenTouchID];
                self.switchButton.on = YES;
                [self presentViewController:[TouchIDLoginVC new] animated:YES completion:nil];
            }
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:startUseAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        BAKit_ShowAlertWithMsg_ios8(@"设备不支持 touch ID！");
    }
}


@end
