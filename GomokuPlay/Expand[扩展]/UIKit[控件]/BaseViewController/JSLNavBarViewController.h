
#import <UIKit/UIKit.h>
@class JSLNavBarViewController;

#pragma mark 导航栏类型
typedef NS_ENUM(NSInteger, JSLNavBarType) {
    JSLNavBarTypeDefault = 1,    // 默认系统导航栏
    JSLNavBarTypeCustom,         // 自定义导航栏（隐藏系统导航栏，自定义导航栏）
};

#pragma mark 导航栏按钮类型
typedef NS_ENUM(NSInteger, JSLNavBarButtonItemType) {
    JSLNavBarButtonItemTypeNone = 1,   // 无
    JSLNavBarButtonItemTypeDefault,    // 默认
    JSLNavBarButtonItemTypeCustom,     // 自定义
};

@protocol JSLNavBarViewControllerProtocol <NSObject>
@required
#pragma mark 设置状态栏是否隐藏
- (BOOL)prefersStatusBarHidden;
#pragma mark 设置状态栏的背景色
- (UIColor *)prefersStatusBarColor;
#pragma mark 设置状态栏样式类型
- (UIStatusBarStyle)preferredStatusBarStyle;
#pragma mark 设置状态栏隐藏动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation;

#pragma mark 设置导航条是否隐藏
- (BOOL)prefersNavigationBarHidden;
#pragma mark 设置导航条样式类型（默认:JSLNavBarTypeDefault）
- (JSLNavBarType)preferredNavigationBarType;
#pragma mark 设置导航条背景颜色
- (UIColor *)prefersNavigationBarColor;
#pragma mark 设置导航条背景图片
- (UIImage *)prefersNavigationBarBackgroundImage;
#pragma mark 设置导航条背景图片（是否强制使用图片）
- (BOOL)prefersNavigationBarBackgroundImageForce;
#pragma mark 设置导航栏底部横线高度
- (CGFloat)prefersNavigationBarHairlineHeight;
#pragma mark 设置导航栏底部横线背景颜色
- (UIColor *)prefersNavigationBarHairlineColor;

#pragma mark 设置导航条标题字体
- (UIFont *)prefersNavigationBarTitleFont;
#pragma mark 设置导航条标题颜色
- (UIColor *)prefersNavigationBarTitleColor;
#pragma mark 设置导航栏标题文字
- (NSString *)prefersNavigationBarTitleViewTitle;

#pragma mark 设置导航栏左边按钮类型（默认"返回"按钮）
- (JSLNavBarButtonItemType)prefersNavigationBarLeftButtonItemType;
#pragma mark 设置导航栏左边按钮控件标题（默认“返回”）
- (NSString *)prefersNavigationBarLeftButtonItemTitle;
#pragma mark 设置导航栏左边按钮控件标题字体
- (UIFont *)prefersNavigationBarLeftButtonItemTitleFont;
#pragma mark 设置导航栏左边按钮控件标题颜色（正常）
- (UIColor *)prefersNavigationBarLeftButtonItemTitleColorNormal;
#pragma mark 设置导航栏左边按钮控件标题颜色（选中）
- (UIColor *)prefersNavigationBarLeftButtonItemTitleColorSelect;
#pragma mark 设置导航栏左边按钮控件图标（正常）
- (NSString *)prefersNavigationBarLeftButtonItemImageNormal;
#pragma mark 设置导航栏左边按钮控件图标（选中）
- (NSString *)prefersNavigationBarLeftButtonItemImageSelect;
#pragma mark 点击导航栏左侧按钮事件
- (void)pressNavigationBarLeftButtonItem:(id)sender;

#pragma mark 设置导航栏右边按钮类型（默认 "" 按钮）
- (JSLNavBarButtonItemType)prefersNavigationBarRightButtonItemType;
#pragma mark 设置导航栏右边按钮控件标题（默认“”）
- (NSString *)prefersNavigationBarRightButtonItemTitle;
#pragma mark 设置导航栏右边按钮控件标题字体
- (UIFont *)prefersNavigationBarRightButtonItemTitleFont;
#pragma mark 设置导航栏右边按钮控件标题颜色（正常）
- (UIColor *)prefersNavigationBarRightButtonItemTitleColorNormal;
#pragma mark 设置导航栏右边按钮控件标题颜色（选中）
- (UIColor *)prefersNavigationBarRightButtonItemTitleColorSelect;
#pragma mark 设置导航栏右边按钮控件图标（正常）
- (NSString *)prefersNavigationBarRightButtonItemImageNormal;
#pragma mark 设置导航栏右边按钮控件图标（选中）
- (NSString *)prefersNavigationBarRightButtonItemImageSelect;
#pragma mark 点击导航栏右侧按钮事件
- (void)pressNavigationBarRightButtonItem:(id)sender;

#pragma mark 创建导航栏左边按钮控件
- (UIView *)createNavigationBarLeftButtonItem;
#pragma mark 创建导航栏右边按钮控件
- (UIView *)createNavigationBarRightButtonItem;

#pragma mark 创建导航栏按钮控件JSLNavBarButtonItemTypeDefault
- (UIView *)createNavigationBarButtonItemTypeDefaultTitle:(NSString *)title
                                         titleNormalColor:(UIColor *)normalColor
                                         titleSelectColor:(UIColor *)selectColor
                                                titleFont:(UIFont *)font
                                           iconNameNormal:(NSString *)iconNameNormal
                                           iconNameSelect:(NSString *)iconNameSelect
                                                   action:(SEL)action;
#pragma mark 创建导航栏按钮控件JSLNavBarButtonItemTypeCustom
- (UIView *)createNavigationBarButtonItemTypeCustomTitle:(NSString *)title
                                        titleNormalColor:(UIColor *)normalColor
                                        titleSelectColor:(UIColor *)selectColor
                                               titleFont:(UIFont *)font
                                          iconNameNormal:(NSString *)iconNameNormal
                                          iconNameSelect:(NSString *)iconNameSelect
                                                  action:(SEL)action;
@end

@interface JSLNavigationBarTitleView : UIView
@end

@interface JSLNavBarViewController : UIViewController <JSLNavBarViewControllerProtocol>

@property (nonatomic, strong) UIView *naviStatusBarCustomView; // 状态栏+导航栏容器
@property (nonatomic, strong) UIView *navigationBarCustomView; // 自定义导航栏
@property (nonatomic, strong) UIView *navigationBarHairlineImageView; // 系统自带导航栏底部1px横线

@property (nonatomic, strong) UIView *navigationBarTitleView; // 自定义导航栏标题视图
@property (nonatomic, copy) NSString *navigationBarTitleViewTitle; // 自定义导航栏标题

@property (nonatomic, strong) UIView *navigationBarLeftButtonItem; // 自定义导航栏左边按钮
@property (nonatomic, copy) NSString *navigationBarLeftButtonItemTitle; // 自定义导航栏左边按钮标题

@property (nonatomic, strong) UIView *navigationBarRightButtonItem; // 自定义导航栏右边按钮
@property (nonatomic, copy) NSString *navigationBarRightButtonItemTitle; // 自定义导航栏右边按钮标题

@end


