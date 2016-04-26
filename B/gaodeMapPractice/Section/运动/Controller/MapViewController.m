//
//  MapViewController.m
//  gaodeMapPractice
//
//  Created by lanouhn on 15/5/25.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "MapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchAPI.h>
#import "DataManager.h"

@interface MapViewController ()<MAMapViewDelegate, AMapSearchDelegate>{
    
    MAMapView *myMapView;
    
    //AMapSearchAPI *search;
    
    CLLocation *currentLocation;
    
    UIButton *locationButton;
    
    CLLocationCoordinate2D beforeLocation;//上次定位的坐标,相对的起点
    
    CLLocationCoordinate2D nowLocation;//当前坐标,相对的终点
    
    CLLocationCoordinate2D polylineCoords[2];//点数组
    
    MAPolyline *polyline;//线
    
    BOOL isFirst;
    
    DataManager *datamanager;
    
    NSMutableArray *locationArray;//记录所有点,用来显示记录轨迹
}

//可能有多条线,这里我就用一条, 所以往数组里面添加线的时候下标用的是0
@property (nonatomic, strong) NSMutableArray *overlays;


@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //NSLog(@"%@",[NSBundle mainBundle].bundleIdentifier);
    isFirst = YES;
    
    datamanager = [DataManager shareDataManager];
    
    [self initMapView];
    
    [self initLocationButton];
    
    self.overlays = [@[] mutableCopy];
    
    //添加观察者,收到存储通知,进行对地图截图
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takePhoto:) name:@"takePhoto" object:nil];
    
}

//收到通知,截图给单例
- (void)takePhoto:(NSNotification *)notification{
    //截图范围
    CGRect picRect = myMapView.frame;
    //获取截图
    UIImage *mapPic = [myMapView takeSnapshotInRect:picRect];
    if (mapPic) {
        //将图片转成data存到单例里面
        datamanager.mapPhotoData = UIImagePNGRepresentation(mapPic);
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    myMapView.showsUserLocation = YES;
    myMapView.userTrackingMode = MAUserTrackingModeFollow;
}

- (void)initMapView{
    myMapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    myMapView.delegate = self;
    //罗盘位置
    myMapView.compassOrigin = CGPointMake(myMapView.compassOrigin.x, 70);
    //比例尺位置
    myMapView.scaleOrigin = CGPointMake(myMapView.scaleOrigin.x, 70);
    
    [self.view addSubview:myMapView];
    //MyMapView.showsUserLocation = YES;//YES 为打开定位，NO为关闭定位
}

//设置地图缩放级别,默认是[3-19]
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if (mapView.zoomLevel>17) {
        mapView.zoomLevel=17;
    }else if (mapView.zoomLevel<5){
        mapView.zoomLevel=5;
    }
}

- (void)initLocationButton{
    locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    locationButton.frame = CGRectMake(20, CGRectGetHeight(myMapView.bounds)-100, 40, 40);
    locationButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    locationButton.backgroundColor = [UIColor whiteColor];
    locationButton.layer.cornerRadius = 5;
    
    [locationButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [locationButton setImage:[UIImage imageNamed:@"location_no"] forState:UIControlStateNormal];
    
    [myMapView addSubview:locationButton];
}

- (void)buttonAction {
    //地图跟着位置移动
    if (myMapView.userTrackingMode != MAUserTrackingModeFollow) {
        [myMapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    }
}

- (void)mapView:(MAMapView *)mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated {
    //修改定位按钮状态
    if (mode == MAUserTrackingModeFollow) {
        [locationButton setImage:[UIImage imageNamed:@"location_no"] forState:UIControlStateNormal];
    } else {
        [locationButton setImage:[UIImage imageNamed:@"location_yes"] forState:UIControlStateNormal];
    }
}

//每次更新位置 就会走这个回调
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    
    mapView.showsUserLocation = YES;
    
    NSLog(@"userLocation: %@", userLocation.location);
    currentLocation = [userLocation.location copy];
    
    //判断:如果计时器在走,才进行画路径
    if (datamanager.isRuning) {
    //记录上个位置的坐标
    if (isFirst) {
        nowLocation = currentLocation.coordinate;
    }
    isFirst = NO;
    
    beforeLocation = nowLocation;
    //记录现在坐标
    nowLocation = currentLocation.coordinate;
    
    beforeLocation.latitude = [[NSString stringWithFormat:@"%.6f",beforeLocation.latitude] doubleValue];
    beforeLocation.longitude = [[NSString stringWithFormat:@"%.6f",beforeLocation.longitude] doubleValue];
    nowLocation.latitude = [[NSString stringWithFormat:@"%.6f",nowLocation.latitude] doubleValue];
    nowLocation.longitude = [[NSString stringWithFormat:@"%.6f",nowLocation.longitude] doubleValue];
    
    //坐标给单例
    datamanager.beforeLocation = beforeLocation;
    datamanager.nowLocation = nowLocation;
    
//    //单例记录所有位置点
//    [datamanager.locationArray addObject:currentLocation];
       
    //单例进行相关计算
    [datamanager calculate];
    
    [self initOverlays];
    
    }
}

- (void)initOverlays {
    //Polyline.多点连线
    //CLLocationCoordinate2D polylineCoords[2];
    polylineCoords[0] = beforeLocation;
    polylineCoords[1] = nowLocation;
  
    //设置线
    //此类用于定义一个由多个点相连的多段线，点与点之间尾部想连但第一点与最后一个点不相连, 通常MAPolyline是MAPolylineRenderer的model
    polyline = [MAPolyline polylineWithCoordinates:polylineCoords count:2];
    [self.overlays insertObject:polyline atIndex:0];
    //把线加到地图上
    [myMapView addOverlays:self.overlays];
}

//画线会走这个代理,画轨迹
#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        //此类是MAPolyline的显示多段线renderer,可以通过MAOverlayPathRenderer修改其fill和stroke attributes
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth   = 6.f;
        polylineRenderer.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:1];
        
        return polylineRenderer;
    } else {
        return nil;
    }
}

@end

