//
//  ThreeViewController.m
//  shiguang
//
//  Created by 紫薇大舅 on 16/5/12.
//  Copyright © 2016年 ziweidajiu. All rights reserved.
//

#import "ThreeViewController.h"
#import "DisanyeStore.h"
#import "DisanyeOneTableViewCell.h"
#import "DisanyeTwoTableViewCell.h"
#import "DisanyeThreeTableViewCell.h"
#import "UINavigationBar+Awesome.h"
#import "HCScanQRViewController.h"
#import "OTPageScrollView.h"
#import "OTPageView.h"
#import "ThreeToNewViewController.h"
#import "DisanyeFourTableViewCell.h"
#import "DisanyeFiveTableViewCell.h"

#define NAVBAR_CHANGE_POINT -20

@interface ThreeViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UISearchResultsUpdating, OTPageScrollViewDataSource,OTPageScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) OTPageView *PScrollView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIPageControl *page;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) int num;

@end

@implementation ThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self createNavagationBar];
    [self createTableView];
    [self createDataSource];
    [self createTimer];
}

#pragma mark - 定制导航条
-(void)createNavagationBar {
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"v10_cart_notify@3x"] style:UIBarButtonItemStyleDone target:self action:@selector(onClick10:)];
    self.navigationItem.rightBarButtonItem = btn;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UISearchController *search = [[UISearchController alloc] initWithSearchResultsController:nil];
    search.searchBar.translucent = NO;
    search.searchBar.barStyle = UIBarStyleDefault;
    search.searchBar.placeholder = @"搜索正版电影";
    search.searchBar.showsCancelButton = NO;
    search.hidesNavigationBarDuringPresentation  = YES;
    search.dimsBackgroundDuringPresentation = NO;
    search.searchResultsUpdater = self;
    search.searchBar.frame = CGRectMake(100, 20, WIDTH-150, 44);
    self.navigationItem.titleView = search.searchBar;
    
    UIBarButtonItem *btn1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_scan_barcode_white@3x"] style:UIBarButtonItemStyleDone target:self action:@selector(onClick0:)];
    self.navigationItem.leftBarButtonItem = btn1;
}

#pragma mark - 左右BTN点击事件
-(void)onClick10:(UIButton *)btn {
    
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

#pragma mark - 网络请求
-(void)createDataSource {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    DisanyeStore *disan = [[DisanyeStore alloc] init];
    [disan requestWithSuccess:^{
        [self createHeadView:self.tableView];
        [self createPSscrollView];
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(NSError *responseError) {
        [SVProgressHUD dismiss];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"解释数据失败" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alert animated:YES completion:^{
        }];
    }];
}

#pragma mark - 创建tableView
-(void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, WIDTH, HEIGH+64) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.bounces = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"DisanyeOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DisanyeTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DisanyeThreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell3"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DisanyeFourTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell4"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DisanyeFiveTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell5"];
}

#pragma mark - 创建tableView头视图
-(void)createHeadView:(UITableView *)tableView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 240)];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 240)];
    NSArray *arr = [DisanyeList sharedInstance].scrollViews;
    _scrollView.contentSize = CGSizeMake(WIDTH*[arr count], 240);
    for (int i = 0; i < arr.count; i++) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH*i, 0, WIDTH, 240)];
        [image sd_setImageWithURL:[NSURL URLWithString:[arr[i] image1]]];
        [_scrollView addSubview:image];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH*i, 0, WIDTH, 240)];
        [btn addTarget:self action:@selector(onClick5:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100+i;
        [_scrollView addSubview:btn];
    }
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [view addSubview:_scrollView];
    
    self.page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 220, WIDTH, 20)];
    self.page.numberOfPages = arr.count;
    [self.page addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:self.page];
    
    tableView.tableHeaderView = view;
}

#pragma mark - pageController点击事件
-(void)valueChange:(UIPageControl *)sender {
    self.scrollView.contentOffset = CGPointMake(WIDTH*sender.currentPage, 0);
}

#pragma mark - 点击事件
-(void)onClick5:(UIButton *)btn {
    ThreeToNewViewController *new = [[ThreeToNewViewController alloc] init];
    Disanye *san = [DisanyeList sharedInstance].scrollViews[(int)btn.tag-100];
    new.url = san.url1;
    [self.navigationController pushViewController:new animated:YES];
}

