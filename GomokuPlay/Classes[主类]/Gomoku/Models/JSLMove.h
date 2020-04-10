
#import <Foundation/Foundation.h>

typedef struct {
    int i;
    int j;
} JSLPoint;

typedef NS_ENUM(NSInteger, JSLPlayerType) {
    JSLPlayerTypeBlack,
    JSLPlayerTypeWhite
};

@interface JSLMove : NSObject

@property (nonatomic, readonly) JSLPoint point;
@property (nonatomic, readonly) JSLPlayerType playerType;

- (instancetype)initWithPlayer:(JSLPlayerType)playerType point:(JSLPoint)point;

@end
