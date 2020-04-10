//
//  UIImage+Frame.h
//  YHSCategories
//
//  Created by MASON on 2016/11/29.
//  Copyright © 2016年 MASON. All rights reserved.
//

#import "UIImage+Splash.h"

@implementation UIImage (Splash)

+ (UIImage *)splashImage
{
    return [UIImage splashImageForInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

+ (UIImage *)splashImageForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (orientation == UIInterfaceOrientationPortrait ||
            orientation == UIInterfaceOrientationPortraitUpsideDown) {
            return [UIImage imageNamed:@"Default-Portrait"];
        }
        else return [UIImage imageNamed:@"Default-Landscape"];
    }
    else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_6_1
        if ([[UIScreen mainScreen] bounds].size.height == 568.0f) return [UIImage imageNamed:@"LaunchImage-568h@2x"];
        else return [UIImage imageNamed:@"LaunchImage"];
#else
        if ([[UIScreen mainScreen] bounds].size.height == 568.0f) return [UIImage imageNamed:@"Default-568h"];
        else return [UIImage imageNamed:@"Default"];
#endif
    }
}

@end
