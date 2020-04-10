//
//  NSDictionary+JSONString.h
//  YHSCategories
//
//  Created by MASON on 2016/11/29.
//  Copyright © 2016年 MASON. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSONString)

/**
 *  @brief NSDictionary转换成JSON字符串
 *
 *  @return  JSON字符串
 */
- (NSString *)JSONString;

@end
