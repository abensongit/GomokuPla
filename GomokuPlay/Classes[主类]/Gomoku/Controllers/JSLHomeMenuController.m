
#import "JSLHomeMenuController.h"
#import "JSLCheckerBoardController.h"

NSString * const STR_MOVE_PIECE_SOUND_FILE_NAME = @"sound_move.wav";
NSString * const STR_BACKGROUND_MUSIC_FILE_NAME = @"sound_music.mp3";

NSInteger const BUTTON_TAG_SINGLE = 10001;
NSInteger const BUTTON_TAG_DOUBLE = 10002;
NSInteger const BUTTON_TAG_LANGAME = 10003;
NSInteger const BUTTON_TAG_SETTING = 10004;

@interface JSLHomeMenuController ()
@property (nonatomic, strong) UIButton *buttonSingle;
@property (nonatomic, strong) UIButton *buttonDouble;
@property (nonatomic, strong) UIButton *buttonLanGame;
@property (nonatomic, strong) UIButton *buttonSetting;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@end

@implementation JSLHomeMenuController

#pragma mark -
#pragma mark 事件处理 - 单人游戏
- (void)pressButtonSinglePlayerAction:(UIButton *)button
{
    [self performSegueWithIdentifier:@"playgame" sender:button];
}

#pragma mark 事件处理 - 双人游戏
- (void)pressButtonDoublePlayerAction:(UIButton *)button
{
    [self performSegueWithIdentifier:@"playgame" sender:button];
}

#pragma mark 事件处理 - 联机游戏
- (void)pressButtonLanGamePlayerAction:(UIButton *)button
{
    [self performSegueWithIdentifier:@"playgame" sender:button];
}

#pragma mark 事件处理 - 项目设置
- (void)pressButtonSettingsAction:(UIButton *)button
{
    [self performSegueWithIdentifier:@"settings" sender:button];
}

#pragma mark 事件处理 - 难度选择
- (void)pressButtonSegmentedAction:(NYSegmentedControl *)button
{
    APPINFORMATION.difficulty = [NSNumber numberWithInteger:button.selectedSegmentIndex];
}

#pragma mark 事件处理 - 页面跳转
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)button
{
    if ([segue.identifier isEqualToString:@"playgame"]) {
        JSLCheckerBoardController *checkerBoardController = segue.destinationViewController;
        if (BUTTON_TAG_SINGLE == button.tag) {
            checkerBoardController.gamePlayMode = JSLGomokuPlayModeSingle;
        } else if (BUTTON_TAG_DOUBLE == button.tag) {
            checkerBoardController.gamePlayMode = JSLGomokuPlayModeDouble;
        } else if (BUTTON_TAG_LANGAME == button.tag) {
            checkerBoardController.gamePlayMode = JSLGomokuPlayModeLAN;
        }
    }
}

