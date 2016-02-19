/**
 压缩
 */

#import <Foundation/Foundation.h>
#import <zlib.h>

@interface LNDataCompressor : NSObject {
	BOOL streamReady;
	z_stream zStream;
}

/*
 构造
 */
+ (id)compressor;

/*
 压缩给定长度的数据
 参数：length 长度
 */
- (NSData *)compressBytes:(Bytef *)bytes length:(NSUInteger)length error:(NSError **)err shouldFinish:(BOOL)shouldFinish;

/*
 压缩数据
 参数：uncompressedData 待压缩的数据
 */
+ (NSData *)compressData:(NSData*)uncompressedData error:(NSError **)err;

/*
 压缩文件
 参数：sourcePath 待压缩文件的文件路径
 */
+ (BOOL)compressDataFromFile:(NSString *)sourcePath toFile:(NSString *)destinationPath error:(NSError **)err;

/*
 创建流
 */
- (NSError *)setupStream;

/*
 关闭流
 */
- (NSError *)closeStream;

@property (assign, readonly) BOOL streamReady;
@end
