
#import "JSLCheckerBoardController.h"
#import "JSLSocketHostListController.h"
#import "JSLAlertResultView.h"
#import "JSLPlayerMarkView.h"
#import "JSLPlayer.h"
#import "JSLPacket.h"

NSString * const TIP_SINGLE_INFO_YOUR_TURN = @"该你下棋了！";
NSString * const TIP_SINGLE_INFO_OPPONENT_TURN = @"电脑思考中！";
NSString * const TIP_DOUBLE_INFO_PLAYER_BLACK = @"该黑子下棋了！";
NSString * const TIP_DOUBLE_INFO_PLAYER_WHITE = @"该白子下棋了！";

@interface JSLCheckerBoardController () <GCDAsyncSocketDelegate, JSLSocketHostListControllerDelegate> {
    JSLBoard *_board;
    JSLPlayer *_player;
    JSLPlayerType _playerType; // 当前正在下棋的玩家（黑棋/白棋）
    JSLPlayerType _singlePlayerType; // 单机模式，玩家棋子类型
    NSTimer *_timer;
    int _timeSecBlack;
    int _timeMinBlack;
    int _timeSecWhite;
    int _timeMinWhite;
    BOOL _isHost;
    BOOL _oppositeReset;
    BOOL _shouldDismiss;
    JSLMove *_whiteMove;
    JSLMove *_blackMove;
}

@property (nonatomic, strong) UIAlertController *resetWaitAlertController;
@property (nonatomic, strong) UIAlertController *resetChooseAlertController;
@property (nonatomic, strong) UIAlertController *resetRejectAlertController;
@property (nonatomic, strong) UIAlertController *waitAlertController;
@property (nonatomic, strong) UIAlertController *undoWaitAlertController;
@property (nonatomic, strong) UIAlertController *undoChooseAlertController;
@property (nonatomic, strong) UIAlertController *undoRejectAlertController;
@property (nonatomic, strong) GCDAsyncSocket *socket;

@property (nonatomic, strong) JSLAlertResultView *resultWinAlertView;

@property (nonatomic, strong) UIButton *buttonBack; // 返回按钮
@property (nonatomic, strong) UIButton *buttonReset; // 重开按钮
@property (nonatomic, strong) UIButton *buttonUndo; // 悔棋按钮
@property (nonatomic, strong) UIImageView *backgroundImageView; // 背景图片
@property (nonatomic, strong) UIImageView *headImageView; // 头像图片
@property (nonatomic, strong) UIImageView *tipMarkImageView; // 提示棋子图片
@property (nonatomic, strong) UILabel *tipInformationLabel; // 提示信息
@property (nonatomic, strong) UILabel *timerBlackLabel; // 黑色棋子用时
@property (nonatomic, strong) UILabel *timerWhiteLabel; // 白色棋子用时
@property (nonatomic, strong) UILabel *titleGomokuLabel; // 游戏标题
@property (nonatomic, strong) JSLPlayerMarkView *playerAMarkView; // 棋子标记A
@property (nonatomic, strong) JSLPlayerMarkView *playerBMarkView; // 棋子标记B

@end

@implementation JSLCheckerBoardController

#pragma mark -
#pragma mark 事件处理 - 返回
- (void)pressButtonBackAction:(UIButton *)button
{
    // 判断是否正在下棋中
    if (_blackMove || _whiteMove) {
        WEAKSELF(weakSelf);
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"结束游戏?"
                                                                       message:@"正在游戏，确定要退出游戏吗？"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 
                                                             }];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [weakSelf doWithButtonBackAction];
                                                              }];
        [alert addAction:cancelAction];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self doWithButtonBackAction];
    }
}

#pragma mark 事件处理 - 重开
- (void)pressButtonResetAction:(UIButton *)button
{
    // 判断是否正在下棋中
    if (_blackMove || _whiteMove) {
        WEAKSELF(weakSelf);
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"重开游戏?"
                                                                       message:@"正在游戏，确定要重开游戏吗？"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 
                                                             }];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [weakSelf doWithButtonResetAction];
                                                              }];
        [alert addAction:cancelAction];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self doWithButtonResetAction];
    }
}

#pragma mark 事件处理 - 悔棋
- (void)pressButtonUndoAction:(UIButton *)button
{
    if (_gamePlayMode == JSLGomokuPlayModeSingle) {
        if (_blackMove != nil && _whiteMove != nil) {
            [_board undoMove:_blackMove];
            [_board undoMove:_whiteMove];
            [_player regret:_blackMove];
            [_player regret:_whiteMove];
            [_boardView removeImageWithCount:2];
            _blackMove = nil;
            _whiteMove = nil;
            _buttonUndo.enabled = NO;
        }
    } else if (_gamePlayMode == JSLGomokuPlayModeDouble) {
        if (_playerType == JSLPlayerTypeBlack) {
            [_board undoMove:_whiteMove];
            [_boardView removeImageWithCount:1];
            [self switchPlayer];
            _buttonUndo.enabled = NO;
            _whiteMove = nil;
        } else {
            [_board undoMove:_blackMove];
            [_boardView removeImageWithCount:1];
            [self switchPlayer];
            _buttonUndo.enabled = NO;
            _blackMove = nil;
        }
    } else if (_gamePlayMode == JSLGomokuPlayModeLAN) {
        self.undoWaitAlertController = [UIAlertController alertControllerWithTitle:@"等待对方回应" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:_undoWaitAlertController animated:YES completion:nil];
        
        JSLPacket *packet = [[JSLPacket alloc] initWithData:nil type:JSLPacketTypeUndo action:JSLPacketActionUndoRequest];
        [self sendPacket:packet];
        
    }
}

