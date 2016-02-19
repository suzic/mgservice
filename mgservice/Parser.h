
#import <Foundation/Foundation.h>
#import "Util.h"
#import "MySingleton.h"

@interface Parser : NSObject

- (NSMutableArray*)parser:(NSString*)ident fromData:(NSData*)dict;

@end
