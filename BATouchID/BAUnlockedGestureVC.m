//
//  BAUnlockedGestureVC.m
//  BATouchID
//
//  Created by boai on 2017/5/26.
//  Copyright © 2017年 boai. All rights reserved.
//

#import "BAUnlockedGestureVC.h"
#import "CLLockVC.h"

static NSString * const kCellID = @"BAUnlockedGestureVCCell";

@interface BAUnlockedGestureVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation BAUnlockedGestureVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self test];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI
{
    self.title = @"手势设置";
    self.tableView.tableFooterView = [UIView new];
    
}

- (void)test
{
    id isOpenUnlockedGesture = [kUserDefaults objectForKey:kIsOpenUnlockedGesture];
    
    [self.dataArray removeAllObjects];
    if ([isOpenUnlockedGesture intValue] == 1)
    {
        [_dataArray addObjectsFromArray:@[@"手势密码", @"验证手势密码", @"修改手势密码"]];
    }
    else if ([isOpenUnlockedGesture intValue] == 0 && _dataArray.count == 0)
    {
        [_dataArray addObject:@"手势密码"];
    }
    [self.tableView reloadData];
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
        
        id isOpenUnlockedGesture = [kUserDefaults objectForKey:kIsOpenUnlockedGesture];
        
        if ([cell.accessoryView isKindOfClass:[UISwitch class]])
        {
            switcher = (UISwitch *)cell.accessoryView;
        }
        else
        {
            switcher = [[UISwitch alloc] init];
        }
        switcher.tag = indexPath.row;
        switcher.on = ([isOpenUnlockedGesture intValue] == 1) ? YES : NO;
        
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
        [self ba_verifyPwd];
    }
    if (indexPath.row == 2)
    {
        [self ba_modifyPwd];
    }
}

#pragma mark - custom method
- (void)handleSwichAction:(UISwitch *)sender
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kIsOpenUnlockedGesture];
    if (sender.on)
    {
        [self openUnlockedGesture];
    }
    else
    {
        [kUserDefaults setObject:[NSNumber numberWithBool:NO] forKey:kIsOpenUnlockedGesture];
        sender.on = NO;
        [CLLockVC ba_setPwdRemove];
    }
    [self test];
}

- (void)openUnlockedGesture
{
    [UIAlertController ba_alertControllerShowAlertInViewController:self withTitle:nil mutableAttributedTitle:nil message:@"继续开启手势解锁\n将关闭指纹解锁" mutableAttributedMessage:nil buttonTitlesArray:@[@"取 消", @"继 续"] buttonTitleColorArray:@[[UIColor greenColor], [UIColor redColor]] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1)
        {
            [kUserDefaults removeObjectForKey:kIsOpenTouchID];
            [kUserDefaults setObject:[NSNumber numberWithBool:NO] forKey:kIsOpenTouchID];
            [self ba_setupPwd];
        }
        
        return;
    }];
}

#pragma mark 设置手势密码
- (void)ba_setupPwd
{
    BOOL hasPwd = [CLLockVC hasPwd];
    hasPwd = NO;
    if(hasPwd)
    {
        NSLog(@"已经设置过密码了，你可以验证或者修改密码");
    }
    else
    {
        [CLLockVC showSettingLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            NSLog(@"密码设置成功");
            [lockVC dismiss:0.5f];
            
            [kUserDefaults setObject:[NSNumber numberWithBool:YES] forKey:kIsOpenUnlockedGesture];
        }];
    }
}

- (void)ba_modifyPwd
{
    BOOL hasPwd = [CLLockVC hasPwd];
    if(!hasPwd)
    {
        NSLog(@"你还没有设置密码，请先设置密码");
    }
    else
    {
        [CLLockVC showModifyLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            [lockVC dismiss:0.5f];
        }];
    }
}

- (void)ba_verifyPwd
{
    BOOL hasPwd = [CLLockVC hasPwd];
    if(!hasPwd){
        NSLog(@"你还没有设置密码，请先设置密码");
    }
    else
    {
        [CLLockVC showVerifyLockVCInVC:self forgetPwdBlock:^{
            NSLog(@"忘记密码");
        } successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            NSLog(@"密码正确");
            [lockVC dismiss:0.5f];
        }];
    }
}

#pragma mark - setter / getter

- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = @[].mutableCopy;
        
    }
    return _dataArray;
}


@end