#pragma mark 事件处理 - 音效
- (void)pressButtonMusicAction:(UIButton *)button
{
    
}


#pragma mark -
#pragma mark 事件处理 - 退出游戏
- (void)doWithButtonBackAction
{
    [_timer invalidate];
    _timer = nil;
    [_socket disconnect];
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark 事件处理 - 重开游戏
- (void)doWithButtonResetAction
{
    if (_gamePlayMode == JSLGomokuPlayModeSingle) {
        [self handleReset];
        [self choosePlayerType];
    } else if (_gamePlayMode == JSLGomokuPlayModeDouble){
        [self handleReset];
        [self startTimer];
    } else if (_gamePlayMode == JSLGomokuPlayModeLAN) {
        if (_oppositeReset == YES) {
            [self handleReset];
            [self startGameInLANMode];
            
            _oppositeReset = NO;
            NSString *data = @"reset";
            JSLPacket *packet = [[JSLPacket alloc] initWithData:data type:JSLPacketTypeReset action:JSLPacketActionUnknown];
            [self sendPacket:packet];
        } else {
            self.resetWaitAlertController = [UIAlertController alertControllerWithTitle:@"等待对方回应" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:_resetWaitAlertController animated:YES completion:nil];
            
            JSLPacket *packet = [[JSLPacket alloc] initWithData:nil type:JSLPacketTypeReset action:JSLPacketActionResetRequest];
            [self sendPacket:packet];
        }
    }
}


#pragma mark -
#pragma mark 设置状态栏是否隐藏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark -
#pragma mark 视图生命周期（加载视图）
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 游戏棋盘记录
    _board = [[JSLBoard alloc] init];
    
    // 根据玩家模式
    if (_gamePlayMode == JSLGomokuPlayModeSingle) {
        // 黑色棋子先下
        if (APPINFORMATION.computerFirstStatus) {
            _playerType = APPINFORMATION.computerBlackStatus ? JSLPlayerTypeBlack : JSLPlayerTypeWhite;
        } else {
            _playerType = APPINFORMATION.computerBlackStatus ? JSLPlayerTypeWhite : JSLPlayerTypeBlack;
        }
        // 单机玩家类型
        _singlePlayerType = APPINFORMATION.computerBlackStatus ? JSLPlayerTypeWhite : JSLPlayerTypeBlack;
    } else if (_gamePlayMode == JSLGomokuPlayModeDouble) {
        // 黑色棋子先下
        _playerType = JSLPlayerTypeBlack;
    }
    
    // 初始化加载控件
    [self viewDidLoadInitControls];
}

#pragma mark 视图生命周期（已经视图）
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _buttonUndo.enabled = NO;
    _boardView.delegate = self;
    
    if (_gamePlayMode == JSLGomokuPlayModeSingle) {
        [self choosePlayerType];
    } else if (_gamePlayMode == JSLGomokuPlayModeDouble) {
        _tipInformationLabel.text = TIP_DOUBLE_INFO_PLAYER_BLACK;
        [self startTimer];
    } else if (_gamePlayMode == JSLGomokuPlayModeLAN && _shouldDismiss == YES) {
        [self dismissViewControllerAnimated:NO completion:nil];
    } else if (_gamePlayMode == JSLGomokuPlayModeLAN && _socket == nil) {
        [self performSegueWithIdentifier:@"findGame" sender:nil];
    } else if (_gamePlayMode == JSLGomokuPlayModeLAN && _socket != nil) {
        [self startGameInLANMode];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    JSLNavigationController *destinationNavigationController = segue.destinationViewController;
    JSLSocketHostListController *targetController = (JSLSocketHostListController *)(destinationNavigationController.topViewController);
    targetController.delegate = self;
}

