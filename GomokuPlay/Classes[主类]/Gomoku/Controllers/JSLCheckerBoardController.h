
#import <UIKit/UIKit.h>
#import "JSLCheckerBoardView.h"

@class GCDAsyncSocket;

typedef NS_ENUM(NSInteger, JSLGomokuPlayMode) {
    JSLGomokuPlayModeSingle,
    JSLGomokuPlayModeDouble,
    JSLGomokuPlayModeLAN
};

@interface JSLCheckerBoardController : JSLBaseCommonViewController <JSLCheckerBoardViewDelegate>

@property (nonatomic, assign) JSLGomokuPlayMode gamePlayMode;
@property (nonatomic, strong) JSLCheckerBoardView *boardView;

@end
