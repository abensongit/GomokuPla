
#import "JSLMove.h"

@implementation JSLMove

- (instancetype)initWithPlayer:(JSLPlayerType)playerType point:(JSLPoint)point
{
    self = [super init];
    if (self) {
        _point = point;
        _playerType = playerType;
    }
    return self;
}

@end
