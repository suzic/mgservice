

#import <Foundation/Foundation.h>
#import <zlib.h>

@interface LNDataDecompressor : NSObject {
	BOOL streamReady;
	z_stream zStream;
}

+ (id)decompressor;


- (NSData *)uncompressBytes:(Bytef *)bytes length:(NSUInteger)length error:(NSError **)err;

+ (NSData *)uncompressData:(NSData*)compressedData error:(NSError **)err;

+ (BOOL)uncompressDataFromFile:(NSString *)sourcePath toFile:(NSString *)destinationPath error:(NSError **)err;

- (NSError *)setupStream;

- (NSError *)closeStream;

@property (assign, readonly) BOOL streamReady;
@end
