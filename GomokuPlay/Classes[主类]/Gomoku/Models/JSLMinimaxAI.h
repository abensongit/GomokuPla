
#import "JSLGreedyAI.h"

@interface JSLMinimaxAI : JSLGreedyAI

- (instancetype)initWithPlayer:(JSLPlayerType)playerType;
- (void)setDepth:(int)depth;

@end