#pragma mark 视图加载控件
- (void)viewDidLoadInitControls
{
    // 控件大小
    CGFloat margin = JSL_AUTOSIZING_MARGIN_SCALE(MARGIN);
    CGFloat button_width = JSL_AUTOSIZING_WIDTH_SCALE(100.0f);
    CGFloat button_height = JSL_AUTOSIZING_WIDTH_SCALE(40.0f);
    CGFloat player_head_width = JSL_AUTOSIZING_WIDTH_SCALE(90.0f);
    CGFloat player_head_height = JSL_AUTOSIZING_WIDTH_SCALE(66.0f);
    CGFloat player_font_width = [@"暂位符" widthWithFont:[UIFont boldSystemFontOfSize:JSL_AUTOSIZING_FONT_SCALE(18.0f)] constrainedToHeight:MAXFLOAT];
    CGFloat player_mark_height = JSL_AUTOSIZING_WIDTH_SCALE(30.0f);
    CGFloat player_mark_width = player_mark_height*1.7f + player_font_width;
    
    // 背景图片
    [self.view addSubview:self.backgroundImageView];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    // 游戏控件 - 游戏标题
    [self.view addSubview:self.titleGomokuLabel];
    [self.titleGomokuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        if (@available(iOS 11.0, *)) {
            if (IS_IPHONE_X_OR_GREATER) {
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(margin*4.0f);
            } else {
                make.top.equalTo(self.view.mas_top).offset(margin*4.0f);
            }
        } else {
            make.top.equalTo(self.view.mas_top).offset(margin*4.0f);
        }
    }];
    
    // 游戏控件 - 头像控件
    [self.view addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(margin*1.5f);
        make.top.equalTo(self.titleGomokuLabel.mas_bottom).offset(margin*3.0f);
        make.width.mas_equalTo(player_head_width);
        make.height.mas_equalTo(player_head_height);
    }];
    
    // 游戏控件 - 提示图片
    [self.headImageView addSubview:self.tipMarkImageView];
    [self.tipMarkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat tipMarkImageSize = player_head_height * 0.48f;
        make.right.equalTo(self.headImageView.mas_right);
        make.top.equalTo(self.headImageView.mas_top);
        make.width.mas_equalTo(tipMarkImageSize);
        make.height.mas_equalTo(tipMarkImageSize);
    }];
    
    // 游戏控件 - 提示信息
    [self.view addSubview:self.tipInformationLabel];
    [self.tipInformationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(margin*1.5f);
        make.bottom.equalTo(self.headImageView.mas_bottom).offset(margin*0.2f);
        make.right.equalTo(self.view.mas_right).offset(-margin*1.5f);
    }];

    // 游戏控件 - 玩家甲
    [self.view addSubview:self.playerAMarkView];
    [self.playerAMarkView setTitle:@"电脑端"];
    [self.playerAMarkView setImageUrl:ICON_GOMOKU_PIECE_BLACK];
    [self.playerAMarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.mas_top);
        make.right.equalTo(self.view.mas_right).offset(-margin*1.0f);
        make.size.mas_equalTo(CGSizeMake(player_mark_width, player_mark_height));
    }];
    
    // 游戏控件 - 玩家乙
    [self.view addSubview:self.playerBMarkView];
    [self.playerBMarkView setTitle:@"玩    家"];
    [self.playerBMarkView setImageUrl:ICON_GOMOKU_PIECE_WHITE];
    [self.playerBMarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headImageView.mas_bottom);
        make.right.equalTo(self.view.mas_right).offset(-margin*1.0f);
        make.size.mas_equalTo(CGSizeMake(player_mark_width, player_mark_height));
    }];

    // 游戏控件 - 象棋棋盘
    [self.view addSubview:self.boardView];
    [self.boardView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat boardSize = SCREEN_MIN_LENGTH-margin*2.0f;
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.headImageView.mas_bottom).offset(margin*1.0f);
        make.width.mas_equalTo(boardSize);
        make.height.mas_equalTo(boardSize);
    }];
    
    // 游戏控件 - 黑色时间
    [self.view addSubview:self.timerBlackLabel];
    [self.timerBlackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.boardView.mas_left).offset(margin*0.2f);
        make.top.equalTo(self.boardView.mas_bottom).offset(margin*0.5f);
        make.right.equalTo(self.boardView.mas_centerX);
    }];

    // 游戏控件 - 白色时间
    [self.view addSubview:self.timerWhiteLabel];
    [self.timerWhiteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.boardView.mas_centerX);
        make.top.equalTo(self.timerBlackLabel.mas_top);
        make.right.equalTo(self.boardView.mas_right).offset(-margin*0.2f);
    }];
    
    // 游戏控件 - 按钮 - 悔棋
    [self.view addSubview:self.buttonUndo];
    [self.buttonUndo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.boardView.mas_centerX);
        make.top.equalTo(self.boardView.mas_bottom).offset(margin*3.0f);
        make.width.mas_equalTo(button_width);
        make.height.mas_equalTo(button_height);
    }];
    
    // 游戏控件 - 按钮 - 返回
    [self.view addSubview:self.buttonBack];
    [self.buttonBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.buttonUndo.mas_left).offset(-margin*2.0f);
        make.top.equalTo(self.buttonUndo.mas_top);
        make.width.mas_equalTo(button_width);
        make.height.mas_equalTo(button_height);
    }];

    // 游戏控件 - 按钮 - 重开
    [self.view addSubview:self.buttonReset];
    [self.buttonReset mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.buttonUndo.mas_right).offset(margin*2.0f);
        make.top.equalTo(self.buttonUndo.mas_top);
        make.width.mas_equalTo(button_width);
        make.height.mas_equalTo(button_height);
    }];
    
    // 游戏控件 - 设置玩家
    if (_gamePlayMode == JSLGomokuPlayModeSingle) {
        if (APPINFORMATION.computerBlackStatus) {
            [self.playerAMarkView setTitle:@"电脑端"];
            [self.playerBMarkView setTitle:@"玩    家"];
            [self.playerAMarkView setImageUrl:ICON_GOMOKU_PIECE_BLACK];
            [self.playerBMarkView setImageUrl:ICON_GOMOKU_PIECE_WHITE];
        } else {
            [self.playerAMarkView setTitle:@"电脑端"];
            [self.playerBMarkView setTitle:@"玩    家"];
            [self.playerAMarkView setImageUrl:ICON_GOMOKU_PIECE_WHITE];
            [self.playerBMarkView setImageUrl:ICON_GOMOKU_PIECE_BLACK];
        }
    } else if (_gamePlayMode == JSLGomokuPlayModeDouble) {
        [self.playerAMarkView setTitle:@"玩家甲"];
        [self.playerBMarkView setTitle:@"玩家乙"];
        [self.playerAMarkView setImageUrl:ICON_GOMOKU_PIECE_BLACK];
        [self.playerBMarkView setImageUrl:ICON_GOMOKU_PIECE_WHITE];
    }
    
}