#pragma mark - tableViewDelegate组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3+[DisanyeList sharedInstance].categorys.count;
}

#pragma mark - tableView行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < 3) {
        if ([[DisanyeList sharedInstance].navigatorIcons count] == 0) {
            return 0;
        }
        return 1;
    } else {
        if ([DisanyeList sharedInstance].categorys == nil) {
            return 0;
        }
        return 2;
    }
}

#pragma mark - 定制cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSArray *arr = [DisanyeList sharedInstance].navigatorIcons;
        DisanyeOneTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        [cell1.image1 sd_setImageWithURL:[NSURL URLWithString:[arr[0] image1]]];
        cell1.label1.text = [arr[0] title];
        cell1.btn1.tag = 1;
        [cell1.btn1 addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell1.image2 sd_setImageWithURL:[NSURL URLWithString:[arr[1] image1]]];
        cell1.label2.text = [arr[1] title];
        cell1.btn2.tag = 2;
        [cell1.btn2 addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell1.image3 sd_setImageWithURL:[NSURL URLWithString:[arr[2] image1]]];
        cell1.label3.text = [arr[2] title];
        cell1.btn3.tag = 3;
        [cell1.btn3 addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell1.image4 sd_setImageWithURL:[NSURL URLWithString:[arr[3] image1]]];
        cell1.label4.text = [arr[3] title];
        cell1.btn4.tag = 4;
        [cell1.btn4 addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        cell1.btn1.tag = 200;
        cell1.btn2.tag = 201;
        cell1.btn3.tag = 202;
        cell1.btn4.tag = 203;
        [cell1.btn4 addTarget:self action:@selector(onClick200:) forControlEvents:UIControlEventTouchUpInside];
        [cell1.btn3 addTarget:self action:@selector(onClick200:) forControlEvents:UIControlEventTouchUpInside];
        [cell1.btn2 addTarget:self action:@selector(onClick200:) forControlEvents:UIControlEventTouchUpInside];
        [cell1.btn1 addTarget:self action:@selector(onClick200:) forControlEvents:UIControlEventTouchUpInside];
        return cell1;
    } else if (indexPath.section == 1) {
        DisanyeTwoTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        Disanye *mo1 = [DisanyeList sharedInstance].cells[0];
        Disanye *mo2 = [DisanyeList sharedInstance].cells[1];
        [cell2.image1 sd_setImageWithURL:[NSURL URLWithString:mo1.image1]];
        [cell2.image2 sd_setImageWithURL:[NSURL URLWithString:mo1.image2]];
        [cell2.image3 sd_setImageWithURL:[NSURL URLWithString:mo1.image3]];
        [cell2.image4 sd_setImageWithURL:[NSURL URLWithString:mo2.image1]];
        cell2.btn1.tag = 300;
        cell2.btn2.tag = 301;
        cell2.btn3.tag = 302;
        cell2.btn4.tag = 303;
        [cell2.btn4 addTarget:self action:@selector(onClick300:) forControlEvents:UIControlEventTouchUpInside];
        [cell2.btn3 addTarget:self action:@selector(onClick300:) forControlEvents:UIControlEventTouchUpInside];
        [cell2.btn2 addTarget:self action:@selector(onClick300:) forControlEvents:UIControlEventTouchUpInside];
        [cell2.btn1 addTarget:self action:@selector(onClick300:) forControlEvents:UIControlEventTouchUpInside];
        return cell2;
    } else if (indexPath.section == 2) {
        DisanyeThreeTableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
        cell3.scrollView1.contentSize = CGSizeMake(WIDTH*4, 520);
        cell3.scrollView1.tag = 1000;
        NSArray *arr = [DisanyeList sharedInstance].topics;
        for (int i = 0; i < arr.count; i++) {
            UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH*i, 0, WIDTH, 130)];
            [view sd_setImageWithURL:[NSURL URLWithString:[arr[i] image3]]];
            [cell3.scrollView1 addSubview:view];
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH*i, 120, WIDTH, 20)];
            label1.text = [arr[i] title2];
            label1.font = [UIFont systemFontOfSize:14];
            label1.textAlignment = NSTextAlignmentCenter;
            [cell3.scrollView1 addSubview:label1];
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH*i, 130, WIDTH, 40)];
            label2.text = [arr[i] title];
            label2.font = [UIFont systemFontOfSize:18];
            label2.textAlignment = NSTextAlignmentCenter;
            [cell3.scrollView1 addSubview:label2];
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(140+WIDTH*i, 460, 100, 50)];
            [btn setImage:[UIImage imageNamed:@"store_home_more@3x"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(commonOnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i+400;
            [cell3.scrollView1 addSubview:btn];
            for (int j = 0; j < 6; j++) {
                if (j < 3) {
                    Disanye *mo1 = [arr[i] commonArr][j];
                    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH/3*j+WIDTH*i, 180, WIDTH/3, 120)];
                    [view sd_setImageWithURL:[NSURL URLWithString:mo1.image1]];
                    [cell3.scrollView1 addSubview:view];
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/3*j+WIDTH*i, 300, WIDTH/3, 20)];
                    label.text = [mo1 title];
                    label.font = [UIFont systemFontOfSize:15];
                    label.textAlignment = NSTextAlignmentCenter;
                    [cell3.scrollView1 addSubview:label];
                } else {
                    Disanye *mo1 = [arr[i] commonArr][j];
                    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH/3*(j-3)+WIDTH*i, 320, WIDTH/3, 120)];
                    [view sd_setImageWithURL:[NSURL URLWithString:mo1.image1]];
                    [cell3.scrollView1 addSubview:view];
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/3*(j-3)+WIDTH*i, 440, WIDTH/3, 20)];
                    label.text = [mo1 title];
                    label.font = [UIFont systemFontOfSize:15];
                    label.textAlignment = NSTextAlignmentCenter;
                    [cell3.scrollView1 addSubview:label];
                }
            }
        }
        cell3.scrollView1.pagingEnabled = YES;
        cell3.scrollView1.bounces = NO;
        cell3.scrollView1.showsHorizontalScrollIndicator = NO;
        cell3.scrollView1.scrollEnabled = NO;
        cell3.view1.userInteractionEnabled = YES;
        cell3.view1.backgroundColor = [UIColor clearColor];
        [cell3.view1 addSubview:self.PScrollView];
        
        return cell3;
    } else {
        if (indexPath.row == 0) {
            DisanyeFourTableViewCell *cell4 = [tableView dequeueReusableCellWithIdentifier:@"cell4" forIndexPath:indexPath];
            Disanye *san = [DisanyeList sharedInstance].categorys[indexPath.section-3];
            cell4.label1.text = san.title;
            [cell4.image1 sd_setImageWithURL:[NSURL URLWithString:san.image1]];
            cell4.btn1.tag = 500+indexPath.section-3;
            cell4.btn2.tag = 600+indexPath.section-3;
            [cell4.btn1 addTarget:self action:@selector(onClick500:) forControlEvents:UIControlEventTouchUpInside];
            [cell4.btn2 addTarget:self action:@selector(onClick500:) forControlEvents:UIControlEventTouchUpInside];
            return cell4;
        } else {
            DisanyeFiveTableViewCell *cell5 = [tableView dequeueReusableCellWithIdentifier:@"cell5" forIndexPath:indexPath];
            Disanye *san = [DisanyeList sharedInstance].categorys[indexPath.section-3];
            [cell5.image1 sd_setImageWithURL:[NSURL URLWithString:[san.commonArr[0] image1]]];
            [cell5.image2 sd_setImageWithURL:[NSURL URLWithString:[san.commonArr[1] image1]]];
            [cell5.image3 sd_setImageWithURL:[NSURL URLWithString:[san.commonArr[2] image1]]];
            cell5.label1.text = [san.commonArr[0] title];
            cell5.label2.text = [san.commonArr[1] title];
            cell5.label3.text = [san.commonArr[2] title];
            return cell5;
        }
    }
    return nil;
}

