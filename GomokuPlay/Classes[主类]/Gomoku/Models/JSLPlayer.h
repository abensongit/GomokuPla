
#import "JSLGreedyAI.h"
#import "JSLMinimaxAI.h"

typedef NS_ENUM(NSInteger, JSLDifficulty) {
    JSLDifficultyEasy = 0,
    JSLDifficultyMedium,
    JSLDifficultyHard
};

@interface JSLPlayer : NSObject

- (instancetype)initWithPlayer:(JSLPlayerType)playerType difficulty:(JSLDifficulty)difficulty;
- (void)update:(JSLMove *)move;
- (void)regret:(JSLMove *)move;
- (JSLMove *)getMove;

@end
