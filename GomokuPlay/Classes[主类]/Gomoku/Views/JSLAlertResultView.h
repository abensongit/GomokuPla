
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSLAlertResultView : UIView

@property (nonatomic, copy) NSString *tipInfo;

- (instancetype)initWithFrame:(CGRect)frame tipInfo:(NSString *)tipInfo;

@end

NS_ASSUME_NONNULL_END
