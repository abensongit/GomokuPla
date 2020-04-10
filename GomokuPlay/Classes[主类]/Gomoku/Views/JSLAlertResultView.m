
#import "JSLAlertResultView.h"
#import "UIView+TYAlertView.h"

@interface JSLAlertResultView ()

@property (nonatomic, strong) UIButton *buttonExit;
@property (nonatomic, strong) UILabel *contenLabel;

@end

@implementation JSLAlertResultView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self viewDidLoadControls];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self viewDidLoadControls];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame tipInfo:(NSString *)tipInfo
{
    self = [super initWithFrame:frame];
    if (self) {
        _tipInfo = tipInfo;
        [self viewDidLoadControls];
    }
    return self;
}

- (void)viewDidLoadControls
{
    [self setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:self.contenLabel];
    [self.contenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    [self.contenLabel setText:_tipInfo];
    
    [self addSubview:self.buttonExit];
    [self.buttonExit mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat btnSize = JSL_AUTOSIZING_WIDTH_SCALE(40.0f);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.width.mas_equalTo(btnSize);
        make.height.mas_equalTo(btnSize);
    }];
    
}

- (void)pressButtonExitAction:(UIButton *)button
{
    [self hideView];
}


#pragma mark -
#pragma mark Getter/Setter

- (UIButton *)buttonExit
{
    if (!_buttonExit) {
        _buttonExit = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonExit addTarget:self action:@selector(pressButtonExitAction:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonExit setImage:[UIImage imageNamed:@"icon_button_exit"] forState:UIControlStateNormal];
        [_buttonExit setImage:[UIImage imageNamed:@"icon_button_exit"] forState:UIControlStateHighlighted];
    }
    return _buttonExit;
}

- (UILabel *)contenLabel
{
    if (!_contenLabel) {
        UIFont *titleGomokuFont = [UIFont fontWithName:@"STCaiyun" size:JSL_AUTOSIZING_FONT_SCALE(68)];
        _contenLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_contenLabel setFont:titleGomokuFont];
        [_contenLabel setTextColor:[UIColor blackColor]];
        [_contenLabel setTextAlignment:NSTextAlignmentCenter];
        [_contenLabel setUserInteractionEnabled:YES];
        [_contenLabel setTextColor:COLOR_HEXSTRING(@"#F3C783")];
    }
    return _contenLabel;
}

- (void)setTipInfo:(NSString *)tipInfo
{
    _tipInfo = tipInfo;
    [self.contenLabel setText:tipInfo];
}


@end
