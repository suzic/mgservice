//
//  NGLMapView.h
//  Nagrand
//
//  Created by Yongxian Wu on 9/4/14.
//  Copyright (c) 2014 Palmap+ Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Nagrand/NGRLayer.h>
#import <Nagrand/NGRPlanarGraph.h>
#import <Nagrand/NGRTypes.h>


@class NGRCoordinateOffset, NGRFeatureLayer, NGRFeature, NGRMapOptions, NGROverlayer;

/*!
 * @typedef NGRLayerDrawingStatus
 * @brief 绘制layer的状态
 * @constant Begin - （暂时无用）
 * @constant End - （暂时无用）
 * @constant DataPrepare - 准备开始绘制
 * @constant DataComplete - 绘制完成
 */
typedef NS_ENUM(NSInteger, NGRLayerDrawingStatus) {
    Begin = 0,      //（暂时无用）
    End,            //（暂时无用）
    DataPrepare,    //准备开始绘制
    DataComplete    //绘制完成
};

@protocol NGRMapViewDelegate <NSObject>

@optional

/*!
 * @brief 点击mapView的回调
 * @param point - 点击事件的中心点，屏幕坐标
 * @param feature - 选中的feature，如果没有返回空
 */
- (void)touchPoint:(CGPoint)point withFeature:(NGRFeature *)feature;

/*!
 * @brief 双击mapView的回调，用户可以自己实现缩放等事件
 * @param point - 点击事件的中心点，屏幕坐标
 */
- (void)mapViewDoubleTap:(CGPoint)point;

//zoom event
/*!
 * @brief mapView将要缩放时的回调
 * @param mapView - 将要缩放的mapView实例
 */
- (void)mapViewWillBeginZooming:(NGRMapView *)mapView;

/*!
 * @brief mapView正在缩放的回调
 * @param mapView - 正在缩放的mapView实例
 * @param scale - 缩放比例
 */
- (void)mapViewDidZoom:(NGRMapView *)mapView scale:(CGFloat)scale;

/*!
 * @brief mapView结束缩放的回调
 * @param mapView - 结束缩放的mapView实例
 */
- (void)mapViewDidEndZooming:(NGRMapView *)mapView;

//rotate event
/*!
 * @brief mapView将要旋转时的回调
 * @param mapView - 将要旋转的mapView实例
 */
- (void)mapViewWillBeginRotating:(NGRMapView *)mapView;

/*!
 * @brief mapView正在旋转的回调
 * @param mapView - 正在旋转的mapView实例
 * @param rotation - 旋转角度
 */
- (void)mapViewDidRotating:(NGRMapView *)mapView rotation:(CGFloat)rotation;

/*!
 * @brief mapView结束旋转的回调
 * @param mapView - 结束旋转的mapView实例
 */
- (void)mapViewDidEndRotating:(NGRMapView *)mapView;

//move event
/*!
 * @brief mapView将要移动时的回调
 * @param mapView - 将要移动的mapView实例
 */
- (void)mapViewWillBeginMoving:(NGRMapView *)mapView;

/*!
 * @brief mapView正在移动的回调
 * @param mapView - 正在移动的mapView实例
 * @param translation - 移动的距离
 */
- (void)mapViewDidMoving:(NGRMapView *)mapView translation:(CGPoint)translation;

/*!
 * @brief mapView结束移动的回调
 * @param mapView - 结束移动的mapView实例
 */
- (void)mapViewDidEndMoving:(NGRMapView *)mapView;
@end

/*! 
 * @brief 地图渲染引擎的视图类，继承UIView。
 */
@interface NGRMapView : UIView

/*!
 * @brief mapView的代理，主要用于手势的回调
 */
@property (nonatomic, weak)id<NGRMapViewDelegate> delegate;

/*!
 * @brief mapView的mapOptions，用于控制想要打开与关闭的手势, 默认为全部开启
 */
@property (nonatomic, strong)NGRMapOptions *mapOptions;

/*!
 * @brief 取得mapView的坐标偏移，需要在drawPlanarGraph后调用
 */
