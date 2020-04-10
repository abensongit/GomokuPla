
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSLPlayerMarkView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageUrl;

- (instancetype)initWithPlayerMarkTitle:(NSString *)title imageUrl:(NSString *)imageUrl;

@end

NS_ASSUME_NONNULL_END
