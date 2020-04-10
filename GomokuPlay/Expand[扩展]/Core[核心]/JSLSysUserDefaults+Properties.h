
#import "JSLSysUserDefaults.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSLSysUserDefaults (Properties)

@property (nonatomic, weak) NSString *token;               // 系统Token
@property (nonatomic, weak) NSString *userId;              // 用户标识
@property (nonatomic, weak) NSString *userName;            // 用户名称
@property (nonatomic, weak) NSString *nickName;            // 用户名称
@property (nonatomic, weak) NSString *appversion;          // 系统版本

@property (nonatomic, weak) NSNumber *difficulty;          // 难度选择（初级/中级/高级）
@property (nonatomic, weak) NSNumber *checkerBoardSize;    // 棋盘大小（8/10/12/14）
@property (nonatomic, assign) BOOL backgrondMusicStatus;   // 背景音乐（开/关）
@property (nonatomic, assign) BOOL movePieceSoundStatus;   // 棋子声音（开/关）
@property (nonatomic, assign) BOOL computerFirstStatus;    // 电脑先手（开/关）
@property (nonatomic, assign) BOOL computerBlackStatus;    // 电脑黑子（开/关）

@property (nonatomic, assign) BOOL loginStatus;            // 登录状态

@end

NS_ASSUME_NONNULL_END
