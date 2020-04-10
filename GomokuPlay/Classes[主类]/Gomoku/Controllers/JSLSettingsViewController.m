#import "JSLSettingsViewController.h"
#import "JSLSettingSwitchButton.h"

@interface JSLSettingsViewController ()
@property (nonatomic, strong) UIImageView *backgroundImageView;
@end

@implementation JSLSettingsViewController


#pragma mark -
#pragma mark 事件处理 - 背景音乐
- (void)pressButtonSwictchMusicAction:(JSLSettingSwitchButton *)button
{
    // 背景音乐
    APPINFORMATION.backgrondMusicStatus = button.checked;
    JSLHomeMenuController *menuController = (JSLHomeMenuController *)self.presentingViewController;
    if (button.checked) {
        [menuController.backgrondMusicPlayer play];
    } else {
        [menuController.backgrondMusicPlayer pause];
        menuController.backgrondMusicPlayer.currentTime = 0;
    }
    
    // 下棋声音
    /*
    APPINFORMATION.movePieceSoundStatus = button.checked;
    JSLHomeMenuController *menuController = (JSLHomeMenuController *)self.presentingViewController;
    if (button.checked) {
        menuController.movePieceSoundPlayer.volume = 1;
    } else {
        menuController.movePieceSoundPlayer.volume = 0;
    }
    */
}

#pragma mark 事件处理 - 电脑先手
- (void)pressButtonSwictchComputerFirstAction:(JSLSettingSwitchButton *)button
{
    APPINFORMATION.computerFirstStatus = button.checked;
}

#pragma mark 事件处理 - 电脑黑子
- (void)pressButtonSwictchComputerBlackAction:(JSLSettingSwitchButton *)button
{
    APPINFORMATION.computerBlackStatus = button.checked;
}

#pragma mark 事件处理 - 选择等级
- (void)pressButtonChoiceDifficultyAction:(UIButton *)button
{
    // APPINFORMATION.difficulty = [NSNumber numberWithInteger:sender.selectedSegmentIndex];
}

