//
//  ViewController.m
//  BATouchID
//
//  Created by boai on 2017/5/24.
//  Copyright © 2017年 boai. All rights reserved.
//

#import "ViewController.h"

#import "TouchIDLoginVC.h"

#import "LoginViewController.h"

static NSString * const kIsLogin = @"kIsLogin";
static NSString * const kIsOpenTouchID = @"kIsOpenTouchID";

@interface ViewController ()

@property(nonatomic, strong) UIButton *loginButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupUI];
}

- (void)setupUI
{
    self.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];
    self.loginButton.hidden = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录界面" style:UIBarButtonItemStylePlain target:self action:@selector(handleNaviAction)];
}

- (void)handleNaviAction
{
    [self.navigationController pushViewController:[LoginViewController new] animated:YES];
}

- (void)handleButtonAction:(UIButton *)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id isLogin = [defaults objectForKey:kIsLogin];
    id isShow = [defaults objectForKey:kIsOpenTouchID];
    
    if ([isLogin intValue] == 1 && [isShow intValue] == 1)
    {
        [self presentViewController:[TouchIDLoginVC new] animated:YES completion:nil];
    }
    else
    {
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _loginButton.frame = CGRectMake(0, 0, 150, 200);
    _loginButton.center = self.view.center;
}

- (UIButton *)loginButton
{
    if (!_loginButton)
    {
        _loginButton = [[UIButton alloc] init];
        [_loginButton setTitle:@"点击进行登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor colorWithRed:0 green:152/255.0 blue:229/255.0 alpha:1.0f] forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(handleButtonAction:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:_loginButton];
    }
    return _loginButton;
}

@end
