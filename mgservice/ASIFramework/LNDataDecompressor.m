

#import "LNDataDecompressor.h"
#import "LNHTTPRequest.h"

#define DATA_CHUNK_SIZE 262144 

@interface LNDataDecompressor ()
+ (NSError *)inflateErrorWithCode:(int)code;
@end;

@implementation LNDataDecompressor

+ (id)decompressor
{
	LNDataDecompressor *decompressor = [[[self alloc] init] autorelease];
	[decompressor setupStream];
	return decompressor;
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

	zStream.zalloc = Z_NULL;
	zStream.zfree = Z_NULL;
	zStream.opaque = Z_NULL;
	zStream.avail_in = 0;
	zStream.next_in = 0;
	int status = inflateInit2(&zStream, (15+32));
	if (status != Z_OK) {
		return [[self class] inflateErrorWithCode:status];
	}
	streamReady = YES;
	return nil;
}

- (NSError *)closeStream
{
	if (!streamReady) {
		return nil;
	}

	streamReady = NO;
	int status = inflateEnd(&zStream);
	if (status != Z_OK) {
		return [[self class] inflateErrorWithCode:status];
	}
	return nil;
}

- (NSData *)uncompressBytes:(Bytef *)bytes length:(NSUInteger)length error:(NSError **)err
{
	if (length == 0) return nil;
	
	NSUInteger halfLength = length/2;
	NSMutableData *outputData = [NSMutableData dataWithLength:length+halfLength];

	int status;
	
	zStream.next_in = bytes;
	zStream.avail_in = (unsigned int)length;
	zStream.avail_out = 0;
	
	NSInteger bytesProcessedAlready = zStream.total_out;
	while (zStream.avail_in != 0) {
		
		if (zStream.total_out-bytesProcessedAlready >= [outputData length]) {
			[outputData increaseLengthBy:halfLength];
		}
		
		zStream.next_out = (Bytef*)[outputData mutableBytes] + zStream.total_out-bytesProcessedAlready;
		zStream.avail_out = (unsigned int)([outputData length] - (zStream.total_out-bytesProcessedAlready));
		
		status = inflate(&zStream, Z_NO_FLUSH);
		
		if (status == Z_STREAM_END) {
			break;
		} else if (status != Z_OK) {
			if (err) {
				*err = [[self class] inflateErrorWithCode:status];
			}
			return nil;
		}
	}
	

	[outputData setLength: zStream.total_out-bytesProcessedAlready];
	return outputData;
}


+ (NSData *)uncompressData:(NSData*)compressedData error:(NSError **)err
{
	NSError *theError = nil;
	NSData *outputData = [[LNDataDecompressor decompressor] uncompressBytes:(Bytef *)[compressedData bytes] length:[compressedData length] error:&theError];
	if (theError) {
		if (err) {
			*err = theError;
		}
		return nil;
	}
	return outputData;
}

+ (BOOL)uncompressDataFromFile:(NSString *)sourcePath toFile:(NSString *)destinationPath error:(NSError **)err
{
	NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];

	
	if (![fileManager createFileAtPath:destinationPath contents:[NSData data] attributes:nil]) {
		if (err) {
			*err = [NSError errorWithDomain:NetworkRequestErrorDomain code:LNCompressionError userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Decompression of %@ failed because we were to create a file at %@",sourcePath,destinationPath],NSLocalizedDescriptionKey,nil]];
		}
		return NO;
	}
	
	
	if (![fileManager fileExistsAtPath:sourcePath]) {
		if (err) {
			*err = [NSError errorWithDomain:NetworkRequestErrorDomain code:LNCompressionError userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Decompression of %@ failed the file does not exist",sourcePath],NSLocalizedDescriptionKey,nil]];
		}
		return NO;
	}
	
	UInt8 inputData[DATA_CHUNK_SIZE];
	NSData *outputData;
	NSInteger readLength;
	NSError *theError = nil;
	

	LNDataDecompressor *decompressor = [LNDataDecompressor decompressor];

	NSInputStream *inputStream = [NSInputStream inputStreamWithFileAtPath:sourcePath];
	[inputStream open];
	NSOutputStream *outputStream = [NSOutputStream outputStreamToFileAtPath:destinationPath append:NO];
	[outputStream open];
	
    while ([decompressor streamReady]) {
		
		
		readLength = [inputStream read:inputData maxLength:DATA_CHUNK_SIZE]; 
		
		
		if ([inputStream streamStatus] == NSStreamStatusError) {
			if (err) {
				*err = [NSError errorWithDomain:NetworkRequestErrorDomain code:LNCompressionError userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Decompression of %@ failed because we were unable to read from the source data file",sourcePath],NSLocalizedDescriptionKey,[inputStream streamError],NSUnderlyingErrorKey,nil]];
			}
            [decompressor closeStream];
			return NO;
		}
		
		if (!readLength) {
			break;
		}

		
		outputData = [decompressor uncompressBytes:inputData length:readLength error:&theError];
		if (theError) {
			if (err) {
				*err = theError;
			}
			[decompressor closeStream];
			return NO;
		}
		
		
		[outputStream write:(Bytef*)[outputData bytes] maxLength:[outputData length]];
		
		
		if ([inputStream streamStatus] == NSStreamStatusError) {
            
			if (err) {
				*err = [NSError errorWithDomain:NetworkRequestErrorDomain code:LNCompressionError userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Decompression of %@ failed because we were unable to write to the destination data file at %@",sourcePath,destinationPath],NSLocalizedDescriptionKey,[outputStream streamError],NSUnderlyingErrorKey,nil]];
            }
			[decompressor closeStream];
			return NO;
		}
		
    }
	
	[inputStream close];
	[outputStream close];

	NSError *error = [decompressor closeStream];
	if (error) {
		if (err) {
			*err = error;
		}
		return NO;
	}

	return YES;
}


+ (NSError *)inflateErrorWithCode:(int)code
{
	return [NSError errorWithDomain:NetworkRequestErrorDomain code:LNCompressionError userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Decompression of data failed with code %i",code],NSLocalizedDescriptionKey,nil]];
}

@synthesize streamReady;
@end