#pragma mark -
#pragma mark 视图生命周期（加载视图）
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 控件大小
    CGFloat margin = JSL_AUTOSIZING_MARGIN(MARGIN);
    CGFloat button_width = JSL_AUTOSIZING_WIDTH(300.0f);
    CGFloat button_height = JSL_AUTOSIZING_WIDTH(55.0f);
    CGFloat button_vertical_margin = JSL_AUTOSIZING_HEIGTH(30.0f);
    if (IS_IPHONE_4_OR_LESS) {
        button_width = JSL_AUTOSIZING_WIDTH_SCALE(250.0f);
        button_height = JSL_AUTOSIZING_WIDTH_SCALE(45.0f);
        button_vertical_margin = JSL_AUTOSIZING_HEIGTH_SCALE(30.0f);
    } else if (IS_IPHONE_5) {
        button_width = JSL_AUTOSIZING_WIDTH_SCALE(280.0f);
        button_height = JSL_AUTOSIZING_WIDTH_SCALE(52.0f);
        button_vertical_margin = JSL_AUTOSIZING_HEIGTH_SCALE(30.0f);
    } else if (IS_IPHONE_6) {
        button_width = JSL_AUTOSIZING_WIDTH_SCALE(280.0f);
        button_height = JSL_AUTOSIZING_WIDTH_SCALE(52.0f);
        button_vertical_margin = JSL_AUTOSIZING_HEIGTH_SCALE(35.0f);
    } else if (IS_IPHONE_6P) {
        button_width = JSL_AUTOSIZING_WIDTH_SCALE(280.0f);
        button_height = JSL_AUTOSIZING_WIDTH_SCALE(52.0f);
        button_vertical_margin = JSL_AUTOSIZING_HEIGTH_SCALE(35.0f);
    } else if (IS_IPHONE_XS) {
        button_width = JSL_AUTOSIZING_WIDTH_SCALE(280.0f);
        button_height = JSL_AUTOSIZING_WIDTH_SCALE(52.0f);
        button_vertical_margin = JSL_AUTOSIZING_HEIGTH_SCALE(40.0f);
    } else if (IS_IPHONE_XSMAX) {
        button_width = JSL_AUTOSIZING_WIDTH_SCALE(300.0f);
        button_height = JSL_AUTOSIZING_WIDTH_SCALE(55.0f);
        button_vertical_margin = JSL_AUTOSIZING_HEIGTH_SCALE(40.0f);
    }
    
    // 背景图片
    [self.view addSubview:self.backgroundImageView];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    // 按钮 - 项目设置
    [self.backgroundImageView addSubview:self.buttonSetting];
    [self.buttonSetting mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backgroundImageView.mas_centerX);
        make.centerY.equalTo(self.backgroundImageView.mas_centerY).offset(button_vertical_margin*2.5f);
        make.width.mas_equalTo(button_width);
        make.height.mas_equalTo(button_height);
    }];
    
    // 按钮 - 双人游戏
    [self.backgroundImageView addSubview:self.buttonDouble];
    [self.buttonDouble mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backgroundImageView.mas_centerX);
        make.bottom.equalTo(self.buttonSetting.mas_top).offset(-button_vertical_margin);
        make.width.mas_equalTo(button_width);
        make.height.mas_equalTo(button_height);
    }];
    
    // 按钮 - 单人游戏
    [self.backgroundImageView addSubview:self.buttonSingle];
    [self.buttonSingle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backgroundImageView.mas_centerX);
        make.bottom.equalTo(self.buttonDouble.mas_top).offset(-button_vertical_margin);
        make.width.mas_equalTo(button_width);
        make.height.mas_equalTo(button_height);
    }];
    
    // 头部标题
    [self.backgroundImageView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backgroundImageView.mas_centerX);
        make.bottom.equalTo(self.buttonSingle.mas_top).offset(-button_vertical_margin*2.0f);
    }];
    
    // 难度选择
    NYSegmentedControl *difficultyControl = [[NYSegmentedControl alloc] initWithItems:@[@"初  级", @"中  级", @"高  级"]];
    [difficultyControl setSegmentIndicatorInset:0.0f];
    [difficultyControl setTitleTextColor:COLOR_HEXSTRING(@"#854022")];
    [difficultyControl setSelectedTitleTextColor:COLOR_HEXSTRING(@"#FDF9F0")];
    [difficultyControl setBackgroundColor:COLOR_HEXSTRING(@"#BC844B")];
    [difficultyControl setSegmentIndicatorBackgroundColor:COLOR_HEXSTRING(@"#6F3200")];
    //
    [difficultyControl setBorderWidth:2.0f];
    [difficultyControl setCornerRadius:margin*0.5f];
    [difficultyControl setBorderColor:COLOR_HEXSTRING(@"#D1AC7F")];
    [difficultyControl setTitleFont:[UIFont systemFontOfSize:JSL_AUTOSIZING_FONT(16.0f) weight:UIFontWeightSemibold]];
    [difficultyControl setSelectedTitleFont:[UIFont systemFontOfSize:JSL_AUTOSIZING_FONT(16.0f) weight:UIFontWeightSemibold]];
    //
    [difficultyControl setSegmentIndicatorInset:2.0f];
    [difficultyControl setSegmentIndicatorBorderWidth:0.0f];
    [difficultyControl setSegmentIndicatorBorderColor:COLOR_HEXSTRING(@"#440000")];
    [difficultyControl.widthAnchor constraintEqualToConstant:button_width*0.85].active = YES;
    [difficultyControl.heightAnchor constraintEqualToConstant:JSL_AUTOSIZING_WIDTH_SCALE(35.0f)].active = YES;
    //
    [difficultyControl setSelectedSegmentIndex:APPINFORMATION.difficulty.integerValue animated:NO];
    [difficultyControl addTarget:self action:@selector(pressButtonSegmentedAction:) forControlEvents:UIControlEventValueChanged];
    [self.backgroundImageView addSubview:difficultyControl];
    [difficultyControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backgroundImageView.mas_centerX);
        make.bottom.equalTo(self.backgroundImageView.mas_bottom).offset(-(IS_IPHONE_X_OR_GREATER?margin*6.0f:margin*3.0f));
    }];
    
    // 初始化背景音乐
    [self initPlayers];
}

