//
//  LavionsInterface.h
//  mgservice
//
//  Created by 罗禹 on 16/3/21.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "YWNetWork.h"
#import "Parser.h"
#import "Util.h"

/**
 *  @abstract 数据接口代理
 */
@protocol DataInterfaceDelegate <NSObject>

@required

/**
 *  @abstract 派发成功数据
 */
- (void)pushResponseResultsFinished:(NSString *)ident responseCode:(NSString*)code withMessage:(NSString*)msg andData:(NSMutableArray*)datas;

/**
 *  @abstract 派发失败数据
 */
- (void)pushResponseResultsFailed:(NSString *)ident responseCode:(NSString *)code withMessage:(NSString *)msg;

@optional

/**
 *  @abstract 发起联网请求
 */
- (void)sendRequest;

@end

typedef enum NetWorkPUDType {
    DefaultPUDType,
    SmallPUDType,
} NetWorkPUDType;

/**
 *  @abstract 网络接口封装类。在这个类里，需要实现BaseInterface的代理来处理网络请求成功或者失败后的具体行为。
 */
@interface LavionsInterface : YWNetWork
{
    NSString* requestType;
    NSMutableDictionary* bakParams;
    NSString* bakRhead;
    NSMutableDictionary* bakHead;
    NSString* bakUrl;
    NSString* bakViewIdent;
    int index;
}

/**
 *  @abstract 带有一个数据接口代理
 */
@property (nonatomic,assign) id<DataInterfaceDelegate> delegate;

/**
 *  @abstract 接口标示
 */
@property (nonatomic,copy) NSString* viewIdent;

/**
 *  @abstract 封装http请求头 发起网络请求 json格式
 *  @param params 请求参数，以key－value对的格式提供（字典）
 *  @param viewid 接口标示
 *  @param rhead 标志使用http或https
 *  @param ByUser 是否是用户主动刷新数据
 *  @param PUDType 网络加载符号的样式
 */
- (void)getContent:(NSMutableDictionary*)params
         withUrlId:(NSString*)viewid
      withUrlRhead:(NSString*)rhead
        withByUser:(BOOL)byUser
           withPUD:(NetWorkPUDType)PUDType;

/**
 *  @abstract 封装http请求头 发起网络请求 xml格式
 *  @param params 请求参数，以key－value对的格式提供（字典）
 *  @param viewid 接口标示
 */
- (void)getXml:(NSMutableDictionary*)params :(NSString*)viewid;

/**
 *  @abstract 获取微信接口信息
 *  @param params 请求参数，以key－value对的格式提供（字典）
 *  @param viewid 接口标示
 */
- (void)getWXContent:(NSMutableDictionary*)params :(NSString*)viewid;

/**
 *  @abstract 发送信息到微信接口
 *  @param params 请求参数，以key－value对的格式提供（字典）
 *  @param viewid 接口标示
 */
- (void)postWXContent:(NSMutableDictionary*)params :(NSString*)viewid;

/**
 *  @abstract 刷新请求
 */
- (void)refurbish;

@end