#pragma mark -
#pragma mark 游戏逻辑 - 开始联机游戏
- (void)startGameInLANMode
{
    [self startTimer];
    if (!_isHost) {
        _tipInformationLabel.text = TIP_SINGLE_INFO_OPPONENT_TURN;
        self.waitAlertController = [UIAlertController alertControllerWithTitle:@"请等待对方先下" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:_waitAlertController animated:YES completion:nil];
    } else {
        _tipInformationLabel.text = TIP_SINGLE_INFO_YOUR_TURN;
    }
}

#pragma mark 游戏逻辑 - 设置等级黑白
- (void)choosePlayerType
{
    // 难度等级
    JSLDifficulty difficulty;
    switch (APPINFORMATION.difficulty.integerValue) {
        case 0:
            difficulty = JSLDifficultyEasy;
            break;
        case 1:
            difficulty = JSLDifficultyMedium;
            break;
        case 2:
            difficulty = JSLDifficultyHard;
            break;
        default:
            difficulty = JSLDifficultyEasy;
            break;
    }
    
    // 先手后手
    if (APPINFORMATION.computerFirstStatus) {
        [self startTimer];
        _player = [[JSLPlayer alloc] initWithPlayer:(APPINFORMATION.computerBlackStatus ? JSLPlayerTypeBlack : JSLPlayerTypeWhite)
                                         difficulty:difficulty];
        [self AIPlayWithMove:nil];
        _tipInformationLabel.text = TIP_SINGLE_INFO_OPPONENT_TURN;
    } else {
        [self startTimer];
        _player = [[JSLPlayer alloc] initWithPlayer:(APPINFORMATION.computerBlackStatus ? JSLPlayerTypeBlack : JSLPlayerTypeWhite)
                                         difficulty:difficulty];
        _tipInformationLabel.text = TIP_SINGLE_INFO_YOUR_TURN;
    }
    
    // 提示图片
    _tipMarkImageView.image = [UIImage imageNamed:(( _playerType == JSLPlayerTypeBlack)? ICON_GOMOKU_PIECE_BLACK: ICON_GOMOKU_PIECE_WHITE)];
}

#pragma mark 游戏逻辑 - 玩家角色转换
- (void)switchPlayer
{
    if (_playerType == JSLPlayerTypeBlack) {
        _playerType = JSLPlayerTypeWhite;
    } else {
        _playerType = JSLPlayerTypeBlack;
    }
    
    // 游戏模式
    if (_gamePlayMode == JSLGomokuPlayModeSingle) {
        if (_tipInformationLabel.text == TIP_SINGLE_INFO_YOUR_TURN) {
            _tipInformationLabel.text = TIP_SINGLE_INFO_OPPONENT_TURN;
        } else if (_tipInformationLabel.text == TIP_SINGLE_INFO_OPPONENT_TURN) {
            _tipInformationLabel.text = TIP_SINGLE_INFO_YOUR_TURN;
        }
    } else if (_gamePlayMode == JSLGomokuPlayModeDouble) {
        if (_tipInformationLabel.text == TIP_DOUBLE_INFO_PLAYER_BLACK) {
            _tipInformationLabel.text = TIP_DOUBLE_INFO_PLAYER_WHITE;
        } else if (_tipInformationLabel.text == TIP_DOUBLE_INFO_PLAYER_WHITE) {
            _tipInformationLabel.text = TIP_DOUBLE_INFO_PLAYER_BLACK;
        }
    } else if (_gamePlayMode == JSLGomokuPlayModeLAN) {

    }
    
    _tipMarkImageView.image = [UIImage imageNamed:(( _playerType == JSLPlayerTypeBlack)? ICON_GOMOKU_PIECE_BLACK: ICON_GOMOKU_PIECE_WHITE)];
}

#pragma mark 游戏逻辑 - 保存黑白棋子
- (void)saveMove:(JSLMove *)move
{
    if (_playerType == JSLPlayerTypeBlack) {
        _blackMove = move;
    } else {
        _whiteMove = move;
    }
}

#pragma mark 游戏逻辑 - 人工智能对手
- (void)AIPlayWithMove:(JSLMove *)move
{
    _buttonReset.enabled = NO;
    _buttonUndo.enabled = NO;
    _boardView.userInteractionEnabled = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self->_player update:move];
        JSLMove *AIMove = [self->_player getMove];
        [self->_board makeMove:AIMove];
        [self saveMove:AIMove];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_buttonReset.enabled = YES;
            if (self->_blackMove != nil && self->_whiteMove != nil) {
                self->_buttonUndo.enabled = YES;
            }
            
            [self->_boardView insertPieceAtPoint:AIMove.point playerType:AIMove.playerType];
            
            // play move sound
            JSLHomeMenuController *menuController = (JSLHomeMenuController *)self.presentingViewController;
            [menuController.movePieceSoundPlayer play];
            
            if ([self->_board checkWinAtPoint:AIMove.point]) {
                [self handleWin];
                JSLLog(@"WIN %ld", (long)self->_playerType);
            } else {
                [self switchPlayer];
                self->_boardView.userInteractionEnabled = YES;
            }
        });
        
    });
}