#pragma mark 事件处理 - 返回主页
- (void)pressButtonReturnBackHomeAction:(JSLSettingSwitchButton *)button
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark -
#pragma mark 视图生命周期（加载视图）
- (void)viewDidLoad
{
    [super viewDidLoad];

    // 控件大小
    CGFloat margin = JSL_AUTOSIZING_MARGIN(MARGIN);
    
    // 背景图片
    {
        // 尺寸大小
        CGFloat button_width = JSL_AUTOSIZING_WIDTH(300.0f);
        CGFloat button_height = JSL_AUTOSIZING_WIDTH(55.0f);
        CGFloat button_vertical_margin = JSL_AUTOSIZING_HEIGTH(20.0f);
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
            button_vertical_margin = JSL_AUTOSIZING_HEIGTH_SCALE(30.0f);
        } else if (IS_IPHONE_6P) {
            button_width = JSL_AUTOSIZING_WIDTH_SCALE(280.0f);
            button_height = JSL_AUTOSIZING_WIDTH_SCALE(52.0f);
            button_vertical_margin = JSL_AUTOSIZING_HEIGTH_SCALE(30.0f);
        } else if (IS_IPHONE_XS) {
            button_width = JSL_AUTOSIZING_WIDTH_SCALE(280.0f);
            button_height = JSL_AUTOSIZING_WIDTH_SCALE(52.0f);
            button_vertical_margin = JSL_AUTOSIZING_HEIGTH_SCALE(30.0f);
        } else if (IS_IPHONE_XSMAX) {
            button_width = JSL_AUTOSIZING_WIDTH_SCALE(300.0f);
            button_height = JSL_AUTOSIZING_WIDTH_SCALE(55.0f);
            button_vertical_margin = JSL_AUTOSIZING_HEIGTH_SCALE(30.0f);
        }
        
        // 背景图片
        [self.view addSubview:self.backgroundImageView];
        [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.view.mas_top);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    }

    
    // 基础设置
    {
        JSLLog(@"%@", NSStringFromCGRect(self.view.frame));
        CGFloat buttonExitWidth = JSL_AUTOSIZING_WIDTH_SCALE(188.0f);
        CGFloat buttonExitHeight = JSL_AUTOSIZING_WIDTH_SCALE(55.0f);
        CGFloat settingSwitchWidth = JSL_AUTOSIZING_WIDTH_SCALE(30.0f);
        CGFloat settingSwitchHeight = JSL_AUTOSIZING_WIDTH_SCALE(37.0f);
        CGFloat settingContainerHeight = JSL_AUTOSIZING_WIDTH_SCALE(60.0f);
        if (IS_IPHONE_4_OR_LESS) {
            buttonExitWidth = JSL_AUTOSIZING_WIDTH_SCALE(153.0f);
            buttonExitHeight = JSL_AUTOSIZING_WIDTH_SCALE(45.0f);
        } else if (IS_IPHONE_5) {
            buttonExitWidth = JSL_AUTOSIZING_WIDTH_SCALE(153.0f);
            buttonExitHeight = JSL_AUTOSIZING_WIDTH_SCALE(45.0f);
        } else if (IS_IPHONE_6) {
            buttonExitWidth = JSL_AUTOSIZING_WIDTH_SCALE(153.0f);
            buttonExitHeight = JSL_AUTOSIZING_WIDTH_SCALE(45.0f);
        } else if (IS_IPHONE_6P) {
            buttonExitWidth = JSL_AUTOSIZING_WIDTH_SCALE(153.0f);
            buttonExitHeight = JSL_AUTOSIZING_WIDTH_SCALE(45.0f);
        } else if (IS_IPHONE_XS) {
            buttonExitWidth = JSL_AUTOSIZING_WIDTH_SCALE(153.0f);
            buttonExitHeight = JSL_AUTOSIZING_WIDTH_SCALE(45.0f);
        } else if (IS_IPHONE_XSMAX) {
            buttonExitWidth = JSL_AUTOSIZING_WIDTH_SCALE(153.0f);
            buttonExitHeight = JSL_AUTOSIZING_WIDTH_SCALE(45.0f);
        }
        
        // 基础设置 - 标题
        UILabel *baseSettingTitleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            [self.backgroundImageView addSubview:label];
            [label setText:@"游戏设置"];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setTextColor:COLOR_HEXSTRING(@"#9C6F21")];
            [label setFont:[UIFont boldSystemFontOfSize:JSL_AUTOSIZING_FONT(35.0f)]];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.backgroundImageView.mas_left).offset(margin);
                make.right.equalTo(self.backgroundImageView.mas_right).offset(-margin);
                make.top.equalTo(self.backgroundImageView.mas_top).offset(IS_IPHONE_X_OR_GREATER?margin*10.0f:margin*6.0f);
            }];
            
            label;
        });
        baseSettingTitleLabel.mas_key = @"baseSettingTitleLabel";
        
        // 基础设置 - 背景音乐
        UIView *musicSettingView = ({
            // 容器
            UIView *view = [UIView new];
            [self.backgroundImageView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(baseSettingTitleLabel.mas_bottom).offset(margin*4.0f);
                make.left.equalTo(self.backgroundImageView.mas_left).offset(margin*5.0f);
                make.right.equalTo(self.backgroundImageView.mas_right).with.offset(-margin*5.0f);
                make.height.equalTo(@(settingContainerHeight));
            }];
            
            // 图标
            UIImage *titleImage = [UIImage imageNamed:@"icon_setting_music"];
            UIImageView *titleImageView = [UIImageView new];
            [view addSubview:titleImageView];
            [titleImageView setImage:titleImage];
            [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view.mas_left);
                make.centerY.equalTo(view.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(JSL_AUTOSIZING_WIDTH(titleImage.size.width)*0.9f,
                                                 JSL_AUTOSIZING_WIDTH(titleImage.size.height)*0.9f));
            }];
            titleImageView.mas_key = @"titleImageView";
            
            // 按钮
            JSLSettingSwitchButton *swictchButton = ({
                JSLSettingSwitchButton *button = [[JSLSettingSwitchButton alloc] init];
                [button addTarget:self action:@selector(pressButtonSwictchMusicAction:) forControlEvents:UIControlEventTouchUpInside];
                [button setChecked:APPINFORMATION.backgrondMusicStatus];
                [view addSubview:button];
                
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(view.mas_right);
                    make.centerY.equalTo(titleImageView.mas_centerY).offset(-settingSwitchHeight*0.18f);
                    make.size.mas_equalTo(CGSizeMake(settingSwitchWidth, settingSwitchHeight));
                }];
                
                button;
            });
            swictchButton.mas_key = @"swictchButton";
            
            view;
        });
        musicSettingView.mas_key = @"musicSettingView";
        
        // 基础设置 - 电脑先手
        UIView *cmpFirstSettingView = ({
            // 容器
            UIView *view = [UIView new];
            [self.backgroundImageView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(musicSettingView.mas_bottom).offset(margin*1.0f);
                make.left.equalTo(self.backgroundImageView.mas_left).offset(margin*5.0f);
                make.right.equalTo(self.backgroundImageView.mas_right).with.offset(-margin*5.0f);
                make.height.equalTo(@(settingContainerHeight));
            }];
            
            // 图标
            UIImage *titleImage = [UIImage imageNamed:@"icon_setting_computer_first"];
            UIImageView *titleImageView = [UIImageView new];
            [view addSubview:titleImageView];
            [titleImageView setImage:titleImage];
            [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view.mas_left);
                make.centerY.equalTo(view.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(JSL_AUTOSIZING_WIDTH(titleImage.size.width)*0.9f,
                                                 JSL_AUTOSIZING_WIDTH(titleImage.size.height)*0.9f));
            }];
            titleImageView.mas_key = @"titleImageView";
            
            // 按钮
            JSLSettingSwitchButton *swictchButton = ({
                JSLSettingSwitchButton *button = [[JSLSettingSwitchButton alloc] init];
                [button addTarget:self action:@selector(pressButtonSwictchComputerFirstAction:) forControlEvents:UIControlEventTouchUpInside];
                [button setChecked:APPINFORMATION.computerFirstStatus];
                [view addSubview:button];
                
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(view.mas_right);
                    make.centerY.equalTo(titleImageView.mas_centerY).offset(-settingSwitchHeight*0.18f);
                    make.size.mas_equalTo(CGSizeMake(settingSwitchWidth, settingSwitchHeight));
                }];
                
                button;
            });
            swictchButton.mas_key = @"swictchButton";

            view;
        });
        cmpFirstSettingView.mas_key = @"cmpFirstSettingView";
        
        // 基础设置 - 电脑黑子
        UIView *cmpBlackSettingView = ({
            // 容器
            UIView *view = [UIView new];
            [self.backgroundImageView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cmpFirstSettingView.mas_bottom).offset(margin*1.0f);
                make.left.equalTo(self.backgroundImageView.mas_left).offset(margin*5.0f);
                make.right.equalTo(self.backgroundImageView.mas_right).with.offset(-margin*5.0f);
                make.height.equalTo(@(settingContainerHeight));
            }];
            
            // 图标
            UIImage *titleImage = [UIImage imageNamed:@"icon_setting_computer_black"];
            UIImageView *titleImageView = [UIImageView new];
            [view addSubview:titleImageView];
            [titleImageView setImage:titleImage];
            [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view.mas_left);
                make.centerY.equalTo(view.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(JSL_AUTOSIZING_WIDTH(titleImage.size.width)*0.9f,
                                                 JSL_AUTOSIZING_WIDTH(titleImage.size.height)*0.9f));
            }];
            titleImageView.mas_key = @"titleImageView";
            
            // 按钮
            JSLSettingSwitchButton *swictchButton = ({
                JSLSettingSwitchButton *button = [[JSLSettingSwitchButton alloc] init];
                [button addTarget:self action:@selector(pressButtonSwictchComputerBlackAction:) forControlEvents:UIControlEventTouchUpInside];
                [button setChecked:APPINFORMATION.computerBlackStatus];
                [view addSubview:button];
                
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(view.mas_right);
                    make.centerY.equalTo(titleImageView.mas_centerY).offset(-settingSwitchHeight*0.18f);
                    make.size.mas_equalTo(CGSizeMake(settingSwitchWidth, settingSwitchHeight));
                }];
                
                button;
            });
            swictchButton.mas_key = @"swictchButton";
            
            view;
        });
        cmpBlackSettingView.mas_key = @"cmpBlackSettingView";
        
        
        // 返回按钮
        UIButton *returnButton = ({
            UIButton *button = [[UIButton alloc] init];
            [button setBackgroundImage:[UIImage imageNamed:@"icon_setting_return"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"icon_setting_return_highlighted"] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(pressButtonReturnBackHomeAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.backgroundImageView addSubview:button];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.backgroundImageView.mas_centerX);
                make.top.equalTo(cmpBlackSettingView.mas_bottom).offset(margin*4.0f);
                make.size.mas_equalTo(CGSizeMake(buttonExitWidth, buttonExitHeight));
            }];
            
            button;
        });
        returnButton.mas_key = @"returnButton";
    }
}


#pragma mark -
#pragma mark 设置状态栏是否隐藏
- (BOOL)prefersStatusBarHidden
{
    return YES;
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
