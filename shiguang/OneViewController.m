//
//  OneViewController.m
//  shiguang
//
//  Created by 紫薇大舅 on 16/5/12.
//  Copyright © 2016年 ziweidajiu. All rights reserved.
//

#import "OneViewController.h"
#import "UINavigationBar+Awesome.h"
#import "DiyiyeTwoTableViewCell.h"
#import "DiyiyeOneTableViewCell.h"
#import "DieryeStore.h"
#import "DiyiyeThreeTableViewCell.h"
#import "DisanyeStore.h"
#import "ThreeToNewViewController.h"

#define NAVBAR_CHANGE_POINT -20

@interface OneViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIPageControl *page;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) int num;

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _color = [[UIColor alloc] initWithRed:0.4 green:0.8 blue:1 alpha:1];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"icon_myinfo_top@3x.jpg"] forBarMetrics:UIBarMetricsDefault];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    image.image = [UIImage imageNamed:@"ele_logo_mtime@3x"];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = image;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [self createTableView];
    [self createData];
    [self createTimer];
}

-(void)createData {
    DieryeStore *dier = [[DieryeStore alloc] init];
    [dier requestWithSuccess:^{
        [self createDataSource];
    } failure:^(NSError *responseError) {
        [SVProgressHUD dismiss];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"解释数据失败" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alert animated:YES completion:^{
        }];
    }];
    
}

-(void)createDataSource {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    DisanyeStore *disan = [[DisanyeStore alloc] init];
    [disan requestWithSuccess:^{
        [self createHeadView:self.tableView];
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

-(void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, WIDTH, HEIGH+64) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DiyiyeTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DiyiyeOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DiyiyeThreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell3"];
}

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

-(void)valueChange:(UIPageControl *)sender {
    self.scrollView.contentOffset = CGPointMake(WIDTH*sender.currentPage, 0);
}

-(void)onClick5:(UIButton *)btn {
    ThreeToNewViewController *new = [[ThreeToNewViewController alloc] init];
    Disanye *san = [DisanyeList sharedInstance].scrollViews[(int)btn.tag-100];
    new.url = san.url1;
    [self.navigationController pushViewController:new animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        if ([[DieryeList sharedInstance].movies1 count] == 0 || [[DisanyeList sharedInstance].categorys count] == 0) {
            return 1;
        }
        return 2;
    } else {
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        return 240;
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        return 400;
    } else {
        return 40;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 9;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        DiyiyeTwoTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell1.label2.text = @"正在售票";
        cell1.label1.text = [NSString stringWithFormat:@"共%d部", (int)[[DieryeList sharedInstance].movies1 count]];
        cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell1;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        DiyiyeTwoTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell1.label2.text = @"电影商城";
        cell1.label1.text = @"全部商品";
        cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell1;
    } else if (indexPath.section == 2) {
        DiyiyeTwoTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell1.label2.text = @"时光精选";
        cell1.label1.text = @"全部";
        cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell1;
    } else if (indexPath.section == 3) {
        DiyiyeTwoTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell1.label2.text = @"更多推荐内容";
        cell1.label1.text = @"";
        cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell1;
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        DiyiyeOneTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        NSArray *arr = [DieryeList sharedInstance].movies1;
        cell2.scrollView1.contentSize = CGSizeMake(WIDTH/2.5*[arr count], 240);
        for (int i = 0; i < arr.count; i++) {
            UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH/2.5*i+10*i, 0, WIDTH/2.5, 180)];
            [view sd_setImageWithURL:[NSURL URLWithString:[arr[i] image]]];
            view.layer.cornerRadius = 5;
            [cell2.scrollView1 addSubview:view];
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2.5*i+10*i, 180, WIDTH/2.5, 30)];
            label1.text = [arr[i] title];
            label1.textAlignment = NSTextAlignmentCenter;
            [cell2.scrollView1 addSubview:label1];
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2.5*i+10*i, 200, WIDTH/2.5, 30)];
            label2.text = [NSString stringWithFormat:@"评分:%@", [arr[i] ping]];
            label2.font = [UIFont systemFontOfSize:15];
            label2.textColor = [UIColor orangeColor];
            label2.textAlignment = NSTextAlignmentCenter;
            [cell2.scrollView1 addSubview:label2];
        }
        cell2.scrollView1.pagingEnabled = NO;
        cell2.scrollView1.showsHorizontalScrollIndicator = NO;
        return cell2;
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        DiyiyeThreeTableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
        NSArray *arr = [DisanyeList sharedInstance].categorys;
        Disanye *mo1 = [DisanyeList sharedInstance].cells[0];
        Disanye *mo2 = [DisanyeList sharedInstance].cells[1];
        [cell3.image1 sd_setImageWithURL:[NSURL URLWithString:mo1.image1]];
        [cell3.image2 sd_setImageWithURL:[NSURL URLWithString:mo2.image1]];
        [cell3.image3 sd_setImageWithURL:[NSURL URLWithString:mo1.image2]];
        [cell3.image4 sd_setImageWithURL:[NSURL URLWithString:mo1.image3]];
        [cell3.image5 sd_setImageWithURL:[NSURL URLWithString:[arr[0] image1]]];
        [cell3.image6 sd_setImageWithURL:[NSURL URLWithString:[arr[2] image1]]];
        return cell3;
    }
    return nil;
}

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

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        self.page.currentPage = self.scrollView.contentOffset.x/WIDTH;
    }
}

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
    if (indexPath.section == 0 && indexPath.row == 0) {
        self.tabBarController.selectedIndex = 1;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        self.tabBarController.selectedIndex = 2;
    } else if (indexPath.section == 2 ) {
        self.tabBarController.selectedIndex = 3;
    } else {
        self.tabBarController.selectedIndex = 3;
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
