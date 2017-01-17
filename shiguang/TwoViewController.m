//
//  TwoViewController.m
//  shiguang
//
//  Created by 紫薇大舅 on 16/5/5.
//  Copyright © 2016年 ziweidajiu. All rights reserved.
//

#import "TwoViewController.h"
#import "Model.h"
#import "DieryeStore.h"
#import "DieryeOneTableViewCell.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import "DieryeTwoStore.h"
#import "DieryeTwoTableViewCell.h"
#import "DieryeThreeTableViewCell.h"
#import "DieryeFourTableViewCell.h"
#import "HCScanQRViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Product.h"
#import "Order.h"
#import "DataSigner.h"
#import "AddressPickerDemo.h"
#import <AMapLocationKit/AMapLocationKit.h>

@interface TwoViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UITableView *tableView2;

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, assign) BOOL judge;

@property (nonatomic, strong) NSString *cityName;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.cityName = @"大连";
    [self createLocation];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    _color = [[UIColor alloc] initWithRed:0.4 green:0.8 blue:1 alpha:1];
    [self createUI];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];

    [self createTableView];
    [self createScrollView];
    [self createData];
}

-(void)createLocation {
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，可修改，最小2s
    self.locationManager.locationTimeout = 3;
    //   逆地理请求超时时间，可修改，最小2s
    self.locationManager.reGeocodeTimeout = 3;
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"---------------locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            self.cityName = @"未知";
            [self createLiftBtn];
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        NSLog(@"-------------------location:%@", location);
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode.city);
            if (regeocode.city == nil) {
                self.cityName = @"未知";

            } else {
                self.cityName = regeocode.city;
            }
            [self createLiftBtn];
        }
    }];
}

-(void)createScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGH)];
    _scrollView.contentSize = CGSizeMake(WIDTH*2, HEIGH-64);
    [_scrollView addSubview:_tableView];
    _scrollView.pagingEnabled = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
}

-(void)createData {
        DieryeStore *dier = [[DieryeStore alloc] init];
        [dier requestWithSuccess:^{
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            [SVProgressHUD dismiss];
        } failure:^(NSError *responseError) {
            NSLog(@"错误");
            [SVProgressHUD dismiss];
        }];
    
}

-(void)createData2 {
    DieryeTwoStore *two = [[DieryeTwoStore alloc] init];
    [two requestWithSuccess:^{
        [_tableView2 reloadData];
        [SVProgressHUD dismiss];
    } failure:^(NSError *responseError) {
        NSLog(@"----失败");
        [SVProgressHUD dismiss];
    }];
}

-(void)createUI {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"icon_myinfo_top@3x.jpg"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:nil];
    
//    _segmentedControl.tintColor = [UIColor orangeColor];
    
    [_segmentedControl insertSegmentWithTitle:@"正在热映"atIndex:0 animated:NO];
    
    [_segmentedControl insertSegmentWithTitle:@"即将上映"atIndex:1 animated:NO];
    
    _segmentedControl.selectedSegmentIndex = 0;
    
    [_segmentedControl addTarget:self action:@selector(controlPressed:)

               forControlEvents:UIControlEventValueChanged];
    [self.navigationController.navigationBar.topItem setTitleView:_segmentedControl];
    
    UIBarButtonItem *btn1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_scan_barcode_white@3x"] style:UIBarButtonItemStyleDone target:self action:@selector(onClick0:)];
    self.navigationItem.rightBarButtonItem = btn1;
    
    [self createLiftBtn];
}

-(void)createLiftBtn {
    UIBarButtonItem *btn2 = [[UIBarButtonItem alloc] initWithTitle:self.cityName style:UIBarButtonItemStyleDone target:self action:@selector(onClick1:)];
    self.navigationItem.leftBarButtonItem = btn2;
}

-(void)onClick0:(UIButton *)btn {
    HCScanQRViewController *scan = [[HCScanQRViewController alloc]init];
    //调用此方法来获取二维码信息
    [scan successfulGetQRCodeInfo:^(NSString *QRCodeInfo) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.detailTextLabel.text = QRCodeInfo;
    }];
    [self.navigationController pushViewController:scan animated:YES];
}

-(void)onClick1:(UIButton *)btn {
    AddressPickerDemo *addressPickerDemo = [[AddressPickerDemo alloc] init];
//    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:addressPickerDemo];
    addressPickerDemo.block = ^(NSString *city){
        self.cityName = city;
        [self createLiftBtn];
    };
    [self.navigationController pushViewController:addressPickerDemo animated:YES];

}

-(void)controlPressed:(id)sender {
    if (_judge == NO) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [self createTableView2];
        [self createData2];
        _judge = YES;
    }
    _scrollView.contentOffset = CGPointMake(WIDTH*_segmentedControl.selectedSegmentIndex, 0);
}

