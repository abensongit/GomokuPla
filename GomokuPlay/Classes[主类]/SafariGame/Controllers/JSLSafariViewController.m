
#import "JSLSafariViewController.h"
#import "JSLAssistiveTouchButton.h"

@interface JSLSafariViewController () <JSLAssistiveTouchButtonDelegate>
@property (nonatomic, strong) JSLAssistiveTouchButton *touchButton;
@end

@implementation JSLSafariViewController

#pragma mark -
#pragma mark 视图生命周期（加载视图）
- (void)viewDidLoad
{
    [super viewDidLoad];

    WEAKSELF(weakSelf);
    
    // 辅助悬浮按钮
    {
        CGFloat touchBtnsize = 44.0f;
        CGRect frame = CGRectMake(self.view.frame.size.width, self.view.frame.size.height*0.60f, touchBtnsize, touchBtnsize);
        NSArray<NSString *> *IMAGES = @[ ICON_WEB_VIEW_BUTTON_CLEAR_CACHE, ICON_WEB_VIEW_BUTTON_RETURN_BACK,
                                         ICON_WEB_VIEW_BUTTON_REFRESH, ICON_WEB_VIEW_BUTTON_HOME];
        JSLAssistiveTouchButton *touchButton  = [[JSLAssistiveTouchButton alloc] initWithFrame:frame];
        [self setTouchButton:touchButton];
        [self.view addSubview:touchButton];
        
        [touchButton setDelegate:self];
        [touchButton setImages:IMAGES];
        [touchButton setRadius:touchBtnsize/2.0f];
        [touchButton setCanClickTempOn:YES]; // 开启背景遮幕
        [touchButton setWannaToClickTempDismiss:YES]; // 点击屏幕消失，需要设置canClickTempOn
        [touchButton setSpreadButtonOpenViscousity:YES]; // 开启粘滞功能
        [touchButton setWannaToScaleSpreadButtonEffect:NO];
        [touchButton setAutoAdjustToFitSubItemsPosition:YES];
        [touchButton setNormalImage:[UIImage imageNamed:ICON_WEB_VIEW_BUTTON_TOUCH_SETTING]];
        [touchButton setSelectImage:[UIImage imageNamed:ICON_WEB_VIEW_BUTTON_TOUCH_CLOSE]];
    }

    // 浏览器设置
    {
        // 事件处理Block
        [self.webView setHitTestEventBlock:^{
            [weakSelf.touchButton hitTestWithEventToShrinkCloseHandle];
        }];
        
        // 重置尺寸大小
        [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.view.mas_top).offset(STATUS_BAR_HEIGHT);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    }

}


#pragma mark -
#pragma mark JSLAssistiveTouchButtonDelegate
- (void)touchButton:(JSLAssistiveTouchButton *)touchButton didSelectedAtIndex:(NSUInteger)index withSelectedButton:(UIButton *)button
{
    JSLLog(@"下标=>%ld", index);
    if (0 == index) {
        [self pressButtonWebViewCacheAction];
        [self.view makeToast:@"清除缓存成功" duration:1.0 position:CSToastPositionCenter];
    } else if (1 == index) {
        [self pressButtonWebViewGoBackAction];
    } else if (2 == index) {
        [self pressButtonWebViewRefreshAction];
    } else if (3 == index) {
        [self pressButtonWebViewHomeAction];
    }
}

#pragma mark -
#pragma mark 设置状态栏是否隐藏
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark 设置导航条是否隐藏
- (BOOL)prefersNavigationBarHidden
{
    return YES;
}



@end