@property (nonatomic, strong, readonly)NGRCoordinateOffset *coordinateOffset;

/*!
 * @brief 是否开启overlay的碰撞检测
 */
@property (nonatomic, assign)BOOL autoHiddenOverlay;

/*!
 * @brief mapView的本层floorID，注意要在drawPlanarGraph后使用
 */
@property (nonatomic, assign, readonly)NGRID currentID;

/*!
 * @brief 地图与正北的夹角
 */
@property (nonatomic, assign, readonly)CGFloat angleFromNorth;

/*!
 * @brief 当前缩放等级
 */
@property (nonatomic, assign, readonly)NSUInteger zoomLevel;

/*!
 * @brief 当前的俯仰角度
 */
@property (nonatomic, assign, readonly)CGFloat skew;

/*!
 * @brief mapView初始化时地图外包盒与屏幕比例，default is 0.667
 */
@property (nonatomic, assign)CGFloat fitScreenRatio;

/*!
 * @brief 是否合并手势，default is false
 */
@property (nonatomic, assign)BOOL mergeGesture;

/*!
 * @brief 手势是否透过上层view向下传递，default is false
 */
@property (nonatomic, assign)BOOL transferGesture;

/*!
 * @brief 获取当前的fps
 */
@property (nonatomic, readonly)NSInteger fps;

/*!
 * @brief 初始化方法，必须调用此方法初始化，参数不能为空
 * @param frame - view的frame
 * @param name - 给mapView指定name，与lua配置对应
 * @return NGRMapView的实例
 */
- (instancetype)initWithFrame:(CGRect)frame name:(NSString *)name;

/*!
 * @brief 开始渲染
 * @discussion 这个方法需要在drawPlanarGraph之后调用一次，之后可以交给系统自动控制。这个调用会改变MapView的状态。和stop成对出现。
 */
- (void)start;

/*!
 * @brief 停止渲染
 * @discussion 如果当前处在渲染状态，调用这个方法会停止渲染，一本可以由系统去自动控制，如果想要干预这些环节，也可以手动调用这些方法，但是一旦停止渲染后，会导致手势失效，新加入的图层无法完成渲染，所以希望恢复渲染状态，可以调用start()。
 */
- (void)stop;

/*!
 * @brief 渲染一个平面图，会根据这个平面图中的数据层信息，再匹配lua中配置的信息，来完成渲染工作。
 * @param planarGraph - 请确保这个参数是有效的，否则无法完成绘制。
 */
- (void)drawPlanarGraph: (NGRPlanarGraph *)planarGraph;

/*!
 * @brief 还原到初始化的位置与大小
 */
- (void)reset;

/*!
 * @brief 碰撞检测
 */
- (void)doCollisionDetection;

/*!
 * @brief 注册手势，(包括，点击手势，移动手势，旋转手势，2D-3D切换手势，可以通过MapOptions来控制)
 */
- (void)registerGestures;

/*!
 * @brief 设置最大缩放级别，这个方法被弃用了，请使用setMaxZoomLevel
 * @param zoom - 缩放级别
 */
- (void)setMaxZoom:(CGFloat)zoom NS_DEPRECATED_IOS(2_0, 7_0);

/*!
 * @brief 设置最小缩放级别，这个方法被弃用了，请使用setMinZoomLevel
 * @param zoom - 缩放级别
 */
- (void)setMinZoom:(CGFloat)zoom NS_DEPRECATED_IOS(2_0, 7_0);

/*!
 * @brief 设置最大放大等级
 * @param zoomLevel - 缩放等级
 */
- (void)setMaxZoomLevel:(NSUInteger)zoomLevel;

/*!
 * @brief 设置最小缩小等级
 * @param zoomLevel - 缩放等级
 */
- (void)setMinZoomLevel:(NSUInteger)zoomLevel;

/*!
 * @brief 设置最大俯仰角度
 * @param angle - 俯仰角度
 */
- (void)setMaxAngle:(CGFloat)angle;

/*!
 * @brief 设置最小俯仰角度
 * @param angle - 俯仰角度
 */
- (void)setMinAngle:(CGFloat)angle;