-(void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DieryeOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
}

-(void)createTableView2 {
    self.tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH, 0, WIDTH, HEIGH) style:UITableViewStyleGrouped];
    self.tableView2.dataSource = self;
    self.tableView2.delegate = self;
    [self.scrollView addSubview:self.tableView2];
    [self.tableView2 registerNib:[UINib nibWithNibName:@"DieryeTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
    [self.tableView2 registerNib:[UINib nibWithNibName:@"DieryeThreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell5"];
    [self.tableView2 registerNib:[UINib nibWithNibName:@"DieryeFourTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell6"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _tableView2) {
        if ([DieryeList sharedInstance].movies2 == nil) {
            return 1;
        }
        return 3;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableView) {
        if ([DieryeList sharedInstance].movies1 == nil) {
            return 0;
        }
        return [[DieryeList sharedInstance].movies1 count];
    } else {
        if ([DieryeList sharedInstance].movies2 == nil) {
            return 0;
        } else if (section == 0) {
            if ([DieryeList sharedInstance].movies3 == nil) {
                return 0;
            }
            return 2;
        }else if (section == 1) {
            return 1;
        }
        
        return [[DieryeList sharedInstance].movies2 count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableView) {
        DieryeOneTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        Dierye *dier = [DieryeList sharedInstance].movies1[indexPath.row];
        cell1.label1.text = dier.title;
        cell1.label2.text = dier.content;
        cell1.label3.text = dier.time;
        cell1.label4.text = [NSString stringWithFormat:@"%@家影院上映%@场", dier.cinama, dier.shows];
        cell1.btn1.layer.cornerRadius = 5;
        cell1.label5.text = dier.type;
        [cell1.btn1 addTarget:self action:@selector(onClickZhiFu:) forControlEvents:UIControlEventTouchUpInside];
        [cell1.image1 sd_setImageWithURL: [NSURL URLWithString:dier.image]];
        return cell1;
    } else {
        if (indexPath.section == 0 && indexPath.row == 0) {
            UITableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
            if (!cell3) {
                cell3 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell3"];
            }
            cell3.textLabel.text = @"最受关注";
            cell3.textLabel.font = [UIFont boldSystemFontOfSize:17];
            return cell3;
        } else if (indexPath.section == 2 && indexPath.row == 0) {
            UITableViewCell *cell4 = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
            if (!cell4) {
                cell4 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell4"];
            }
            cell4.textLabel.text = [NSString stringWithFormat:@"即将上映(%d部)", (int)[[DieryeList sharedInstance].movies2 count]];
            cell4.textLabel.font = [UIFont boldSystemFontOfSize:17];
            return cell4;
        } else if (indexPath.section == 1) {
            DieryeThreeTableViewCell *cell5 = [tableView dequeueReusableCellWithIdentifier:@"cell5" forIndexPath:indexPath];
            Dierye *dier = [DieryeList sharedInstance].movies1[indexPath.row];
            [cell5.image1 sd_setImageWithURL:[NSURL URLWithString:dier.image]];
            return cell5;
        } else if (indexPath.section == 0 && indexPath.row == 1) {
            DieryeFourTableViewCell *cell6 = [tableView dequeueReusableCellWithIdentifier:@"cell6" forIndexPath:indexPath];
            NSArray *arr = [DieryeList sharedInstance].movies3;
            cell6.scrollView1.contentSize = CGSizeMake(WIDTH*[arr count], 150);
            for (int i = 0; i < [arr count]; i++) {
                Dierye *dier = arr[i];
                UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(8+WIDTH*i, 8, 100, 134)];
                [image1 sd_setImageWithURL:[NSURL URLWithString: dier.image]];
                [cell6.scrollView1 addSubview:image1];
                UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(120+WIDTH*i, 0, WIDTH-120, 30)];
                label1.text = dier.title;
                label1.font = [UIFont boldSystemFontOfSize:18];
                [cell6.scrollView1 addSubview:label1];
                UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(120+WIDTH*i, 25, WIDTH-120, 30)];
                label2.text = [NSString stringWithFormat:@"%@人想看-%@", dier.propleNum, dier.type];
                label2.font = [UIFont systemFontOfSize:14];
                label2.textColor = [UIColor grayColor];
                [cell6.scrollView1 addSubview:label2];
                UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(120+WIDTH*i, 50, WIDTH-120, 30)];
                label3.text = [NSString stringWithFormat:@"导演:%@", dier.daoYan];
                label3.font = [UIFont systemFontOfSize:14];
                label3.textColor = [UIColor grayColor];
                [cell6.scrollView1 addSubview:label3];
                UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(120+WIDTH*i, 75, WIDTH-120, 30)];
                label4.text = [NSString stringWithFormat:@"演员:%@,%@", dier.actor1, dier.actor2];
                label4.font = [UIFont systemFontOfSize:14];
                label4.textColor = [UIColor grayColor];
                [cell6.scrollView1 addSubview:label4];
                UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(120+WIDTH*i, 110, 100, 30)];
                [btn1 setTitle:@"上映提醒" forState:UIControlStateNormal];
                [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btn1.backgroundColor = _color;
                btn1.layer.cornerRadius = 5;
                [cell6.scrollView1 addSubview:btn1];
                UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(230+WIDTH*i, 110, 100, 30)];
                [btn2 setTitle:@"预告片" forState:UIControlStateNormal];
                [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btn2.layer.cornerRadius = 5;
                btn2.backgroundColor = _color;
                [cell6.scrollView1 addSubview:btn2];
            }
            cell6.scrollView1.pagingEnabled = YES;
            cell6.scrollView1.showsHorizontalScrollIndicator = NO;
            return cell6;
        }
        DieryeTwoTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        Dierye *dier = [DieryeList sharedInstance].movies2[indexPath.row];
        cell2.label1.text = dier.title;
        cell2.label2.text = [NSString stringWithFormat:@"%@人想看-%@", dier.propleNum, dier.type];
        cell2.label3.text = [NSString stringWithFormat:@"导演:%@", dier.daoYan];
        [cell2.image1 sd_setImageWithURL:[NSURL URLWithString:dier.image]];
        return cell2;
    }
    return nil;
}

