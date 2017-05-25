//
//  NSString+BAKit.h
//  BATouchID
//
//  Created by boai on 2017/5/25.
//  Copyright © 2017年 boai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BAKit)

#pragma mark 判断两个时间差
+ (NSString *)ba_intervalSinceNow:(NSDate *)theDate;

@end