/*!
 * @brief 缩放地图
 * @param scale - 缩放的系数，如果是1就是缩放，如果是2，就是放大一倍，0.5就是缩小一倍。
 */
- (void)zoom:(CGFloat)scale;
/*!
 * @brief 缩放地图
 * @param scale - 缩放的系数，如果是1就是缩放，如果是2，就是放大一倍，0.5就是缩小一倍。
 * @param animated - 是否开启动画
 * @param duration - 动画持续事件，单位毫秒
 */
- (void)zoom:(CGFloat)scale animated:(BOOL)animated duration:(NSUInteger)duration;

/*!
 * @brief 移动地图
 * @param translation - 偏移向量
 */
- (void)move:(CGVector)translation;
/*!
 * @brief 移动地图
 * @param translation - 偏移向量
 * @param animated - 是否开启动画
 * @param duration - 动画持续事件，单位毫秒
 */
- (void)move:(CGVector)translation animated:(BOOL)animated duration:(NSUInteger)duration;

/*!
 * @brief 移动地图到指定位置， 地图会缩放到指定的区域
 * @param rect - 指定区域，为世界坐标
 * @param animated - 是否开启动画
 * @param duration - 动画持续事件，单位毫秒
 */
- (void)moveToRect:(CGRect)rect animated:(BOOL)animated duration:(NSUInteger)duration;

/*!
 * @brief 移动到指定的点，地图不会缩放
 * @param point - 中心点，为世界坐标
 * @param animated - 是否开启动画
 * @param duration - 动画持续事件，单位毫秒
 */
- (void)moveToPoint:(CGPoint)point animated:(BOOL)animated duration:(NSUInteger)duration;

/*!
 * @brief 移动到指定的feature中心
 * @param feature - 所要移动到的feature
 * @param animated - 是否开启动画
 * @param duration - 动画持续事件，单位毫秒
 */
- (void)moveToFeature:(NGRFeature *)feature animated:(BOOL)animated duration:(NSUInteger)duration;

/*!
 * @brief 俯仰地图
 * @param angle - 俯仰的角度
 */
- (void)skew:(CGFloat)angle;

/*!
 * @brief 俯仰地图
 * @param angle - 俯仰的角度
 * @param animated - 是否开启动画
 * @param duration - 动画持续事件，单位毫秒
 */
- (void)skew:(CGFloat)angle animated:(BOOL)animated duration:(NSUInteger)duration;

/*!
 * @brief 俯仰到一个角度
 * @param angle - 与水平面的夹角
 */
- (void)skewToAngle:(CGFloat)angle;

/*!
 * @brief 旋转地图
 * @param center - 旋转的中心点
 * @param rotation - 旋转的角度，此角度为弧度
 */
- (void)rotateIn:(CGPoint)center andRotation:(CGFloat)rotation;

/*!
 * @brief 旋转地图
 * @param center - 旋转的中心点
 * @param rotation - 旋转的角度，此角度为弧度
 * @param animated - 是否开启动画
 * @param duration - 动画持续事件，单位毫秒
 */
- (void)rotateIn:(CGPoint)center andRotation:(CGFloat)rotation animated:(BOOL)animated duration:(NSUInteger)duration;

/*!
 * @brief 旋转地图
 * @param center - 旋转的中心点
 * @param angle - 与正北的角度
 */
- (void)rotateIn:(CGPoint)center andAngle:(CGFloat)angle;

/*!
 * @brief 为这个MapView添加一个图层。
 * @param layer -
 */
- (void)addLayer:(NGRFeatureLayer *)layer;

/*!
 * @brief 将一个图层从MapView删除，这样一位这换个图层所包含的内容在地图上也会跟着消失。
 * @param layer -
 */
- (void)removeLayer:(NGRFeatureLayer *)layer;

/*!
 * @brief 通过索引获取featureLayer
 * @param index - 索引，按照绘制顺序
 * @return 搜索到的featureLayer，没有为nil
 */
- (NGRFeatureLayer *)featureLayerAtIndex:(NSUInteger)index;

