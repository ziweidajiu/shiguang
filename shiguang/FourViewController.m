//
//  FourViewController.m
//  shiguang
//
//  Created by 紫薇大舅 on 16/5/10.
//  Copyright © 2016年 ziweidajiu. All rights reserved.
//

#import "FourViewController.h"
#import "DisiyeOneStore.h"
#import "DisiyeOneTableViewCell.h"
#import "DisiyeTwoTableViewCell.h"
#import "DisiyeTwoStore.h"
#import "DisiyeThreeTableViewCell.h"
#import "DisiyeFiveTableViewCell.h"
#import "DisiyeFourStore.h"
#import "DisiyeThreeStore.h"

@interface FourViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, assign) int location;

@property (nonatomic, assign) int num1;

@property (nonatomic, assign) int num2;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UITableView *tableView1;

@property (nonatomic, assign) BOOL judge1;

@property (nonatomic, strong) UITableView *tableView2;

@property (nonatomic, assign) BOOL judge2;

@property (nonatomic, strong) UITableView *tableView4;

@property (nonatomic, assign) BOOL judge4;

@property (nonatomic, strong) UITableView *tableView3;

@property (nonatomic, assign) BOOL judge3;

@end

@implementation FourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"icon_myinfo_top@3x.jpg"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    _color = [[UIColor alloc] initWithRed:0.4 green:0.8 blue:1 alpha:1];
    _num1 = 1;
    _num2 = 1;
    [self createUI];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [self createTableView1];
    [self createScrollView];
    [self request];
}

-(void)createUI {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 40)];
    NSArray *arr = @[@"新闻", @"预告片", @"排行榜", @"影评"];
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(80*i, 5, 75, 30)];
        if (i == 0) {
            [btn setTitle:arr[i] forState:UIControlStateNormal];
            [btn setTitleColor:_color forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [btn setTitle:arr[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        btn.tag = i+10;
        [view addSubview:btn];
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(80*i, 38, 75, 2)];
        if (i == 0) {
            image.backgroundColor = _color;
        } else {
            image.backgroundColor = [UIColor clearColor];
        }
        image.tag = i+20;
        [view addSubview:image];
    }
    self.navigationItem.titleView = view;
}

-(void)onClick:(UIButton *)btn {
    for (int i = 0; i < 4; i++) {
        UIButton *btn1 = (id)[self.navigationItem.titleView viewWithTag:i+10];
        [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        UIImageView *image = (id)[self.navigationItem.titleView viewWithTag:i+20];
        image.backgroundColor = [UIColor clearColor];
    }
    [btn setTitleColor:_color forState:UIControlStateNormal];
    UIImageView *image = (id)[self.navigationItem.titleView viewWithTag:btn.tag+10];
    image.backgroundColor = _color;
    _location = (int)btn.tag-10;
    if (_location == 1 && _judge1 == NO) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [self createTableView2];
        [self request2];
        _judge1 = YES;
    } else if (_location == 2 && _judge3 == NO) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [self createTableView3];
        [self request4];
        _judge3 = YES;
    } else {
        if (_judge2 == NO) {
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
            [self createTableView4];
            [self request3];
            _judge2 = YES;
        }
    }
    self.scrollView.contentOffset = CGPointMake(WIDTH*_location, 0);
}

