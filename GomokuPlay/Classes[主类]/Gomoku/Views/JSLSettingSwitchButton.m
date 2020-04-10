
#import "JSLSettingSwitchButton.h"


@interface JSLSettingSwitchButton ()
{
    BOOL loaded;
}
@end


@implementation JSLSettingSwitchButton

@synthesize checked = _checked;
@synthesize disabled = _disabled;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed:self.checked ? @"icon_setting_check_selected" : @"icon_setting_check_normal"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    if(self.disabled) {
        self.userInteractionEnabled = FALSE;
        self.alpha = 0.7f;
    } else {
        self.userInteractionEnabled = TRUE;
        self.alpha = 1.0f;
    }
}


- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self setChecked:!self.checked];
    return TRUE;
}

- (void)setChecked:(BOOL)boolValue
{
    _checked = boolValue;
    [self setNeedsDisplay];
}

- (void)setDisabled:(BOOL)boolValue
{
    _disabled = boolValue;
    [self setNeedsDisplay];
}

@end