#pragma mark 游戏逻辑 - 玩家手动下棋
- (void)moveAtPoint:(JSLPoint)point sendPacketInLAN:(BOOL)sendPacket
{
    if([_board canMoveAtPoint:point]) {
        if (_gamePlayMode == JSLGomokuPlayModeDouble) {
            _buttonUndo.enabled = YES;
        }
        
        JSLMove *move = [[JSLMove alloc] initWithPlayer:_playerType point:point];
        [_board makeMove:move];
        [self saveMove:move];
        
        // Add Piece On the Board
        [_boardView insertPieceAtPoint:point playerType:_playerType];
        
        // Play Move Piece Sound
        JSLHomeMenuController *menuController = (JSLHomeMenuController *)self.presentingViewController;
        [menuController.movePieceSoundPlayer play];
        
        if ([_board checkWinAtPoint:point]) {
            if (_gamePlayMode == JSLGomokuPlayModeLAN && sendPacket == YES) {
                NSDictionary *data = @{ @"i" : @(point.i), @"j" : @(point.j) };
                JSLPacket *packet = [[JSLPacket alloc] initWithData:data type:JSLPacketTypeMove action:JSLPacketActionUnknown];
                [self sendPacket:packet];
            }
            [self handleWin];
        } else {
            [self switchPlayer];
            
            if (_gamePlayMode == JSLGomokuPlayModeSingle) {
                [self AIPlayWithMove:move];
            } else if (_gamePlayMode == JSLGomokuPlayModeLAN && sendPacket == YES) {
                _buttonUndo.enabled = NO;
                NSDictionary *data = @{ @"i" : @(point.i), @"j" : @(point.j) };
                JSLPacket *packet = [[JSLPacket alloc] initWithData:data type:JSLPacketTypeMove action:JSLPacketActionUnknown];
                [self sendPacket:packet];
                _boardView.userInteractionEnabled = NO;
            } else if (_gamePlayMode == JSLGomokuPlayModeLAN && sendPacket == NO) {
                _boardView.userInteractionEnabled = YES;
            }
        }
    }
}

#pragma mark 游戏逻辑 - 验证玩家输赢
- (void)handleWin
{
    [self dismissAlertControllers];
    
    NSString *alertTitle;
    if (_gamePlayMode == JSLGomokuPlayModeSingle) {
        if (_singlePlayerType == _playerType) {
            alertTitle = @" 胜 利 ！";
            _tipInformationLabel.text = @"智商一百八！";
        } else {
            alertTitle = @" 失 败 ！";
            _tipInformationLabel.text = @"电脑端获胜！";
        }
    } else if (_gamePlayMode == JSLGomokuPlayModeDouble) {
        if (_playerType == JSLPlayerTypeBlack) {
            alertTitle = @"黑子胜!";
            _tipInformationLabel.text = @"玩家甲获胜！";
        } else {
            alertTitle = @"白子胜!";
            _tipInformationLabel.text = @"玩家乙获胜！";
        }
    } else if (_gamePlayMode == JSLGomokuPlayModeLAN) {
        if (_playerType == JSLPlayerTypeBlack) {
            alertTitle = @"黑子胜!";
        } else {
            alertTitle = @"白子胜!";
        }
    }
    
    self.resultWinAlertView = [[JSLAlertResultView alloc]
                               initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.80, SCREEN_WIDTH*0.50)
                               tipInfo:alertTitle];
    [self.resultWinAlertView showInWindow];
    
    _blackMove = nil;
    _whiteMove = nil;
    _buttonReset.enabled = YES;
    _buttonUndo.enabled = NO;
    _boardView.userInteractionEnabled = NO;
    
    [self stopTimer];
}

#pragma mark 游戏逻辑 - 游戏重开一局
- (void)handleReset
{
    [self stopTimer];
    [_board initBoard];
    _boardView.userInteractionEnabled = YES;
    if (APPINFORMATION.computerFirstStatus) {
        _playerType = APPINFORMATION.computerBlackStatus ? JSLPlayerTypeBlack : JSLPlayerTypeWhite;
    } else {
        _playerType = APPINFORMATION.computerBlackStatus ? JSLPlayerTypeWhite : JSLPlayerTypeBlack;
    }
    [_boardView reset];
    _buttonUndo.enabled = NO;
    _blackMove = nil;
    _whiteMove = nil;
}

- (void)startTimer
{
    // initialize the timer label
    _timeSecBlack = 0;
    _timeMinBlack = 0;
    _timeSecWhite = 0;
    _timeMinWhite = 0;
    
    NSString* timeNow = [NSString stringWithFormat:@"%02d:%02d", _timeMinBlack, _timeSecBlack];
    
    _timerWhiteLabel.text = timeNow;
    _timerBlackLabel.text = timeNow;
    
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

- (void)stopTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)timerTick:(NSTimer *)timer
{
    if (_playerType == JSLPlayerTypeBlack) {
        _timeSecBlack++;
        if (_timeSecBlack == 60) {
            _timeSecBlack = 0;
            _timeMinBlack ++;
        }
        // Format the string 00:00
        NSString* timeNow = [NSString stringWithFormat:@"%02d:%02d", _timeMinBlack, _timeSecBlack];
        _timerBlackLabel.text= timeNow;
    } else {
        _timeSecWhite++;
        if (_timeSecWhite == 60) {
            _timeSecWhite = 0;
            _timeMinWhite++;
        }
        // Format the string 00:00
        NSString* timeNow = [NSString stringWithFormat:@"%02d:%02d", _timeMinWhite, _timeSecWhite];
        _timerWhiteLabel.text= timeNow;
    }
}

