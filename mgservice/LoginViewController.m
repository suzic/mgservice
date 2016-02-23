//
//  LoginViewController.m
//  mgservice
//
//  Created by 苏智 on 16/1/28.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<DataInterfaceDelegate,UIAlertViewDelegate>

@property (nonatomic, retain)LavionInterface *netWorkRequest;

@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UIImageView *qrcodeView;

@property (weak, nonatomic) IBOutlet UITextField *account; // 账号

@property (weak, nonatomic) IBOutlet UITextField *passWord; // 密码

@end

@implementation LoginViewController

{
    BOOL _isLogin;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isLogin = NO;
    
    self.qrcodeView.layer.shadowOffset = CGSizeMake(0, 2);
    self.qrcodeView.layer.shadowRadius = 2;
    self.qrcodeView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.qrcodeView.layer.shadowOpacity = 0.5;
    self.qrcodeView.userInteractionEnabled = YES;
    
    self.loginButton.layer.cornerRadius = 4.0f;
    
    [self accessSserverTime];
}

- (void)viewWillAppear:(BOOL)animated
{
    DBWaiterInfor *witerInfo = [[DataManager defaultInstance] getWaiterInfor];
    
    if ([witerInfo.isLogin isEqualToString:@"1"])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 网络请求
// 初始化网络请求
- (LavionInterface *)netWorkRequest
{
    if (_netWorkRequest == nil)
    {
        _netWorkRequest = [[LavionInterface alloc] init];
        _netWorkRequest.delegate = self;
    }
    return _netWorkRequest;
}

// 获取服务器时间
- (void)accessSserverTime
{
    [self.netWorkRequest getContent:nil
                          withUrlId:@URI_MESSAGE_BASETIME
                       withUrlRhead:@REQUEST_HEAD_NORMAL
                         withByUser:YES
                            withPUD:DefaultPUDType];
}

// 服务员状态查询 是否登陆成功
- (void)checkIsLogin
{
    
    DBWaiterInfor *witerInfo = [[DataManager defaultInstance] getWaiterInfor];
    if (witerInfo == nil)
        return;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:
                                   @{@"diviceId": witerInfo.deviceId,@"deviceToken":witerInfo.deviceToken}];
    
    [self.netWorkRequest getContent:params
                          withUrlId:@URI_WAITER_CHECKSTATUS
                       withUrlRhead:@REQUEST_HEAD_NORMAL
                         withByUser:YES
                            withPUD:DefaultPUDType];
}

- (void)pushResponseResultsFinished:(NSString *)ident responseCode:(NSString *)code withMessage:(NSString *)msg andData:(NSMutableArray *)datas
{
    // 获取服务器时间
    if ([ident isEqualToString:@URI_MESSAGE_BASETIME])
    {
        NSString *serverTime = datas[0];
        DBWaiterInfor *witerInfo = [[DataManager defaultInstance] getWaiterInfor];
        witerInfo.deviceId = @"12:34:02:00:00:33";
        witerInfo.deviceToken = @"c4cee031f6e9d9d1e3ffe9da5d7cdc90bc4dbefae0eb4a16cdd262cedf1f8151";
        NSString *erString = [NSString stringWithFormat:@"STR|%@|%@|%@|END",witerInfo.deviceId,witerInfo.deviceToken,serverTime];
        UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:erString] withSize:250.0f];
        UIImage *customQrcode = [self imageBlackToTransparent:qrcode withRed:60.0f andGreen:74.0f andBlue:89.0f];
        self.qrcodeView.image = customQrcode;
        
        _isLogin = YES;
    }
    else if ([ident isEqualToString:@URI_WAITER_CHECKSTATUS])
    {
        DBWaiterInfor *witerInfo = [[DataManager defaultInstance] getWaiterInfor];
        witerInfo.isLogin = @"1";
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)pushResponseResultsFailed:(NSString *)ident responseCode:(NSString *)code withMessage:(NSString *)msg
{

}

#pragma mark - 生成二维码
// 二维码方法
- (CIImage *)createQRForString:(NSString *)qrString
{
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // 创建filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置内容和纠错级别
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // 返回CIImage
    return qrFilter.outputImage;
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - imageToTransparent
void ProviderReleaseData (void *info, const void *data, size_t size)
{
    free((void*)data);
}

- (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue
{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            // change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // context to image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // release
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

#pragma mark - 按钮点击方法
// 点击登录方法
- (IBAction)loginPressed:(id)sender
{
        [self dismissViewControllerAnimated:YES completion:nil];
//    if (_isLogin == YES)
//        [self checkIsLogin];
//    else
//    {
//        UIAlertView *alent = [[UIAlertView alloc] initWithTitle:@"登录失败"
//                                                        message:@"请输入正确的账号密码或重新扫描二维码进行登录"
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil, nil];
//        [alent show];
//    }
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self accessSserverTime];
}

// c4cee031f6e9d9d1e3ffe9da5d7cdc90bc4dbefae0eb4a16cdd262cedf1f8151
@end
