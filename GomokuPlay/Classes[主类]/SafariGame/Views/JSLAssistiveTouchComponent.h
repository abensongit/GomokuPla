
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JSLAssistiveTouchStyle) {
    JSLAssistiveTouchStylePop,   // 弹出 #Default
    JSLAssistiveTouchStyleShape, // 扇形 #未实现
};

@interface JSLAssistiveTouchComponent : UIView
@property (nonatomic, strong) UIButton *spreadButton;
@property (nonatomic, assign) JSLAssistiveTouchStyle style;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, strong) NSArray <UIView *> *subItems;
@property (nonatomic, assign) CGFloat offsetAngle; /**< 偏移角度，默认0。90度方向开始展开*/
@property (nonatomic, assign) CGFloat radius; /**< 弹出button半径 #70*/
@property (nonatomic, assign) BOOL wannaToClips; /**< 切圆 #YES*/
@property (nonatomic, assign) BOOL canClickTempOn;  /**< 开启背景遮幕 #YES*/
@property (nonatomic, assign) BOOL wannaToClickTempDismiss; /**< 点击屏幕消失；需要设置canClickTempOn = YES #YES*/
@property (nonatomic, assign) BOOL wannaToScaleSpreadButtonEffect; /**< 开启按钮缩放 #YES*/
@property (nonatomic, assign) BOOL spreadButtonOpenViscousity; /**< 开启粘滞功能 #YES*/
@property (nonatomic, assign) BOOL autoAdjustToFitSubItemsPosition; /**< 自动适配subItems的位置 #NO*/
@property (nonatomic, assign) CGFloat spreadDis; /**< 弹开的距离，需要设置autoAdjustToFitSubItemsPosition = NO*/
@property (nonatomic, assign) BOOL isSpreading; /**< 是否是展开状态*/

@property (nonatomic, strong) UIColor *normalBackgroundColor; /**< 正常按钮背景颜色 */
@property (nonatomic, strong) UIColor *selectBackgroundColor; /**< 选中按钮背景颜色 */

- (instancetype)initWithSubItems:(NSArray <UIView *> *)subItems;
- (void)spreadWithHandle:(void(^)(void))handle;
- (void)shrinkWithHandle:(void(^)(void))handle;

@end

NS_ASSUME_NONNULL_END
