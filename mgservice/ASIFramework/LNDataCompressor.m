

#import "LNDataCompressor.h"
#import "LNHTTPRequest.h"

#define DATA_CHUNK_SIZE 262144 // 压缩数据的大小
#define COMPRESSION_AMOUNT Z_DEFAULT_COMPRESSION

@interface LNDataCompressor ()
+ (NSError *)deflateErrorWithCode:(int)code;
@end

@implementation LNDataCompressor

+ (id)compressor
{
	LNDataCompressor *compressor = [[[self alloc] init] autorelease];
	[compressor setupStream];
	return compressor;
}

- (void)dealloc
{
	if (streamReady) {
		[self closeStream];
	}
	[super dealloc];
}

- (NSError *)setupStream
{
	if (streamReady) {
		return nil;
	}
	// 创建流
	zStream.zalloc = Z_NULL;
	zStream.zfree = Z_NULL;
	zStream.opaque = Z_NULL;
	zStream.avail_in = 0;
	zStream.next_in = 0;
	int status = deflateInit2(&zStream, COMPRESSION_AMOUNT, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY);
	if (status != Z_OK) {
		return [[self class] deflateErrorWithCode:status];
	}
	streamReady = YES;
	return nil;
}

- (NSError *)closeStream
{
	if (!streamReady) {
		return nil;
	}
	// 关闭流
	streamReady = NO;
	int status = deflateEnd(&zStream);
	if (status != Z_OK) {
		return [[self class] deflateErrorWithCode:status];
	}
	return nil;
}

- (NSData *)compressBytes:(Bytef *)bytes length:(NSUInteger)length error:(NSError **)err shouldFinish:(BOOL)shouldFinish
{
	if (length == 0) return nil;
	
	NSUInteger halfLength = length/2;
	
	//创建被压缩数据长度一半的内存空间准备存储压缩的数据
	NSMutableData *outputData = [NSMutableData dataWithLength:length/2]; 
	
	int status;
	
	zStream.next_in = bytes;
	zStream.avail_in = (unsigned int)length;
	zStream.avail_out = 0;

	NSInteger bytesProcessedAlready = zStream.total_out;
	while (zStream.avail_out == 0) {
		
		if (zStream.total_out-bytesProcessedAlready >= [outputData length]) {
			[outputData increaseLengthBy:halfLength];
		}
		
		zStream.next_out = (Bytef*)[outputData mutableBytes] + zStream.total_out-bytesProcessedAlready;
		zStream.avail_out = (unsigned int)([outputData length] - (zStream.total_out-bytesProcessedAlready));
		status = deflate(&zStream, shouldFinish ? Z_FINISH : Z_NO_FLUSH);
		
		if (status == Z_STREAM_END) {
			break;
		} else if (status != Z_OK) {
			if (err) {
				*err = [[self class] deflateErrorWithCode:status];
			}
			return nil;
		}
	}

	// 设置长度
	[outputData setLength: zStream.total_out-bytesProcessedAlready];
	return outputData;
}


+ (NSData *)compressData:(NSData*)uncompressedData error:(NSError **)err
{
	NSError *theError = nil;
	NSData *outputData = [[LNDataCompressor compressor] compressBytes:(Bytef *)[uncompressedData bytes] length:[uncompressedData length] error:&theError shouldFinish:YES];
	if (theError) {
		if (err) {
			*err = theError;
		}
		return nil;
	}
	return outputData;
}



+ (BOOL)compressDataFromFile:(NSString *)sourcePath toFile:(NSString *)destinationPath error:(NSError **)err
{
	NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];

	// 创建一个目标路径下的空文件
	if (![fileManager createFileAtPath:destinationPath contents:[NSData data] attributes:nil]) {
		if (err) {
			*err = [NSError errorWithDomain:NetworkRequestErrorDomain code:LNCompressionError userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Compression of %@ failed because we were to create a file at %@",sourcePath,destinationPath],NSLocalizedDescriptionKey,nil]];
		}
		return NO;
	}
	
	// 判断文件是否存在
	if (![fileManager fileExistsAtPath:sourcePath]) {
		if (err) {
			*err = [NSError errorWithDomain:NetworkRequestErrorDomain code:LNCompressionError userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Compression of %@ failed the file does not exist",sourcePath],NSLocalizedDescriptionKey,nil]];
		}
		return NO;
	}
	
	UInt8 inputData[DATA_CHUNK_SIZE];
	NSData *outputData;
	NSInteger readLength;
	NSError *theError = nil;
	
	LNDataCompressor *compressor = [LNDataCompressor compressor];
	
	NSInputStream *inputStream = [NSInputStream inputStreamWithFileAtPath:sourcePath];
	[inputStream open];
	NSOutputStream *outputStream = [NSOutputStream outputStreamToFileAtPath:destinationPath append:NO];
	[outputStream open];
	
    while ([compressor streamReady]) {
		
		//从文件读取数据
		readLength = [inputStream read:inputData maxLength:DATA_CHUNK_SIZE];

		// 判断流是否为空
		if ([inputStream streamStatus] == NSStreamStatusError) {
			if (err) {
				*err = [NSError errorWithDomain:NetworkRequestErrorDomain code:LNCompressionError userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Compression of %@ failed because we were unable to read from the source data file",sourcePath],NSLocalizedDescriptionKey,[inputStream streamError],NSUnderlyingErrorKey,nil]];
			}
			[compressor closeStream];
			return NO;
		}
		// 判断是否读取到文件尾
		if (!readLength) {
			break;
		}
		
		//将数据缓存
		outputData = [compressor compressBytes:inputData length:readLength error:&theError shouldFinish:readLength < DATA_CHUNK_SIZE ];
		if (theError) {
			if (err) {
				*err = theError;
			}
			[compressor closeStream];
			return NO;
		}
		
		//输出压缩文件
		[outputStream write:(const uint8_t *)[outputData bytes] maxLength:[outputData length]];
		
		// 捕捉异常
		if ([inputStream streamStatus] == NSStreamStatusError) {
			if (err) {
				*err = [NSError errorWithDomain:NetworkRequestErrorDomain code:LNCompressionError userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Compression of %@ failed because we were unable to write to the destination data file at %@",sourcePath,destinationPath],NSLocalizedDescriptionKey,[outputStream streamError],NSUnderlyingErrorKey,nil]];
            }
			[compressor closeStream];
			return NO;
		}
		
    }
	[inputStream close];
	[outputStream close];

	NSError *error = [compressor closeStream];
	if (error) {
		if (err) {
			*err = error;
		}
		return NO;
	}

	return YES;
}

+ (NSError *)deflateErrorWithCode:(int)code
{
	return [NSError errorWithDomain:NetworkRequestErrorDomain code:LNCompressionError userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Compression of data failed with code %i",code],NSLocalizedDescriptionKey,nil]];
}

@synthesize streamReady;
@end
