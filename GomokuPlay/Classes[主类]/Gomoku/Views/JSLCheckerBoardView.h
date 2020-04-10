
#import <UIKit/UIKit.h>
#import "JSLPlayer.h"
@protocol JSLCheckerBoardViewDelegate;

UIKIT_EXTERN NSInteger const CHECKER_BOARD_SIZE_N08;
UIKIT_EXTERN NSInteger const CHECKER_BOARD_SIZE_N10;
UIKIT_EXTERN NSInteger const CHECKER_BOARD_SIZE_N12;
UIKIT_EXTERN NSInteger const CHECKER_BOARD_SIZE_N14;

@interface JSLCheckerBoardView : UIView

@property (nonatomic, weak) id<JSLCheckerBoardViewDelegate> delegate;

- (JSLPoint)findPointWithLocation:(CGPoint)location;
- (void)removeImageWithCount:(int)count;
- (void)insertPieceAtPoint:(JSLPoint)point playerType:(JSLPlayerType)playerType;
- (void)reset;

@end

@protocol JSLCheckerBoardViewDelegate <NSObject>
- (void)boardView:(JSLCheckerBoardView *)boardView didTapOnPoint:(JSLPoint)point;
@end

