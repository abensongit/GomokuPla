
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSLSettingSwitchButton : UIControl

- (void)setChecked:(BOOL)boolValue;
- (void)setDisabled:(BOOL)boolValue;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) BOOL checked;
@property (nonatomic, assign) BOOL disabled;

@end

NS_ASSUME_NONNULL_END
