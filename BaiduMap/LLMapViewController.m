//
//  LLMapViewController.m
//  BaiduMap
//
//  Created by WangZhaomeng on 2017/6/13.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLMapViewController.h"

@interface LLMapViewController ()<BMKMapViewDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate,UITableViewDelegate,UITableViewDataSource>{
    BMKMapView         *_mapView;          //地图view
    BMKLocationService *_locService;       //定位
    BMKGeoCodeSearch   *_geocodesearch;    //地理编码主类，用来查询、返回结果信息
    BMKPointAnnotation *_pointAnnotation;  //定位大头针
    NSString           *_cityName;
    UITextField        *_searchTextField;
    UITableView        *_tableView;
    NSArray<BMKPoiInfo *> *_poiInfos;
}

@end

@implementation LLMapViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"百度地图";
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(10, 66, SCREEN_WIDTH-20, 34)];
    inputView.layer.masksToBounds = YES;
    inputView.layer.cornerRadius = 5;
    inputView.backgroundColor = [UIColor colorWithRed:230/255. green:230/255. blue:230/255. alpha:1];
    [self.view addSubview:inputView];
    
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 4, 26, 26)];
    searchImageView.image = [UIImage imageNamed:@"ll_search"];
    [inputView addSubview:searchImageView];
    
    _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(searchImageView.frame)+5, 4, CGRectGetWidth(inputView.frame)-CGRectGetMaxX(searchImageView.frame)-10, 30)];
    _searchTextField.textColor = [UIColor darkGrayColor];
    _searchTextField.font = [UIFont systemFontOfSize:16];
    _searchTextField.text = @"重庆市江北区红旗河沟时代名居C座";
    _searchTextField.placeholder = @"请搜索您的小区或大厦、街道名称";
    [inputView addSubview:_searchTextField];
    
    //添加地图视图
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(inputView.frame)+2, SCREEN_WIDTH, SCREEN_WIDTH*0.6)];
    _mapView.showsUserLocation = YES; //是否显示定位图层（即我的位置的小圆点）
    _mapView.zoomLevel = 15;//地图显示比例
    _mapView.mapType = BMKMapTypeStandard;//设置地图为空白类型
    [self.view addSubview:_mapView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_mapView.frame)+10, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_mapView.frame)-10-50)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.rowHeight = 60;
    [self.view addSubview:_tableView];
    
    UIButton *OKBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    OKBtn.frame = CGRectMake(10, SCREEN_HEIGHT-45, SCREEN_WIDTH-20, 40);
    OKBtn.layer.masksToBounds = YES;
    OKBtn.layer.cornerRadius = 5;
    OKBtn.backgroundColor = [UIColor redColor];
    [OKBtn setTitle:@"确定" forState:UIControlStateNormal];
    [OKBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [OKBtn addTarget:self action:@selector(OKBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:OKBtn];
    
    _pointAnnotation = [[BMKPointAnnotation alloc] init];
    _pointAnnotation.title = @"title";
    _pointAnnotation.subtitle = @"subtitle";
    
    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    _geocodesearch.delegate = self;
    [self startLocation];
}

#pragma mark - UITableViewDelete
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _poiInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLMapTableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"LLMapTableViewCell"];
    }
    
    if (_poiInfos.count > indexPath.row) {
        BMKPoiInfo *poiInfo = _poiInfos[indexPath.row];
        cell.textLabel.text = poiInfo.name;
        cell.detailTextLabel.text = poiInfo.address;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_poiInfos.count > indexPath.row) {
        BMKPoiInfo *poiInfo = _poiInfos[indexPath.row];
        [self updateAnnotationWithCoordinate:poiInfo.pt isSearch:NO];
    }
}

#pragma mark - 私有方法
//开始定位
-(void)startLocation{
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _locService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    //启动LocationService
    [_locService startUserLocationService];
}

//查询
-(void)searchWithCity:(NSString *)city keyword:(NSString *)keyword{
    
    BMKPoiSearch *poisearch = [[BMKPoiSearch alloc]init];
    poisearch.delegate = self;
    
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = 0;
    citySearchOption.pageCapacity = 10;
    citySearchOption.city = city;
    citySearchOption.keyword = keyword;
    
    BOOL flag = [poisearch poiSearchInCity:citySearchOption];
    if(flag) {
        NSLog(@"城市内检索发送成功");
    }
    else {
        NSLog(@"城市内检索发送失败");
    }
}

//地理位置反编码
- (void)reverseGeoCodeWithCLLocationCoordinate2D:(CLLocationCoordinate2D)coordinate {
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeocodeSearchOption.reverseGeoPoint = coordinate;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag){
        NSLog(@"反geo检索发送成功");
    }
    else{
        NSLog(@"反geo检索发送失败");
    }
}

//点击地图添加大头针
- (void)updateAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate isSearch:(BOOL)isSearch{
    [_mapView removeAnnotation:_pointAnnotation];
    _pointAnnotation.coordinate = coordinate;
    [_mapView addAnnotation:_pointAnnotation];
    
    [_mapView setCenterCoordinate:coordinate animated:YES];
    
    if (isSearch) {
        [self reverseGeoCodeWithCLLocationCoordinate2D:coordinate];
    }
}

//确定按钮的点击事件
- (void)OKBtnClick:(UIButton *)btn {
    NSLog(@"确定");
}

#pragma mark - 百度地图相关代理
///处理位置变更信息的delegate
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    NSLog(@"heading is %@",userLocation.heading);
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    [_locService stopUserLocationService];
    
    //更新地图上的位置
    [_mapView updateLocationData:userLocation];
    
    //更新当前位置到地图中间
    _mapView.centerCoordinate = userLocation.location.coordinate;
    
    [self reverseGeoCodeWithCLLocationCoordinate2D:userLocation.location.coordinate];
}

- (void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"error:%@",error);
}

///地理反编码的delegate
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"address:%@",result.address);
    
    _cityName = result.addressDetail.city;
    _poiInfos = result.poiList;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
}

///位置检索delegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    
    if(errorCode == BMK_SEARCH_NO_ERROR) {
        
        _poiInfos = poiResult.poiInfoList;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    }
}

///mapViewDeleta
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    [self.view endEditing:YES];
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    [self updateAnnotationWithCoordinate:coordinate isSearch:YES];
}

- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi *)mapPoi {
    [self updateAnnotationWithCoordinate:mapPoi.pt isSearch:YES];
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    
    [_mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
}

@end