/*!
 * @brief 通过name搜索featureLayer
 * @param name - featureLayer的name，与lua配置文件对应
 * @return 搜索到的featureLayer，没有为nil
 */
- (NGRFeatureLayer *)featureLayerByName:(NSString *)name;

/*!
 * @brief 通过一个屏幕坐标搜索一个feature
 * @param point - 屏幕坐标
 * @return 搜索到的feature，如果没有返回空
 */
- (NGRFeature *)searchFeatureWithPoint:(CGPoint)point;

/*!
 * @brief 通过一个featureId搜索一个feature
 * @param featureId - featureId
 * @return 搜索到的feature，如果没有返回空
 */
- (NGRFeature *)searchFeatureWithId:(NGRID)featureId;

/*!
 * @brief 添加一个OC层的UIView， overlayer会随地图的移动、缩放自动适配，即overlayer在世界坐标的位置是不变的
 * @param overlayer - 一个UIView
 */
- (void)addOverlayer:(NGROverlayer *)overlayer;

/*!
 * @brief 移除一个OC层的UIView
 * @param overlayer - 一个UIView
 */
- (void)removeOverlayer:(NGROverlayer *)overlayer;

/*!
 * @brief 移除mapView上所有的overlayer
 */
- (void)removeAllOverlayer;

/*!
 * @brief 重新摆放所有overlayer
 */
- (void)resetOverlayers;

/*!
 * @brief 隐藏一个layer上的指定feature
 * @param layerName - layerName
 * @param key - 想要隐藏的feature的key值
 * @param value - 与key对应的value（e.g. key = @"category" 对应的value = @(33042000)）
 * @param isVisible - false为隐藏
 */
- (void)visibleLayerFeature:(NSString *)layerName key:(NSString *)key value:(id)value isVisible:(BOOL)isVisible;

/*!
 * @brief 隐藏一个layer上的所有feature
 * @param layerName - 想要隐藏的layerName
 * @param isVisible - false为隐藏
 */
- (void)visibleAllLayerFeature:(NSString *)layerName isVisible:(BOOL)isVisible;

/*!
 * @brief 通过提供一个屏幕坐标来返回一个这个屏幕坐标下的一个NGRFeature。
 * @param point - 屏幕坐标
 * @return 如果存在，返回一个feature，否则就返回null
 */
- (NGRFeature *)selectFeature:(CGPoint)point;

/*!
 * @brief 通过提供一个屏幕坐标来返回一个地图的世界坐标
 * @param point - 屏幕坐标
 * @return 地图真实的世界坐标
 */
- (CGPoint)getWorldPositionFromScreenPosition:(CGPoint)point;

/*!
 * @brief 通过提供一个世界坐标返回一个屏幕坐标
 * @param point - 世界坐标
 * @return 屏幕坐标
 */
- (CGPoint)getScreenPositionFromWorldPosition:(CGPoint)point;

/*!
 * @brief 通过一个世界距离，来获取屏幕像素的长度
 * @param realDistance - 真实世界距离
 * @return 返回屏幕像素的长度
 */
- (CGFloat)pixelLengthFromRealDistance:(CGFloat)realDistance;

- (void)drawTestGeometry;

@end

//-----------------------------------


/*!
 * @brief mapView的一些可控选项
 * @discussion 目前只有手势的控制
 */
@interface NGRMapOptions : NSObject

/*!
 * @brief 是否允许缩放
 */
@property (nonatomic, assign)BOOL zoomEnabled;//default is true

/*!
 * @brief 是否允许移动
 */
@property (nonatomic, assign)BOOL moveEnabled;//default is true

/*!
 * @brief 是否允许旋转
 */
@property (nonatomic, assign)BOOL rotateEnabled;//default is true

/*!
 * @brief 是否允许俯仰
 */
@property (nonatomic, assign)BOOL skewEnabled;//default is true

/*!
 * @brief 是否允许单击
 */
@property (nonatomic, assign)BOOL sigleTapEnabled;//default is true

/*!
 * @brief 是否允许双击
 */
@property (nonatomic, assign)BOOL doubleTapEnabled;//default is ture

@end