- (void) dismissAlertControllers
{
    {
        [self.resultWinAlertView hideView];
        
        self.resultWinAlertView = nil;
    }
    
    {
        [_waitAlertController dismissViewControllerAnimated:YES completion:nil];
        [_resetWaitAlertController dismissViewControllerAnimated:YES completion:nil];
        [_resetChooseAlertController dismissViewControllerAnimated:YES completion:nil];
        [_resetRejectAlertController dismissViewControllerAnimated:YES completion:nil];
        [_undoWaitAlertController dismissViewControllerAnimated:YES completion:nil];
        [_undoChooseAlertController dismissViewControllerAnimated:YES completion:nil];
        [_undoRejectAlertController dismissViewControllerAnimated:YES completion:nil];
        
        self.waitAlertController = nil;
        self.resetWaitAlertController = nil;
        self.resetChooseAlertController = nil;
        self.resetRejectAlertController = nil;
        self.undoWaitAlertController = nil;
        self.undoChooseAlertController = nil;
        self.undoRejectAlertController = nil;
    }

}

#pragma mark - 棋盘视图代理

#pragma mark JSLCheckerBoardViewDelegate
- (void)boardView:(JSLCheckerBoardView *)boardView didTapOnPoint:(JSLPoint)point
{
    [self moveAtPoint:point sendPacketInLAN:YES];
}


#pragma mark - 联机游戏网络

#pragma mark JSLSocketHostListControllerDelegate
- (void)controller:(JSLSocketHostListController *)controller didJoinGameOnSocket:(GCDAsyncSocket *)socket
{
    self.socket = socket;
    [_socket setDelegate:self];
    _boardView.userInteractionEnabled = NO;
    _isHost = NO;
    
    [_socket readDataWithTimeout:-1 tag:1];
    
}

- (void)controller:(JSLSocketHostListController *)controller didHostGameOnSocket:(GCDAsyncSocket *)socket
{
    self.socket = socket;
    [_socket setDelegate:self];
    _isHost = YES;
    [_socket readDataWithTimeout:-1 tag:1];
}

- (void)shouldDismiss {
    _shouldDismiss = YES;
}

#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)socket didReadData:(NSData *)data withTag:(long)tag
{
    [self parseData:data];
    [socket readDataWithTimeout:-1 tag:1];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)socket withError:(NSError *)error
{
    if (error) {
        JSLLog(@"Socket Did Disconnect with Error %@ with User Info %@.", error, [error userInfo]);
    } else {
        JSLLog(@"Socket Disconnect.");
    }
    
    if (_socket == socket) {
        _socket.delegate = nil;
        _socket = nil;
    }
    [self stopTimer];
    
    [self dismissAlertControllers];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"对方已经断开连接" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - Socket related functions

- (void)sendPacket:(JSLPacket *)packet
{
    // Encode Packet Data
    NSMutableData *packetData = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:packetData];
    [archiver encodeObject:packet forKey:@"packet"];
    [archiver finishEncoding];
    
    // Initialize Buffer
    NSMutableData *buffer = [[NSMutableData alloc] init];
    
    // Fill Buffer
    [buffer appendBytes:packetData.bytes length:packetData.length];
    
    [_socket writeData:buffer withTimeout:-1.0 tag:0];
}