- (void)initPlayers
{
    // 背景音乐
    _backgrondMusicPlayer = [self playerWithFile:STR_BACKGROUND_MUSIC_FILE_NAME];
    _backgrondMusicPlayer.numberOfLoops = -1;
    if (APPINFORMATION.backgrondMusicStatus) {
        [_backgrondMusicPlayer play];
    }
    // 棋子声音
    _movePieceSoundPlayer = [self playerWithFile:STR_MOVE_PIECE_SOUND_FILE_NAME];
}

- (AVAudioPlayer *)playerWithFile:(NSString *)file
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:file ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [player prepareToPlay];
    return player;
}

#pragma mark -
#pragma mark 设置状态栏是否隐藏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark -
#pragma mark Getter/Setter

- (UIButton *)buttonSingle
{
    if (!_buttonSingle) {
        _buttonSingle = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonSingle setTag:BUTTON_TAG_SINGLE];
        [_buttonSingle setImage:[UIImage imageNamed:@"icon_btn_single"] forState:UIControlStateNormal];
        [_buttonSingle setImage:[UIImage imageNamed:@"icon_btn_single_highlighted"] forState:UIControlStateHighlighted];
        [_buttonSingle addTarget:self action:@selector(pressButtonSinglePlayerAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonSingle;
}

- (UIButton *)buttonDouble
{
    if (!_buttonDouble) {
        _buttonDouble = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonDouble setTag:BUTTON_TAG_DOUBLE];
        [_buttonDouble setImage:[UIImage imageNamed:@"icon_btn_double"] forState:UIControlStateNormal];
        [_buttonDouble setImage:[UIImage imageNamed:@"icon_btn_double_highlighted"] forState:UIControlStateHighlighted];
        [_buttonDouble addTarget:self action:@selector(pressButtonDoublePlayerAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonDouble;
}

- (UIButton *)buttonLanGame
{
    if (!_buttonLanGame) {
        _buttonLanGame = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonLanGame setTag:BUTTON_TAG_LANGAME];
        [_buttonLanGame setImage:[UIImage imageNamed:@"icon_btn_lan_game"] forState:UIControlStateNormal];
        [_buttonLanGame setImage:[UIImage imageNamed:@"icon_btn_lan_game_highlighted"] forState:UIControlStateHighlighted];
        [_buttonLanGame addTarget:self action:@selector(pressButtonLanGamePlayerAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonLanGame;
}

- (UIButton *)buttonSetting
{
    if (!_buttonSetting) {
        _buttonSetting = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonSetting setTag:BUTTON_TAG_SETTING];
        [_buttonSetting setImage:[UIImage imageNamed:@"icon_btn_settings"] forState:UIControlStateNormal];
        [_buttonSetting setImage:[UIImage imageNamed:@"icon_btn_settings_highlighted"] forState:UIControlStateHighlighted];
        [_buttonSetting addTarget:self action:@selector(pressButtonSettingsAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonSetting;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        UIFont *titleGomokuFont = [UIFont fontWithName:@"~Qx~AOS" size:JSL_AUTOSIZING_FONT_SCALE(55)];
        //UIFont *titleGomokuFont = [UIFont fontWithName:@"STCaiyun" size:JSL_AUTOSIZING_FONT_SCALE(65)];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setFont:titleGomokuFont];
        [_titleLabel setTextColor:COLOR_HEXSTRING(@"#AE763A")];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setText:APPINFORMATION_NAME];
    }
    return _titleLabel;
}

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
        return @"icon_background_image_4";
    } else if (IS_IPHONE_5) {
        return @"icon_background_image_5";
    } else if (IS_IPHONE_6) {
        return @"icon_background_image_8";
    } else if (IS_IPHONE_6P) {
        return @"icon_background_image_8plus";
    } else if (IS_IPHONE_XS) {
        return @"icon_background_image_xs";
    } else if (IS_IPHONE_XSMAX) {
        return @"icon_background_image_xsmax";
    }
    return @"icon_background_image_8";
}

@end


