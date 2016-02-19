

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class LNHTTPRequest;

typedef enum _LNAuthenticationType {
	LNStandardAuthenticationType = 0,
    LNProxyAuthenticationType = 1
} LNAuthenticationType;

@interface LNAutorotatingViewController : UIViewController
@end

@interface LNAuthenticationDialog : LNAutorotatingViewController <UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource> {
	LNHTTPRequest *request;
	LNAuthenticationType type;
	UITableView *tableView;
	UIViewController *presentingController;
	BOOL didEnableRotationNotifications;
}
+ (void)presentAuthenticationDialogForRequest:(LNHTTPRequest *)request;
+ (void)dismiss;

@property (retain) LNHTTPRequest *request;
@property (assign) LNAuthenticationType type;
@property (assign) BOOL didEnableRotationNotifications;
@property (retain, nonatomic) UIViewController *presentingController;
@end