-(void)request {
    DisiyeOneStore *disi = [[DisiyeOneStore alloc] init];
    disi.number = [NSString stringWithFormat:@"%d", _num1];
    [disi requestWithSuccess:^{
        [_tableView1 reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [SVProgressHUD dismiss];
    } failure:^(NSError *responseError) {
        NSLog(@"-----------%@", responseError);
        [SVProgressHUD dismiss];
    }];
}

-(void)request2 {
    DisiyeTwoStore *disi = [[DisiyeTwoStore alloc] init];
    [disi requestWithSuccess:^{
        [_tableView2 reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [SVProgressHUD dismiss];
    } failure:^(NSError *responseError) {
        NSLog(@"-----------%@", responseError);
        [SVProgressHUD dismiss];
    }];
}

-(void)request3 {
    DisiyeFourStore *disi = [[DisiyeFourStore alloc] init];
    [disi requestWithSuccess:^{
        [_tableView4 reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [SVProgressHUD dismiss];
    } failure:^(NSError *responseError) {
        NSLog(@"-----------%@", responseError);
        [SVProgressHUD dismiss];
    }];
}

-(void)request4 {
    DisiyeThreeStore *disi = [[DisiyeThreeStore alloc] init];
    disi.number = [NSString stringWithFormat:@"%d", _num2];
    [disi requestWithSuccess:^{
        [_tableView3 reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [SVProgressHUD dismiss];
    } failure:^(NSError *responseError) {
        NSLog(@"错误");
        [SVProgressHUD dismiss];
    }];
}

-(void)createScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGH)];
    self.scrollView.contentSize = CGSizeMake(WIDTH*4, HEIGH-64);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView addSubview:self.tableView1];
    self.scrollView.contentOffset = CGPointMake(WIDTH*_location, 0);
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    [self.view addSubview:self.scrollView];
}

-(void)createHeadView:(UITableView *)tableView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
    Dierye *dier = [DieryeList sharedInstance].movies1[tableView.tag-39];
    [image1 sd_setImageWithURL:[NSURL URLWithString:dier.image]];
    [view addSubview:image1];
    UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 170, WIDTH, 30)];
    image2.backgroundColor = [UIColor blackColor];
    image2.alpha = 0.5;
    [view addSubview:image2];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 170, WIDTH-40, 30)];
    label.text = dier.title;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    tableView.rowHeight = 150;
    tableView.tableHeaderView = view;
}

-(void)createTableView1 {
    self.tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGH) style:UITableViewStylePlain];
    self.tableView1.dataSource = self;
    self.tableView1.delegate = self;
    self.tableView1.tag = 40;
    [self createHeadView:self.tableView1];
    [self.tableView1 registerNib:[UINib nibWithNibName:@"DisiyeOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [self.tableView1 registerNib:[UINib nibWithNibName:@"DisiyeTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
}

-(void)createTableView2 {
    self.tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH, 0, WIDTH, HEIGH) style:UITableViewStylePlain];
    self.tableView2.dataSource = self;
    self.tableView2.delegate = self;
    self.tableView2.tag = 41;
    [self createHeadView:self.tableView2];
    [self.scrollView addSubview:self.tableView2];
    [self.tableView2 registerNib:[UINib nibWithNibName:@"DisiyeThreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell3"];
}

-(void)createTableView3 {
    self.tableView3 = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH*2, 0, WIDTH, HEIGH) style:UITableViewStylePlain];
    self.tableView3.dataSource = self;
    self.tableView3.delegate = self;
    self.tableView3.tag = 42;
    [self createHeadView:self.tableView3];
    [self.scrollView addSubview:self.tableView3];
}

