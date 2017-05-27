//
//  NSString+BAKit.m
//  BATouchID
//
//  Created by boai on 2017/5/25.
//  Copyright © 2017年 boai. All rights reserved.
//

#import "NSString+BAKit.h"

@implementation NSString (BAKit)

#pragma mark 判断两个时间差
+ (NSString *)ba_intervalSinceNow:(NSDate *)theDate
{
    NSTimeInterval late = [theDate timeIntervalSince1970]*1;
    
    NSDate *dat = [NSDate date];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    
    
    NSTimeInterval cha = now -late;
    NSString *timeString=[NSString stringWithFormat:@"%f",cha];
    
    return timeString;
}

@end
