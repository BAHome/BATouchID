//
//  SettingVC.m
//  BATouchID
//
//  Created by boai on 2017/5/26.
//  Copyright © 2017年 boai. All rights reserved.
//

#import "SettingVC.h"
#import "BATouchID.h"

#import "BATouchIDLoginVC.h"
#import "BAUnlockedGestureVC.h"

static NSString * const kCellID = @"SettingVCCell";

@interface SettingVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSArray *dataArray;

@end

@implementation SettingVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 手势密码打开之后, 指纹密码失效, 应该在手势设置页面 pop 回当前页的时候刷新一下, 让指纹登录的开关关掉.
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

- (void)setupUI
{
    self.title = @"安全设置";
    self.tableView.tableFooterView = [UIView new];

}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellID];
    }
    if (indexPath.row == 0)
    {
        UISwitch *switcher;
        
        id switcher1On = [kUserDefaults objectForKey:kIsOpenTouchID];
        
        if ([cell.accessoryView isKindOfClass:[UISwitch class]])
        {
            switcher = (UISwitch *)cell.accessoryView;
        }
        else
        {
            switcher = [[UISwitch alloc] init];
        }
        switcher.tag = indexPath.row;
        switcher.on = ([switcher1On intValue] == 1) ? YES : NO;
        
        [switcher removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        [switcher addTarget:self action:@selector(handleSwichAction:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switcher;
    }

    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1)
    {
        [self.navigationController pushViewController:[BAUnlockedGestureVC new] animated:YES];
    }
}

#pragma mark - custom method
- (void)handleSwichAction:(UISwitch *)sender
{
    id isLogin = [kUserDefaults objectForKey:kIsLogin];
    if ([isLogin intValue] == 0)
    {
        NSString *msg = @"请您先登录后再开启指纹登录！";
        BAKit_ShowAlertWithMsg_ios8(msg);
        sender.on = NO;
    }
    else
    {
        if (sender.tag == 0)
        {
            // 开启和关闭指纹解锁的弹框信息区分开
            NSString *msg = sender.isOn ? @"继续开启指纹解锁\n将关闭手势解锁" : @"关闭指纹解锁?";
            [UIAlertController ba_alertControllerShowAlertInViewController:self withTitle:nil mutableAttributedTitle:nil message:msg mutableAttributedMessage:nil buttonTitlesArray:@[@"取 消", @"继 续"] buttonTitleColorArray:@[[UIColor greenColor], [UIColor redColor]] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
                if (buttonIndex == 1)
                {
                    [kUserDefaults removeObjectForKey:kIsOpenUnlockedGesture];
                    [kUserDefaults setObject:[NSNumber numberWithBool:NO] forKey:kIsOpenUnlockedGesture];
                    
                    [kUserDefaults removeObjectForKey:kIsOpenTouchID];
                    if (sender.on)
                    {
                        [self checkIsSupportTouchID];
                    }
                    else
                    {
                        [kUserDefaults setObject:[NSNumber numberWithBool:NO] forKey:kIsOpenTouchID];
                        sender.on = NO;
                    }
                }
                else // 弹框的取消按钮点击之后, 开关状态不应改变, 把状态切换回去.
                {
                    sender.on = !sender.isOn;
                }
                return;
            }];
        }
    }
}

- (void)checkIsSupportTouchID
{
    [BAKit_TouchID ba_touchIDVerifyIsSupportWithBlock:^(BOOL isSupport, LAContext *context, NSInteger policy, NSError *error) {
        if (isSupport)
        {
            id isShow = [kUserDefaults objectForKey:kIsOpenTouchID];
            if ([isShow intValue] == 0)
            {
                [kUserDefaults setObject:[NSNumber numberWithBool:YES] forKey:kIsOpenTouchID];
                [self presentViewController:[BATouchIDLoginVC new] animated:YES completion:nil];
            }
        }
        else
        {
            BAKit_ShowAlertWithMsg_ios8(@"设备不支持 touch ID！");
        }
    }];
}

#pragma mark - setter / getter

- (NSArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = @[@"指纹登录", @"手势登录"];
    }
    return _dataArray;
}


@end
