
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSLSysConst : NSObject

#pragma mark 控件间隔常量
UIKIT_EXTERN CGFloat const MARGIN;

#pragma mark 最小浮点常量
UIKIT_EXTERN CGFloat const NEX_FLOAT_MIN;

#pragma mark 标签栏高度(系统默认高度为49)
UIKIT_EXTERN CGFloat const TAB_BAR_HEIGHT;

#pragma mark 标签栏高度 - 危险区域
UIKIT_EXTERN CGFloat const TAB_BAR_DANGER_HEIGHT;

#pragma mark 状态栏+导航条容器TAG值
UIKIT_EXTERN CGFloat const STATUS_NAVIGATION_BAR_TAG;

#pragma mark 标签栏+危险区高度(系统默认为83或49)
#define TAB_BAR_AND_DANGER_HEIGHT (IS_IPHONE_X_OR_GREATER?83.0:49.0)

#pragma mark 导航条高度
UIKIT_EXTERN CGFloat const NAVIGATION_BAR_HEIGHT;

#pragma mark 状态栏高度(系统默认为44或20)
#define STATUS_BAR_HEIGHT (IS_IPHONE_X_OR_GREATER?44.0:20.0)

#pragma mark 状态栏+导航条高度(系统默认为88或64)
#define STATUS_NAVIGATION_BAR_HEIGHT (IS_IPHONE_X_OR_GREATER?88.0:64.0)

#pragma mark 导航条底部发丝线(系统默认高度为1.0)
UIKIT_EXTERN CGFloat const NAVIGATION_BAR_HAIR_LINE_HEIGHT_ZERO;
UIKIT_EXTERN CGFloat const NAVIGATION_BAR_HAIR_LINE_HEIGHT_DEFAULT;

#pragma mark 导航条按钮与屏幕边距
UIKIT_EXTERN CGFloat const NAVIGATION_BAR_SCREEN_MARGIN;

#pragma mark 导航条左右按钮最大宽度
UIKIT_EXTERN CGFloat const NAVIGATION_BAR_BUTTON_MAX_WIDTH;

#pragma mark 导航条标题字数限制
UIKIT_EXTERN CGFloat const NAVIGATION_BAR_TITLE_MAX_NUM;

#pragma mark 系统分割线默认高度
UIKIT_EXTERN CGFloat const SEPARATOR_LINE_HEIGHT;


@end

NS_ASSUME_NONNULL_END
