
#import <UIKit/UIKit.h>

@class GCDAsyncSocket;

@protocol JSLSocketHostListControllerDelegate;

@interface JSLSocketHostListController : UITableViewController

@property (weak, nonatomic) id<JSLSocketHostListControllerDelegate> delegate;

@end

@protocol JSLSocketHostListControllerDelegate

- (void)controller:(JSLSocketHostListController *)controller didJoinGameOnSocket:(GCDAsyncSocket *)socket;
- (void)controller:(JSLSocketHostListController *)controller didHostGameOnSocket:(GCDAsyncSocket *)socket;
- (void)shouldDismiss;

@end
