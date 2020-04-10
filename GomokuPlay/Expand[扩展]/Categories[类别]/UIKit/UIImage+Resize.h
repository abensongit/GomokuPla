//
//  UIImage+Resize.h
//  YHSCategories
//
//  Created by MASON on 2016/11/29.
//  Copyright © 2016年 MASON. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * Set of methods to crop and resize UIImage objects.
 */
@interface UIImage (Resize)

/*
 * Scales the image to the specified rect size.
 *
 * @param rect The rect to which the image should be scaled.
 * @returns A new scaled image.
 */
- (UIImage *)imageAtRect:(CGRect)rect;

/*
 */
- (UIImage *)imageScaledFittingToSize:(CGSize)size;

/*
 * Scales proportionally the image to the specified size.
 *
 * @param targetSize The size to which the image should proportionally be scaled.
 * @returns A new scaled image.
 */
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;

/*
 * Checks if the image as an alpha channel.
 */
- (BOOL)isProportionalToSize:(CGSize)size;

@end