#pragma mark - cell点击事件
-(void)onClick200:(UIButton *)btn {
    ThreeToNewViewController *new = [[ThreeToNewViewController alloc] init];
    Disanye *san = [DisanyeList sharedInstance].navigatorIcons[(int)btn.tag-200];
    new.url = san.url1;
    [self.navigationController pushViewController:new animated:YES];
}

-(void)onClick300:(UIButton *)btn {
    ThreeToNewViewController *new = [[ThreeToNewViewController alloc] init];
    Disanye *san = [DisanyeList sharedInstance].cells[0];
    if (btn.tag == 300) {
        new.url = san.url1;
    } else if (btn.tag == 301) {
        new.url = san.url2;
    } else if (btn.tag == 302) {
        new.url = san.url3;
    } else {
        Disanye *san = [DisanyeList sharedInstance].cells[1];
        new.url = san.url1;
    }
    
    [self.navigationController pushViewController:new animated:YES];
}

-(void)commonOnClick:(UIButton *)btn {
    ThreeToNewViewController *new = [[ThreeToNewViewController alloc] init];
    Disanye *san = [DisanyeList sharedInstance].topics[(int)btn.tag-400];
    new.url = san.url1;
    [self.navigationController pushViewController:new animated:YES];
}

-(void)onClick500:(UIButton *)btn {
    if (btn.tag < 600) {
        ThreeToNewViewController *new = [[ThreeToNewViewController alloc] init];
        Disanye *san = [DisanyeList sharedInstance].categorys[(int)btn.tag-500];
        new.url = san.url2;
        [self.navigationController pushViewController:new animated:YES];
    } else {
        ThreeToNewViewController *new = [[ThreeToNewViewController alloc] init];
        Disanye *san = [DisanyeList sharedInstance].categorys[(int)btn.tag-600];
        new.url = san.url1;
        [self.navigationController pushViewController:new animated:YES];
    }
    
}

