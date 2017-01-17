//
//  FiveToNewViewController.m
//  shiguang
//
//  Created by 紫薇大舅 on 16/5/12.
//  Copyright © 2016年 ziweidajiu. All rights reserved.
//

#import "FiveToNewViewController.h"
#import "SignUpStore.h"

@interface FiveToNewViewController ()

@property (weak, nonatomic) IBOutlet UITextField *field1;

@property (weak, nonatomic) IBOutlet UITextField *field2;

@property (weak, nonatomic) IBOutlet UITextField *field;


@end

@implementation FiveToNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self commusNavagation];
}

-(void)commusNavagation {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"icon_myinfo_top@3x.jpg"] forBarMetrics:UIBarMetricsDefault];
     UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    image.image = [UIImage imageNamed:@"ele_logo_mtime@3x"];
    self.navigationItem.titleView = image;
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"v10_photoNewsLeft@3x"] style:UIBarButtonItemStyleDone target:self action:@selector(onClick1:)];
    self.navigationItem.leftBarButtonItem = btn;
}

-(void)onClick1:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClick2:(UIButton *)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    SignUpStore *signUp = [[SignUpStore alloc] init];
    signUp.mobile = _field1.text;
    signUp.password = _field2.text;
    signUp.email = _field.text;
    [signUp requestWithSuccess:^{
        [SVProgressHUD dismiss];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"创建成功" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [self presentViewController:alert animated:YES completion:^{
        }];
    } failure:^(NSError *responseError) {
        [SVProgressHUD dismiss];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"创建失败" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alert animated:YES completion:^{
        }];
    }];
}


-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
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
