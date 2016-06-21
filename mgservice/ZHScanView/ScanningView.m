//
//  ScanningView.m
//  mgservice
//
//  Created by sjlh on 16/6/16.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "ScanningView.h"
#import "ZHScanView.h"

@interface ScanningView ()

@end

@implementation ScanningView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫描";
    self.view.backgroundColor = [UIColor whiteColor];
    ZHScanView *scanf = [ZHScanView scanViewWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height)];
    scanf.promptMessage = @"请扫描二维码";
    [self.view addSubview:scanf];
    
    [scanf startScaning];
    
    [scanf outPutResult:^(NSString *result)
     {
         NSLog(@"%@",result);
         NSDictionary *dataDict = [NSDictionary dictionaryWithObject:@(NO) forKey:@"showInfor"];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"showInforAction" object:nil userInfo:dataDict];
         [self.navigationController popViewControllerAnimated:YES];
     }];
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
