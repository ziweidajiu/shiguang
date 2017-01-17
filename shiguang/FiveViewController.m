//
//  FiveViewController.m
//  shiguang
//
//  Created by 紫薇大舅 on 16/5/12.
//  Copyright © 2016年 ziweidajiu. All rights reserved.
//

#import "FiveViewController.h"
#import "DiwuyeTableViewCell.h"
#import "FiveToNewViewController.h"
#import "FiveToTwoViewController.h"
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface FiveViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource1;

@property (nonatomic, strong) NSMutableArray *dataSource2;

@property (nonatomic, strong) NSMutableArray *dataSource3;

@property (nonatomic, strong) UIButton *btn1;

@property (nonatomic, strong) UIButton *btn2;

@property (nonatomic, strong) UIButton *btn3;

@end

@implementation FiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    [self createDataSource];
    [self createTableView];
}

-(void)createDataSource {
    self.dataSource1 = [[NSMutableArray alloc] initWithObjects:@"我的优惠券", @"我的电影", @"我的收藏", nil];
    self.dataSource2 = [[NSMutableArray alloc] initWithObjects:@"icon_my_collection@3x ", @"icon_my_movie@3x ", @"icon_my_collection@3x ", nil];
    self.dataSource3 = [[NSMutableArray alloc] initWithObjects:@"设置", @"扫描二维码", @"意见反馈", @"喜欢我们，去打分", @"商城使用帮助", nil];
}

-(void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, WIDTH, HEIGH) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self createHeadView:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"DiwuyeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
}

-(void)createHeadView:(UITableView *)tableView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 150)];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 150)];
    image.image = [UIImage imageNamed:@"icon_myinfo_top@3x.jpg"];
    [view addSubview:image];
    if ([UserList sharedInstance].currentUser.mobile == nil) {
        _btn1 = [[UIButton alloc] initWithFrame:CGRectMake(120, 70, 70, 30)];
        [_btn1 setBackgroundImage:[UIImage imageNamed:@"icon_hot_show_buy@3x"] forState:UIControlStateNormal];
        [_btn1 setTitle:@"登录" forState:UIControlStateNormal];
        _btn1.titleLabel.font = [UIFont systemFontOfSize:15];
        [_btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view addSubview:_btn1];
        [_btn1 addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _btn2 = [[UIButton alloc] initWithFrame:CGRectMake(210, 70, 70, 30)];
        [_btn2 setBackgroundImage:[UIImage imageNamed:@"icon_release_remind@2x"] forState:UIControlStateNormal];
        [_btn2 setTitle:@"注册" forState:UIControlStateNormal];
        _btn2.titleLabel.font = [UIFont systemFontOfSize:15];
        [_btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view addSubview:_btn2];
        [_btn2 addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(120, 80, 200, 20)];
        label.text = [UserList sharedInstance].currentUser.mobile;
        label.textColor = [UIColor whiteColor];
        [view addSubview:label];
    }
    _btn3 = [[UIButton alloc] initWithFrame:CGRectMake(340, 30, 25, 20)];
    [_btn3 setBackgroundImage:[UIImage imageNamed:@"icon_sharing@3x"] forState:UIControlStateNormal];
    [view addSubview:_btn3];
    [_btn3 addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(30, 50, 70, 70)];
    image1.image = [UIImage imageNamed:@"icon_avatar_not_login@3x"];
    [view addSubview:image1];
    
    tableView.tableHeaderView = view;
}

-(void)onClick:(UIButton *)btn {
    if (btn == _btn1) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FiveToTwoViewController *two = [story instantiateViewControllerWithIdentifier:@"toTwo"];
        two.block = ^() {
            [self createHeadView:self.tableView];
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:two animated:YES];
    } else if (btn == _btn2) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FiveToNewViewController *new = [story instantiateViewControllerWithIdentifier:@"newFive"];
        [self.navigationController pushViewController:new animated:YES];
    } else {
        //1、创建分享参数
        NSArray* imageArray = @[[UIImage imageNamed:@"icon_avatar_not_login@3x"]];
        if (imageArray) {
            
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                             images:imageArray
                                                url:[NSURL URLWithString:@"http://mob.com"]
                                              title:@"分享标题"
                                               type:SSDKContentTypeAuto];
            //2、分享（可以弹出我们的分享菜单和编辑界面）
            [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                     items:nil
                               shareParams:shareParams
                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                           
                           switch (state) {
                               case SSDKResponseStateSuccess:
                               {
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                       message:nil
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"确定"
                                                                             otherButtonTitles:nil];
                                   [alertView show];
                                   break;
                               }
                               case SSDKResponseStateFail:
                               {
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                   message:[NSString stringWithFormat:@"%@",error]
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"OK"
                                                                         otherButtonTitles:nil, nil];
                                   [alert show];
                                   break;
                               }
                               default:
                                   break;
                           }
                       }
             ];}

    }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 3;
    } else {
        return 5;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DiwuyeTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        return cell1;
    } else if (indexPath.section == 1) {
        UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!cell2) {
            cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        cell2.imageView.image = [UIImage imageNamed:self.dataSource2[indexPath.row]];
        cell2.textLabel.text = self.dataSource1[indexPath.row];
        cell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell2.textLabel.font = [UIFont systemFontOfSize:15];
        return cell2;
    } else {
        UITableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (!cell3) {
            cell3 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell3"];
        }
        cell3.textLabel.text = self.dataSource3[indexPath.row];
        cell3.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell3.textLabel.font = [UIFont systemFontOfSize:15];
        return cell3;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    } else {
        return 42;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
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
