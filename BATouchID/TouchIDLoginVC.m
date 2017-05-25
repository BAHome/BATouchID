//
//  TouchIDLoginVC.m
//  BATouchID
//
//  Created by boai on 2017/5/24.
//  Copyright © 2017年 boai. All rights reserved.
//

#import "TouchIDLoginVC.h"
#import "BATouchID.h"
#import "BAButton.h"

@interface TouchIDLoginVC ()

@property(nonatomic, strong) UIButton *touchIDButton;

@end

@implementation TouchIDLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)setupUI
{
    self.touchIDButton.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self test];
}

- (void)handleButtonAction:(UIButton *)sender
{
    [self test];
}

- (void)test
{
    [BAKit_TouchID ba_touchIDWithContent:@"此操作需要认证您的身份" cancelButtonTitle:nil otherButtonTitle:nil enabled:YES BAKit_TouchIDTypeBlock:^(BAKit_TouchIDType touchIDType, NSError *error, NSString *errorMessage) {
        
        if (errorMessage && touchIDType != BAKit_TouchIDTypeTouchIDLockout && touchIDType != BAKit_TouchIDTypeInputPassword)
        {
            NSString *msg = errorMessage;
            BAKit_ShowAlertWithMsg_ios8(msg);
        }
        
        if (touchIDType == BAKit_TouchIDTypeSuccess)
        {
            BAKit_ShowAlertWithMsg(@"指纹登录成功！");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        if (touchIDType == BAKit_TouchIDTypeInputPassword)
        {
            [self dismissViewControllerAnimated:YES completion:^{
                NSLog(@"请跳转到自己的密码登录界面，如：手势解锁等！");
            }];
        }
        
    }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _touchIDButton.frame = CGRectMake(0, 0, 150, 200);
    _touchIDButton.center = self.view.center;
}

- (UIButton *)touchIDButton
{
    if (!_touchIDButton)
    {
        _touchIDButton = [[UIButton alloc] init];
        [_touchIDButton setImage:[UIImage imageNamed:@"touchID"] forState:UIControlStateNormal];
        [_touchIDButton setTitle:@"点击进行指纹解锁" forState:UIControlStateNormal];
        [_touchIDButton setTitleColor:[UIColor colorWithRed:0 green:152/255.0 blue:229/255.0 alpha:1.0f] forState:UIControlStateNormal];
        [_touchIDButton addTarget:self action:@selector(handleButtonAction:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:_touchIDButton];
        
        [_touchIDButton ba_button_setBAButtonLayoutType:BAButtonLayoutTypeCenterImageTop padding:25];
    }
    return _touchIDButton;
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