-(void)onClick:(UIButton *)btn {
    if (btn.tag == 1) {
        
    } else if (btn.tag == 2) {
        
    } else if (btn.tag == 3) {
        
    } else {
        
    }
}

#pragma mark - cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    } else if (indexPath.section == 1) {
        return 300;
    } else if (indexPath.section == 2) {
        return 520;
    } else {
        if (indexPath.row == 0) {
            return 200;
        } else {
            return 140;
        }
    }
    return 0;
}

#pragma mark - 组头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

#pragma mark - 组尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

#pragma mark - 滑动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tableView) {
        UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY > NAVBAR_CHANGE_POINT) {
            CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        } else {
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        }
    }
}

#pragma mark - 将要显示时，设置NavagationBar
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tableView.delegate = self;
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tableView.delegate = nil;
    [self.navigationController.navigationBar lt_reset];
}

#pragma mark - 定制scrollView
-(void)createPSscrollView {
    _PScrollView = [[OTPageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 80)];
    _PScrollView.pageScrollView.dataSource = self;
    _PScrollView.pageScrollView.delegate = self;
    _PScrollView.pageScrollView.padding =50;
    _PScrollView.pageScrollView.leftRightOffset = 0;
    _PScrollView.pageScrollView.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width -150)/2, 0, 150, 100);
    [_PScrollView.pageScrollView reloadData];
}
#pragma mark - 定制scrollView的个数
- (NSInteger)numberOfPageInPageScrollView:(OTPageScrollView*)pageScrollView{
    return [[DisanyeList sharedInstance].topics count];
}

#pragma mark - scrollView方法
- (UIView*)pageScrollView:(OTPageScrollView*)pageScrollView viewForRowAtIndex:(int)index{
    UIView *cell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [image sd_setImageWithURL:[NSURL URLWithString:[[DisanyeList sharedInstance].topics[index] image1]]];
    [cell addSubview:image];
    return cell;
}

- (CGSize)sizeCellForPageScrollView:(OTPageScrollView*)pageScrollView
{
    return CGSizeMake(100, 100);
}

- (void)pageScrollView:(OTPageScrollView *)pageScrollView didTapPageAtIndex:(NSInteger)index{
    UIScrollView *scroll = (id)[self.view viewWithTag:1000];
    scroll.contentOffset = CGPointMake(WIDTH*index, 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    UIScrollView *scroll = (id)[self.view viewWithTag:1000];
    if (scrollView == _PScrollView.pageScrollView) {
        NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
        scroll.contentOffset = CGPointMake(WIDTH*index, 0);
    } else if (scrollView == self.scrollView) {
        self.page.currentPage = self.scrollView.contentOffset.x/WIDTH;
    }
}

#pragma mark - 创建定时器
-(void)createTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(valueChange1:) userInfo:nil repeats:YES];
}

-(void)valueChange1:(id)sender {
    if (_num > [DisanyeList sharedInstance].scrollViews.count-1) {
        self.num = 0;
    }
    self.scrollView.contentOffset = CGPointMake(WIDTH*self.num, 0);
    self.page.currentPage = self.num;
    self.num++;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
