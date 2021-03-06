
#import "JSLSysUserDefaults+Properties.h"

@implementation JSLSysUserDefaults (Properties)

@dynamic token;
@dynamic userId;
@dynamic userName;
@dynamic nickName;
@dynamic appversion;

@dynamic difficulty;
@dynamic checkerBoardSize;
@dynamic backgrondMusicStatus;
@dynamic movePieceSoundStatus;
@dynamic computerFirstStatus;
@dynamic computerBlackStatus;

@dynamic loginStatus;


- (NSDictionary *)setupDefaults
{
    // 设置默认值
    return @{
                @"token": @"",
                @"userId": [NSNumber numberWithInt:0],
                @"userName": @"user_name_default",
                @"appversion": @"v 1.0.0",
             
                @"difficulty": [NSNumber numberWithInteger:0],
                @"checkerBoardSize": [NSNumber numberWithInteger:14],
                @"backgrondMusicStatus": [NSNumber numberWithBool:YES],
                @"movePieceSoundStatus": [NSNumber numberWithBool:YES],
                @"computerFirstStatus": [NSNumber numberWithBool:YES],
                @"computerBlackStatus": [NSNumber numberWithBool:YES],
                
                @"loginStatus": [NSNumber numberWithBool:NO]
             };
}

- (NSDictionary *)setupDefaultsOfProperties
{
    // 设置默认值
    return @{
             
             };
}

- (NSString *)suitName
{
    // 自定义分类存储文件名称，默认为 Bundle Identifier
    return @"jsl.module.devkit.userdefaults";
}

- (NSString *)transformKey:(NSString *)key
{
    // NSUserDefaults 中的键值是与你给的键值一样的，如果你需要加点前缀用以标注，用这个方法 transformKey: 即可
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[key substringToIndex:1] uppercaseString]];
    return [NSString stringWithFormat:@"JSLUserDefault%@", key];
}


@end