- (void)parseData:(NSData *)data
{
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    JSLPacket *packet = [unarchiver decodeObjectForKey:@"packet"];
    [unarchiver finishDecoding];
    
    if ([packet type] == JSLPacketTypeMove) {
        NSNumber *i = [(NSDictionary *)[packet data] objectForKey:@"i"];
        NSNumber *j = [(NSDictionary *)[packet data] objectForKey:@"j"];
        
        JSLPoint point;
        point.i = i.intValue;
        point.j = j.intValue;
        
        if (_waitAlertController != nil) {
            [_waitAlertController dismissViewControllerAnimated:YES completion:nil];
            self.waitAlertController = nil;
        }
        
        [self moveAtPoint:point sendPacketInLAN:NO];
        if (_blackMove != nil && _whiteMove != nil && ![_board checkWinAtPoint:point]) {
            _buttonUndo.enabled = YES;
        }
        
        
    } else if ([packet type] == JSLPacketTypeReset) {
        if ([packet action] == JSLPacketActionResetRequest) {
            
            [self dismissAlertControllers];
            
            self.resetChooseAlertController = [UIAlertController alertControllerWithTitle:@"对方请求重开" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionAgree = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                JSLPacket *packet = [[JSLPacket alloc] initWithData:nil type:JSLPacketTypeReset action:JSLPacketActionResetAgree];
                [self sendPacket:packet];
                [self handleReset];
                [self startGameInLANMode];
            }];
            
            UIAlertAction *actionReject = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                JSLPacket *packet = [[JSLPacket alloc] initWithData:nil type:JSLPacketTypeReset action:JSLPacketActionResetReject];
                [self sendPacket:packet];
            }];
            
            [_resetChooseAlertController addAction:actionAgree];
            [_resetChooseAlertController addAction:actionReject];
            [self presentViewController:_resetChooseAlertController animated:YES completion:nil];
            
        } else if ([packet action] == JSLPacketActionResetAgree) {
            [self dismissAlertControllers];
            
            [self handleReset];
            [self startGameInLANMode];
            
        } else if ([packet action] == JSLPacketActionResetReject) {
            [self dismissAlertControllers];
            
            self.resetRejectAlertController = [UIAlertController alertControllerWithTitle:@"对方拒绝了你的请求" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            [_resetRejectAlertController addAction:action];
            [self presentViewController:_resetRejectAlertController animated:YES completion:nil];
        }
        
    } else if (packet.type == JSLPacketTypeUndo) {
        if (packet.action == JSLPacketActionUndoRequest) {
            [self dismissAlertControllers];
            
            self.undoChooseAlertController = [UIAlertController alertControllerWithTitle:@"对方请求悔棋" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionAgree = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                JSLPacket *packet = [[JSLPacket alloc] initWithData:nil type:JSLPacketTypeUndo action:JSLPacketActionUndoAgree];
                [self sendPacket:packet];
                [self->_board undoMove:self->_blackMove];
                [self->_board undoMove:self->_whiteMove];
                [self->_boardView removeImageWithCount:2];
                self->_blackMove = nil;
                self->_whiteMove = nil;
                self->_buttonUndo.enabled = NO;
            }];
            
            UIAlertAction *actionReject = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                JSLPacket *packet = [[JSLPacket alloc] initWithData:nil type:JSLPacketTypeUndo action:JSLPacketActionUndoReject];
                [self sendPacket:packet];
            }];
            
            [_undoChooseAlertController addAction:actionAgree];
            [_undoChooseAlertController addAction:actionReject];
            [self presentViewController:_undoChooseAlertController animated:YES completion:nil];
        } else if (packet.action == JSLPacketActionUndoAgree) {
            [self dismissAlertControllers];
            
            [_board undoMove:_blackMove];
            [_board undoMove:_whiteMove];
            [_boardView removeImageWithCount:2];
            _blackMove = nil;
            _whiteMove = nil;
            _buttonUndo.enabled = NO;
        } else if (packet.action == JSLPacketActionUndoReject) {
            [self dismissAlertControllers];
            
            self.undoRejectAlertController = [UIAlertController alertControllerWithTitle:@"对方拒绝了你的请求" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            [_undoRejectAlertController addAction:action];
            [self presentViewController:_undoRejectAlertController animated:YES completion:nil];
        }
    }
}

#pragma mark -
#pragma mark Getter/Setter

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _backgroundImageView.image = [UIImage imageNamed:[self getBackgroundImageUrl]];
        _backgroundImageView.userInteractionEnabled = YES;
    }
    return _backgroundImageView;
}

- (NSString *)getBackgroundImageUrl
{
    if (IS_IPHONE_4_OR_LESS) {
        return @"icon_background_game_4";
    } else if (IS_IPHONE_5) {
        return @"icon_background_game_5";
    } else if (IS_IPHONE_6) {
        return @"icon_background_game_8";
    } else if (IS_IPHONE_6P) {
        return @"icon_background_game_8plus";
    } else if (IS_IPHONE_XS) {
        return @"icon_background_game_xs";
    } else if (IS_IPHONE_XSMAX) {
        return @"icon_background_game_xsmax";
    }
    return @"icon_background_game_8";
}

- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _headImageView.image = [UIImage imageNamed:@"icon_board_head"];
        _headImageView.userInteractionEnabled = YES;
    }
    return _headImageView;
}

- (UIImageView *)tipMarkImageView
{
    if (!_tipMarkImageView) {
        _tipMarkImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _tipMarkImageView.image = [UIImage imageNamed:ICON_GOMOKU_PIECE_BLACK];
    }
    return _tipMarkImageView;
}

- (JSLCheckerBoardView *)boardView
{
    if (!_boardView) {
        _boardView = [[JSLCheckerBoardView alloc] initWithFrame:CGRectZero];
    }
    return _boardView;
}

- (UIButton *)buttonBack
{
    if (!_buttonBack) {
        CGFloat margin = JSL_AUTOSIZING_MARGIN(MARGIN);
        _buttonBack = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonBack addTarget:self action:@selector(pressButtonBackAction:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonBack addBorderWithColor:[UIColor blackColor] cornerRadius:margin*0.5f andWidth:1.0f];
        [_buttonBack setImage:[UIImage imageNamed:@"icon_button_return"] forState:UIControlStateNormal];
        [_buttonBack setImage:[UIImage imageNamed:@"icon_button_return_highlighted"] forState:UIControlStateHighlighted];
        [_buttonBack setImageEdgeInsets:UIEdgeInsetsMake(margin*0.75f, margin*2.0f, margin*0.75f, margin*2.0f)];
    }
    return _buttonBack;
}

