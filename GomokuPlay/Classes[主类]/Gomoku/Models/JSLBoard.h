
#import "JSLMove.h"

static int const GRID_SIZE = 15;

typedef NS_ENUM(NSInteger, JSLPieceType) {
    JSLPieceTypeBlank,
    JSLPieceTypeBlack,
    JSLPieceTypeWhite
};

@interface JSLBoard : NSObject
{
    @protected
    JSLPieceType _grid[GRID_SIZE][GRID_SIZE];
}

- (instancetype)init;
- (void)initBoard;
- (BOOL)isEmpty;
- (BOOL)canMoveAtPoint:(JSLPoint)point;
- (BOOL)checkWinAtPoint:(JSLPoint)point;
- (void)makeMove:(JSLMove *)move;
- (void)undoMove:(JSLMove *)move;

- (JSLMove *)getBestMove;

@end
