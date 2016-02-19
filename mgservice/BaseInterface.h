
#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "MySingleton.h"
#import "JSON.h"
#import "Util.h"

@protocol BaseInterfaceDelegate;

@interface BaseInterface : NSObject<LNHTTPRequestDelegate>

@property (nonatomic, retain) ASIFormDataRequest *request;
@property (nonatomic, retain) NSString *interfaceURL;
@property (nonatomic, retain) NSDictionary *headers;
@property (nonatomic, retain) NSDictionary *bodys;
@property (nonatomic, assign) id<BaseInterfaceDelegate> baseDelegate;

- (void)connect_normal:(NSMutableDictionary*)parameter;
- (void)connect_json:(NSMutableDictionary *)parameter;
- (void)connect_xml:(NSMutableDictionary*)parameter;

@end

/**
 *  @abstract 网络基础接口的代理，需要完成两个必须的方法
 */
@protocol BaseInterfaceDelegate <NSObject>

@required

/**
 *  @abstract 解析返回的结果，该代理在请求顺利完成后调用
 */
- (void)parseResult:(LNHTTPRequest *)request;

/**
 *  @abstract 处理错误信息，该代理在请求访问失败后调用
 */
- (void)requestIsFailed:(NSError *)error;

@end