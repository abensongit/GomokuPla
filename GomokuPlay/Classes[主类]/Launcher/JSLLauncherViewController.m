
#import "JSLLauncherViewController.h"

@interface JSLLauncherViewController ()
@property (nonatomic, strong) UIImageView *launcherImageView;
@end

@implementation JSLLauncherViewController

#pragma mark -
#pragma mark 事件处理 - 自动跳过
- (void)doAutoJumpToMainViewController
{
    [self performSegueWithIdentifier:@"homemenu" sender:nil];
}

#pragma mark -
#pragma mark 设置状态栏是否隐藏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark -
#pragma mark 视图生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 显示启动图片
    WEAKSELF(weakSelf);
    UIImageView *launcherImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setImage:[UIImage imageNamed:[self getLauncherImageUrl]]];
        [self.view addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view.mas_top);
            make.left.equalTo(weakSelf.view.mas_left);
            make.bottom.equalTo(weakSelf.view.mas_bottom);
            make.right.equalTo(weakSelf.view.mas_right);
        }];
        
        imageView;
    });
    self.launcherImageView = launcherImageView;
    self.launcherImageView.mas_key = @"launcherImageView";
    
    // 启动页面延时
    __block NSInteger timeOut = 1.0f;
    dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (timeOut <= 0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                // 启动图显示后操作处理
                [weakSelf doAutoJumpToMainViewController];
            });
        } else {
            timeOut--;
        }
    });
    dispatch_resume(timer);
}

- (NSString *)getLauncherImageUrl
{
    if (IS_IPHONE_4_OR_LESS) {
        return @"icon_launcher_image_320480";
    } else if (IS_IPHONE_5) {
        return @"icon_launcher_image_320568";
    } else if (IS_IPHONE_6) {
        return @"icon_launcher_image_375667";
    } else if (IS_IPHONE_6P) {
        return @"icon_launcher_image_414736";
    } else if (IS_IPHONE_XS) {
        return @"icon_launcher_image_375812";
    } else if (IS_IPHONE_XSMAX) {
        return @"icon_launcher_image_414896";
    }
    return @"icon_launcher_image_375667";
}


@end


