
#import "JSLBoard.h"

@interface JSLGreedyAI : JSLBoard

- (instancetype)initWithPlayer:(JSLPlayerType)playerType;
- (int)getScoreWithPoint:(JSLPoint)point;

@end