- (UIButton *)buttonReset
{
    if (!_buttonReset) {
        CGFloat margin = JSL_AUTOSIZING_MARGIN(MARGIN);
        _buttonReset = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonReset addTarget:self action:@selector(pressButtonResetAction:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonReset addBorderWithColor:[UIColor blackColor] cornerRadius:margin*0.5f andWidth:1.0f];
        [_buttonReset setImage:[UIImage imageNamed:@"icon_button_reset"] forState:UIControlStateNormal];
        [_buttonReset setImage:[UIImage imageNamed:@"icon_button_reset_highlighted"] forState:UIControlStateHighlighted];
        [_buttonReset setImageEdgeInsets:UIEdgeInsetsMake(margin*0.8f, margin*2.0f, margin*0.8f, margin*2.0f)];
    }
    return _buttonReset;
}

- (UIButton *)buttonUndo
{
    if (!_buttonUndo) {
        CGFloat margin = JSL_AUTOSIZING_MARGIN(MARGIN);
        _buttonUndo = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonUndo addTarget:self action:@selector(pressButtonUndoAction:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonUndo addBorderWithColor:[UIColor blackColor] cornerRadius:margin*0.5f andWidth:1.0f];
        [_buttonUndo setImage:[UIImage imageNamed:@"icon_button_undo"] forState:UIControlStateNormal];
        [_buttonUndo setImage:[UIImage imageNamed:@"icon_button_undo_highlighted"] forState:UIControlStateHighlighted];
        [_buttonUndo setImageEdgeInsets:UIEdgeInsetsMake(margin*0.8f, margin*2.0f, margin*0.8f, margin*2.0f)];
    }
    return _buttonUndo;
}

- (JSLPlayerMarkView *)playerAMarkView
{
    if (!_playerAMarkView) {
        CGFloat font_width = [@"暂位符" widthWithFont:[UIFont boldSystemFontOfSize:JSL_AUTOSIZING_FONT_SCALE(18.0f)] constrainedToHeight:MAXFLOAT];
        CGFloat mark_height = JSL_AUTOSIZING_WIDTH(30.0f);
        CGFloat mark_width = mark_height*1.7f + font_width;
        _playerAMarkView = [[JSLPlayerMarkView alloc] initWithFrame:CGRectMake(0, 0, mark_width, mark_height)];
        [_playerAMarkView setBackgroundColor:[UIColor clearColor]];
        // [_playerAMarkView addBorderWithColor:[UIColor blackColor] cornerRadius:mark_height*0.2f andWidth:1.0];
    }
    return _playerAMarkView;
}

- (JSLPlayerMarkView *)playerBMarkView
{
    if (!_playerBMarkView) {
        CGFloat font_width = [@"暂位符" widthWithFont:[UIFont boldSystemFontOfSize:JSL_AUTOSIZING_FONT_SCALE(18.0f)] constrainedToHeight:MAXFLOAT];
        CGFloat mark_height = JSL_AUTOSIZING_WIDTH(30.0f);
        CGFloat mark_width = mark_height*1.7f + font_width;
        _playerBMarkView = [[JSLPlayerMarkView alloc] initWithFrame:CGRectMake(0, 0, mark_width, mark_height)];
        [_playerBMarkView setBackgroundColor:[UIColor clearColor]];
        // [_playerBMarkView addBorderWithColor:[UIColor blackColor] cornerRadius:mark_height*0.2f andWidth:1.0];
    }
    return _playerBMarkView;
}

- (UILabel *)tipInformationLabel
{
    if (!_tipInformationLabel) {
        _tipInformationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_tipInformationLabel setTextColor:[UIColor blackColor]];
        [_tipInformationLabel setFont:[UIFont boldSystemFontOfSize:JSL_AUTOSIZING_FONT(18.0f)]];
    }
    return _tipInformationLabel;
}

- (UILabel *)timerBlackLabel
{
    if (!_timerBlackLabel) {
        _timerBlackLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timerBlackLabel setHidden:YES];
        [_timerBlackLabel setTextColor:[UIColor blackColor]];
        [_timerBlackLabel setTextAlignment:NSTextAlignmentLeft];
        [_timerBlackLabel setFont:[UIFont fontWithName:@"NotoMono" size:JSL_AUTOSIZING_FONT_SCALE(18.0f)]];
    }
    return _timerBlackLabel;
}

- (UILabel *)timerWhiteLabel
{
    if (!_timerWhiteLabel) {
        _timerWhiteLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timerWhiteLabel setHidden:YES];
        [_timerWhiteLabel setTextColor:[UIColor blackColor]];
        [_timerWhiteLabel setTextAlignment:NSTextAlignmentRight];
        [_timerWhiteLabel setFont:[UIFont fontWithName:@"NotoMono" size:JSL_AUTOSIZING_FONT_SCALE(18.0f)]];
    }
    return _timerWhiteLabel;
}

- (UILabel *)titleGomokuLabel
{
    if (!_titleGomokuLabel) {
        // UIFont *titleGomokuFont = [UIFont fontWithName:@"~Qx~AOS" size:JSL_AUTOSIZING_FONT_SCALE(50)];
        UIFont *titleGomokuFont = [UIFont fontWithName:@"STCaiyun" size:JSL_AUTOSIZING_FONT_SCALE(50)];
        _titleGomokuLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleGomokuLabel setFont:titleGomokuFont];
        [_titleGomokuLabel setTextColor:[UIColor blackColor]];
        [_titleGomokuLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleGomokuLabel setText:APPINFORMATION_NAME];
    }
    return _titleGomokuLabel;
}

@end

