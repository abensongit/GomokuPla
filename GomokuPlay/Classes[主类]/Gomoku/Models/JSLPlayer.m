
#import "JSLPlayer.h"

@interface JSLPlayer ()
{
    JSLPlayerType _playerType;
    JSLBoard *_board;
}

@end

@implementation JSLPlayer

- (instancetype)initWithPlayer:(JSLPlayerType)playerType difficulty:(JSLDifficulty)difficulty
{
    self = [super init];
    if (self) {
        _playerType = playerType;
        switch (difficulty) {
            case JSLDifficultyEasy:
                _board = [[JSLGreedyAI alloc] initWithPlayer:playerType];
                break;
            case JSLDifficultyMedium:
                _board = [[JSLMinimaxAI alloc] initWithPlayer:playerType];
                [(JSLMinimaxAI *)_board setDepth:6];
                break;
            case JSLDifficultyHard:
                _board = [[JSLMinimaxAI alloc] initWithPlayer:playerType];
                [(JSLMinimaxAI *)_board setDepth:8];
                break;
        }
    }
    
    return self;
}

- (void)update:(JSLMove *)move
{
    if (move != nil) {
        [_board makeMove:move];
    }
}

- (void)regret:(JSLMove *)move
{
    if (move != nil) {
        [_board undoMove:move];
    }
}

- (JSLMove *)getMove
{
    if ([_board isEmpty]) {
        JSLPoint point;
        point.i = 7;
        point.j = 7;
        JSLMove *move = [[JSLMove alloc] initWithPlayer:_playerType point:point];
        [self update:move];
        return move;
    } else {
        JSLMove *move = [_board getBestMove];
        return move;
    }
}

@end