-(void)createTableView4 {
    self.tableView4 = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH*3, 0, WIDTH, HEIGH) style:UITableViewStylePlain];
    self.tableView4.dataSource = self;
    self.tableView4.delegate = self;
    self.tableView4.tag = 43;
    [self createHeadView:self.tableView4];
    [self.scrollView addSubview:self.tableView4];
    [self.tableView4 registerNib:[UINib nibWithNibName:@"DisiyeFiveTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell5"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableView1) {
        if ([DisiyeList sharedInstance].news1 == nil) {
            return 0;
        }
        return [[DisiyeList sharedInstance].news1 count];
    } else if (tableView == _tableView2) {
        if ([DisiyeList sharedInstance].prevues1 == nil) {
            return 0;
        }
        return [[DisiyeList sharedInstance].prevues1 count];
    } else if (tableView == _tableView4) {
        if ([DisiyeList sharedInstance].comments == nil) {
            return 0;
        }
        return [[DisiyeList sharedInstance].comments count];
    } else {
        if ([DisiyeList sharedInstance].charts == nil) {
            return 0;
        }
        return [[DisiyeList sharedInstance].charts count];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableView1) {
        Disiye *disi = [DisiyeList sharedInstance].news1[indexPath.row];
        if (disi.images.count == 0) {
            DisiyeOneTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
            [cell1.image1 sd_setImageWithURL:[NSURL URLWithString:disi.image]];
            cell1.label1.text = disi.title;
            cell1.label2.text = disi.content;
            cell1.label3.text = disi.comment;
            return cell1;
        } else {
            DisiyeTwoTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
            cell2.label1.text = disi.title;
            cell2.label2.text = disi.comment;
            [cell2.image1 sd_setImageWithURL:[NSURL URLWithString:disi.images[0]]];
            [cell2.image2 sd_setImageWithURL:[NSURL URLWithString:disi.images[1]]];
            [cell2.image3 sd_setImageWithURL:[NSURL URLWithString:disi.images[2]]];
            return cell2;
        }
    } else if (tableView == _tableView2) {
        Disiye *disi = [DisiyeList sharedInstance].prevues1[indexPath.row];
        DisiyeThreeTableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
        cell3.label1.text = disi.title;
        cell3.label2.text = disi.content;
        [cell3.image1 sd_setImageWithURL:[NSURL URLWithString:disi.image]];
        return cell3;
    } else if (tableView == _tableView4) {
        Disiye *disi = [DisiyeList sharedInstance].comments[indexPath.row];
        DisiyeFiveTableViewCell *cell5 = [tableView dequeueReusableCellWithIdentifier:@"cell5" forIndexPath:indexPath];
        cell5.label1.text = disi.title;
        NSString *str = [disi.content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        cell5.label2.text = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        cell5.label3.text = [NSString stringWithFormat:@"%@ - 评《%@》评分:%@", disi.userName, disi.moviewName, disi.comment];
        [cell5.image1 sd_setImageWithURL:[NSURL URLWithString:disi.userImage]];
        [cell5.image2 sd_setImageWithURL:[NSURL URLWithString:disi.image]];
        return cell5;
    } else {
        UITableViewCell *cell6 = [tableView dequeueReusableCellWithIdentifier:@"cell6"];
        if (!cell6) {
            cell6 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell6"];
        }
        cell6.textLabel.text = [[DisiyeList sharedInstance].charts[indexPath.row] title];
        return cell6;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableView1) {
        if ([[[DisiyeList sharedInstance].news1[indexPath.row] images] count] == 0) {
            return 90;
        } else {
            return 120;
        }
    } else if (tableView == _tableView2) {
        return 100;
    } else if (tableView == _tableView4) {
        return 120;
    } else {
        return 50;
    }
    return 100;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _tableView1) {
        float tableViewHeight = self.tableView1.frame.size.height;
        float tableViewContentY = self.tableView1.contentOffset.y;
        float tableViewContentHeight = self.tableView1.contentSize.height;
        if (tableViewHeight+tableViewContentY > tableViewContentHeight+100) {
            _num1+=1;
            [self request];
        }
    } else if (scrollView == _tableView3) {
        float tableViewHeight = self.tableView3.frame.size.height;
        float tableViewContentY = self.tableView3.contentOffset.y;
        float tableViewContentHeight = self.tableView3.contentSize.height;
        if (tableViewHeight+tableViewContentY > tableViewContentHeight+100) {
            _num2+=1;
            [self request4];
        }
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        for (int i = 0; i < 4; i++) {
            UIButton *btn1 = (id)[self.navigationItem.titleView viewWithTag:i+10];
            [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            UIImageView *image = (id)[self.navigationItem.titleView viewWithTag:i+20];
            image.backgroundColor = [UIColor clearColor];
        }
        UIButton *btn = (id)[self.navigationItem.titleView viewWithTag:self.scrollView.contentOffset.x/WIDTH+10];
        [btn setTitleColor:_color forState:UIControlStateNormal];
        UIImageView *image = (id)[self.navigationItem.titleView viewWithTag:self.scrollView.contentOffset.x/WIDTH+20];
        image.backgroundColor = _color;
    }
    _location = self.scrollView.contentOffset.x/WIDTH;
    if (_location == 1 && _judge1 == NO) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [self createTableView2];
        [self request2];
        _judge1 = YES;
    } else if (_location == 2 && _judge3 == NO) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [self createTableView3];
        [self request4];
        _judge3 = YES;
    } else {
        if (_judge2 == NO) {
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
            [self createTableView4];
            [self request3];
            _judge2 = YES;
        }
    }
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
