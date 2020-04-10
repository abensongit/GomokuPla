
#import "JSLGreedyAI.h"

typedef NS_ENUM(NSInteger, JSLGreedyAITupleType) {
    JSLGreedyAITupleTypeBlank,
    JSLGreedyAITupleTypeB,
    JSLGreedyAITupleTypeBB,
    JSLGreedyAITupleTypeBBB,
    JSLGreedyAITupleTypeBBBB,
    JSLGreedyAITupleTypeW,
    JSLGreedyAITupleTypeWW,
    JSLGreedyAITupleTypeWWW,
    JSLGreedyAITupleTypeWWWW,
    JSLGreedyAITupleTypePolluted
};

@interface JSLGreedyAI() {
    JSLPlayerType _playerType;
}
@end

@implementation JSLGreedyAI

- (instancetype)initWithPlayer:(JSLPlayerType)playerType
{
    self = [super init];
    if (self) {
        _playerType = playerType;
    }
    return self;
}

- (JSLMove *)getBestMove
{
    int maxScore = 0;
    JSLPoint bestPoint;
    
    int index = 0;
    JSLPoint bestPoints[GRID_SIZE * GRID_SIZE];
    
    for (int i = 0; i < GRID_SIZE; i++) {
        for (int j = 0; j < GRID_SIZE; j++) {
            if (_grid[i][j] == JSLPieceTypeBlank) {
                JSLPoint point;
                point.i = i;
                point.j = j;
                
                int score = [self getScoreWithPoint:point];
                if (score == maxScore) {
                    bestPoints[index] = point;
                    index++;
                } else if (score > maxScore) {
                    maxScore = score;
                    index = 0;
                    bestPoints[index] = point;
                    index++;
                }
            }
        }
    }
    
    bestPoint = bestPoints[arc4random_uniform(index)];
    
    JSLMove *bestMove = [[JSLMove alloc] initWithPlayer:_playerType point:bestPoint];
    [self makeMove:bestMove];
    
    return bestMove;
}

- (int)getScoreWithPoint:(JSLPoint)point
{
    int score = 0;
    int i = point.i;
    int j = point.j;
    
    // Horizontal
    for (; i > point.i - 5; i--) {
        if (i >= 0 && i + 4 < GRID_SIZE) {
            int m = i;
            int n = j;
            int black = 0;
            int white = 0;
            for (; m < i + 5; m++) {
                if (_grid[m][n] == JSLPieceTypeBlack) {
                    black++;
                }
                if (_grid[m][n] == JSLPieceTypeWhite) {
                    white++;
                }
            }
            score += [self evaluateWithTuple:[self getTupleTypeWithBlackNum:black whiteNum:white]];
        }
    }
    
    // Vertical
    i = point.i;
    for (; j > point.j - 5; j--) {
        if (j >= 0 && j + 4 < GRID_SIZE) {
            int m = i;
            int n = j;
            int black = 0;
            int white = 0;
            for (; n < j + 5; n++) {
                if (_grid[m][n] == JSLPieceTypeBlack) {
                    black++;
                }
                if (_grid[m][n] == JSLPieceTypeWhite) {
                    white++;
                }
            }
            score += [self evaluateWithTuple:[self getTupleTypeWithBlackNum:black whiteNum:white]];
        }
    }
    
    // Oblique up
    i = point.i;
    j = point.j;
    for (; i > point.i - 5 && j > point.j - 5; i--, j--) {
        if (i >= 0 && j >= 0 && i + 4 < GRID_SIZE && j + 4 < GRID_SIZE) {
            int m = i;
            int n = j;
            int black = 0;
            int white = 0;
            for (; m < i + 5 && n < j + 5; m++, n++) {
                if (_grid[m][n] == JSLPieceTypeBlack) {
                    black++;
                }
                if (_grid[m][n] == JSLPieceTypeWhite) {
                    white++;
                }
            }
            score += [self evaluateWithTuple:[self getTupleTypeWithBlackNum:black whiteNum:white]];
        }
    }
    
    // Oblique down
    i = point.i;
    j = point.j;
    for (; i > point.i - 5 && j < point.j + 5; i--, j++) {
        if (i >= 0 && j < GRID_SIZE && i + 4 < GRID_SIZE && j - 4 >= 0) {
            int m = i;
            int n = j;
            int black = 0;
            int white = 0;
            for (; m < i + 5 && n > j - 5; m++, n--) {
                if (_grid[m][n] == JSLPieceTypeBlack) {
                    black++;
                }
                if (_grid[m][n] == JSLPieceTypeWhite) {
                    white++;
                }
            }
            score += [self evaluateWithTuple:[self getTupleTypeWithBlackNum:black whiteNum:white]];
        }
    }
    
    return score;
}

- (JSLGreedyAITupleType)getTupleTypeWithBlackNum:(int)black whiteNum:(int)white
{
    if (black + white == 0) {
        return JSLGreedyAITupleTypeBlank;
    }
    if (black == 1 && white == 0) {
        return JSLGreedyAITupleTypeB;
    }
    if (black == 2 && white == 0) {
        return JSLGreedyAITupleTypeBB;
    }
    if (black == 3 && white == 0) {
        return JSLGreedyAITupleTypeBBB;
    }
    if (black == 4 && white == 0) {
        return JSLGreedyAITupleTypeBBBB;
    }
    if (black == 0 && white == 1) {
        return JSLGreedyAITupleTypeW;
    }
    if (black == 0 && white == 2) {
        return JSLGreedyAITupleTypeWW;
    }
    if (black == 0 && white == 3) {
        return JSLGreedyAITupleTypeWWW;
    }
    if (black == 0 && white == 4) {
        return JSLGreedyAITupleTypeWWWW;
    } else {
        return JSLGreedyAITupleTypePolluted;
    }
}

- (int)evaluateWithTuple:(JSLGreedyAITupleType)tupleType
{
    if (_playerType == JSLPlayerTypeBlack) {
        switch (tupleType) {
            case JSLGreedyAITupleTypeBlank:
                return 7;
            case JSLGreedyAITupleTypeB:
                return 35;
            case JSLGreedyAITupleTypeBB:
                return 800;
            case JSLGreedyAITupleTypeBBB:
                return 15000;
            case JSLGreedyAITupleTypeBBBB:
                return 800000;
            case JSLGreedyAITupleTypeW:
                return 15;
            case JSLGreedyAITupleTypeWW:
                return 400;
            case JSLGreedyAITupleTypeWWW:
                return 1800;
            case JSLGreedyAITupleTypeWWWW:
                return 100000;
            case JSLGreedyAITupleTypePolluted:
                return 0;
        }
    } else {
        switch (tupleType) {
            case JSLGreedyAITupleTypeBlank:
                return 7;
            case JSLGreedyAITupleTypeB:
                return 15;
            case JSLGreedyAITupleTypeBB:
                return 400;
            case JSLGreedyAITupleTypeBBB:
                return 1800;
            case JSLGreedyAITupleTypeBBBB:
                return 100000;
            case JSLGreedyAITupleTypeW:
                return 35;
            case JSLGreedyAITupleTypeWW:
                return 800;
            case JSLGreedyAITupleTypeWWW:
                return 15000;
            case JSLGreedyAITupleTypeWWWW:
                return 800000;
            case JSLGreedyAITupleTypePolluted:
                return 0;
        }
    }
}

@end
