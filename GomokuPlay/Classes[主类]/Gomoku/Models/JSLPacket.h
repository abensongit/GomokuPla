
#import <Foundation/Foundation.h>

extern NSString * const JSLPacketKeyData;
extern NSString * const JSLPacketKeyType;
extern NSString * const JSLPacketKeyAction;

typedef NS_ENUM(NSInteger, JSLPacketType) {
    JSLPacketTypeUnknown,
    JSLPacketTypeMove,
    JSLPacketTypeReset,
    JSLPacketTypeUndo
};

typedef NS_ENUM(NSInteger, JSLPacketAction) {
    JSLPacketActionUnknown,
    JSLPacketActionResetRequest,
    JSLPacketActionResetAgree,
    JSLPacketActionResetReject,
    JSLPacketActionUndoRequest,
    JSLPacketActionUndoAgree,
    JSLPacketActionUndoReject
};

@interface JSLPacket : NSObject

@property (nonatomic, strong) id data;
@property (nonatomic, assign) JSLPacketType type;
@property (nonatomic, assign) JSLPacketAction action;

- (id)initWithData:(id)data type:(JSLPacketType)type action:(JSLPacketAction)piece;

@end
