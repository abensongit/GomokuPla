
#import "JSLPlayerMarkView.h"

@interface JSLPlayerMarkView ()


@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation JSLPlayerMarkView

- (instancetype)initWithPlayerMarkTitle:(NSString *)title imageUrl:(NSString *)imageUrl
{
    self = [super init];
    if (self) {
        _title = title;
        _imageUrl = imageUrl;
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed:_imageUrl];
    [image drawInRect:CGRectMake(self.frame.size.height*0.25,
                                 self.frame.size.height*0.06,
                                 self.frame.size.height*0.8,
                                 self.frame.size.height*0.8)];

    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.height*1.3f,
                                                                    self.frame.size.height*0.1,
                                                                    self.frame.size.width-self.frame.size.height*1.3f,
                                                                    self.frame.size.height*0.8)];
    [self addSubview:titleLabel];
    [titleLabel setText:_title];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:JSL_AUTOSIZING_FONT(18.0f)]];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self setNeedsDisplay];
}

- (void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    [self setNeedsDisplay];
}

@end