-(void)onClickZhiFu:(UIButton *)btn {
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    Product *product = [[Product alloc] init];
    product.price = 0.01;
    product.body = @"我是测试数据";
    product.subject = @"1";
    product.orderId = [NSUUID UUID].UUIDString;
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088611922925773";
    NSString *seller = @"esok@esok.cn";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBANfEOGuHDyStqzetu37gO0Lxy9ucCVpT3t7oao/oYHyeQIhI4sxu7dnTbSdsR3DKglHg+9sNbIvubxxeLPvfjrF/Lvky0sYIGBRYyQXQb+kwOq0dwqHGvqN4FP1EwI69CfQP/a2J/z4D0stF/htv4B24dxag7mxZIKLJJvwstUbnAgMBAAECgYEAtVsDhTXPP6gNqs4HM3xrszgjfiIoJlkqkjfOIclTGEu3uBVzNBvlJdq0+5bicWZ1pTay2ors+qzdjX2G1+ovN2x9ZIZyVDL0P1CqgzwEu7hCIC5I/hlcMIux+h0U93stRxeimdCcbj2hCfzewE77hP4GQ6F4llzgDtvm9X41CYkCQQDy+63bcv7huWydUOuN7ObhOTAjoAe5SxJL89UkFkMGwJYqUm2cRNAkaJ3OPBBBXEeDpBjh323L6g0pUnM6q32lAkEA41NJY+GAXVUAWnAKNJHfXEi3XopnStsPRRL6gRCqTcceWEicq6CtyHEIxJuldiG0AP2u+Fh5faWx4phXKFEkmwJAFdGt2f/ojWJ2M2Y50MPOM7lL7lcHeocYPIPHxvbMzAVtNp2yRA8V1b8jNIrGNuhPb63DojzLAj2hMu25dTJDFQJAFi24CVCk73YtlKU9uadJvX0ytryWG02IDdsuKY1wsCnvIfnjnzMMAXRVwKjW2dGr+DTH717ia4nQ8ySdzEcuZQJAf1aGvpNuRP9Sf043ymPbhBVEb2bji6ltOr9R1VpCuaojP/EAYEAanzHLvcG+kc0QAk57+7hWp3smNQu+aYt1oQ==";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.sellerID = seller;
    order.outTradeNO = [NSUUID UUID].UUIDString; //订单ID（由商家自行制定）
    order.subject = product.subject; //商品标题
    order.body = product.body; //商品描述
    order.totalFee = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
    order.notifyURL =  @"http://www.esok.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showURL = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkdemo";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableView) {
        return 130;
    } else {
        if (indexPath.section == 0 && indexPath.row == 0) {
            return 40;
        } else if (indexPath.section == 2 && indexPath.row == 0) {
            return 40;
        } else if (indexPath.section == 1) {
            return 130;
        } else if (indexPath.section == 0 && indexPath.row == 1) {
            return 150;
        }
        return 130;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 6;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        _segmentedControl.selectedSegmentIndex = _scrollView.contentOffset.x/WIDTH;
        if (self.segmentedControl.selectedSegmentIndex == 1 && self.judge == NO) {
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
            [self createTableView2];
            [self createData2];
            self.judge = YES;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
