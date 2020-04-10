
#import "JSLPacket.h"

NSString * const JSLPacketKeyData = @"data";
NSString * const JSLPacketKeyType = @"type";
NSString * const JSLPacketKeyAction = @"piece";

@implementation JSLPacket

#pragma mark - Initializer

- (id)initWithData:(id)data type:(JSLPacketType)type action:(JSLPacketAction)action
{
    self = [super init];
    if (self) {
        self.data = data;
        self.type = type;
        self.action = action;
    }
    return self;
}

#pragma mark - NSCoding Protocol

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.data forKey:JSLPacketKeyData];
    [coder encodeInteger:self.type forKey:JSLPacketKeyType];
    [coder encodeInteger:self.action forKey:JSLPacketKeyAction];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        [self setData:[decoder decodeObjectForKey:JSLPacketKeyData]];
        [self setType:[decoder decodeIntegerForKey:JSLPacketKeyType]];
        [self setAction:[decoder decodeIntegerForKey:JSLPacketKeyAction]];
    }
    
    return self;
}

@end
