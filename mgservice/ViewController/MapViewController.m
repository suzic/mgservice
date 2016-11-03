//
//  MapViewController.m
//  mgservice
//
//  Created by liuchao on 2016/11/3.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "MapViewController.h"
#import "InTaskController.h"

@interface MapViewController ()<FMKMapViewDelegate,FMKSearchAnalyserDelegate,FMKLayerDelegate>

@property (weak, nonatomic) IBOutlet UIView *inTaskView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inTaskTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inTaskBottom;
@property (assign, nonatomic) BOOL showFinish;
@property (retain, nonatomic) UIAlertController *alertController;

@property (strong, nonatomic) FMMangroveMapView *mangroveMapView;
@property (strong, nonatomic) NSString *mapPath;


@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.inTaskTop.constant = kScreenHeight - 64;
    self.title = @"当前执行中任务";
    self.navigationItem.hidesBackButton = YES;//隐藏后退按钮

    self.inTaskTop.constant = self.view.frame.size.height - 124;
    self.inTaskBottom.constant = 64 - self.view.frame.size.height;
    
    self.alertController = [UIAlertController alertControllerWithTitle:@"消息通知" message:@"您的距离客人距离十米，请完成当前任务吧 ！" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof (self) weakSelf = self;
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.intaskController NETWORK_reloadWorkStatusTask];
        
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //        _showFinish = NO;
    }];
    [self.alertController addAction:cancelAction];
    [self.alertController addAction:action];
    
    [self addFengMap];
}

- (void)addFengMap
{
    _mapPath = [[NSBundle mainBundle] pathForResource:@"79980" ofType:@"fmap"];
    _mangroveMapView = [[FMMangroveMapView alloc] initWithFrame:self.view.bounds path:_mapPath delegate:self];
    [self.view insertSubview:_mangroveMapView belowSubview:self.inTaskView];
    
    FMKExternalModelLayer * modelLayer = [self.mangroveMapView.map getExternalModelLayerWithGroupID:@"1"];
    modelLayer.delegate = self;

}

- (void)setShowFinish:(BOOL)showFinish
{
    if (_showFinish == showFinish)
        return;
    _showFinish = showFinish;
    
    
    if (_showFinish == YES)
    {
        [self presentViewController:self.alertController animated:YES completion:nil];
        
    }else
    {
        [self.alertController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}


- (void)showMsgView:(BOOL)show
{
    //这里的rightBarButton是“收起”按钮，现在暂时改为“刷新”按钮，因此注释掉，将来改回来的时候，将注释代码解开即可。
    //    self.navigationItem.rightBarButtonItem = show ? self.intaskController.showMap : nil;
    CGRect showHistoryRect = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    CGRect hideHistoryRect = CGRectMake(0, self.view.frame.size.height - 60, self.view.frame.size.width, self.view.frame.size.height - 64);
    [UIView animateWithDuration:0.25f animations:^{
        [self.inTaskView setFrame:show ? showHistoryRect : hideHistoryRect];
        self.inTaskTop.constant = show ? 0.0f : self.view.frame.size.height - 124;
        self.inTaskBottom.constant = show ? 0.0f : 60 - self.view.frame.size.height;
    } completion:^(BOOL finished) {
    }];
    
}

- (IBAction)tenMButton:(id)sender
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"任务已完成" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.intaskController NETWORK_reloadWorkStatusTask];
    }];
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)showMapButton:(id)sender
{
    //点击刷新按钮后，即根据任务号，查询任务信息。
    [self.intaskController NETWORK_TaskStatus];
    /*
     这里的代码是点击“收起”后的操作，现在暂时将“收起”改为“刷新”按钮，因此注释，以后改回来的时候解开注释即可。
     [self showMsgView:NO];
     [self.intaskController.conversationView.messageInputView resignFirstResponder];
     self.intaskController.showTalk = NO;
     [self.intaskController deallocInstantMessageing];
     [self.intaskController.conversation markConversationAsRead];
     self.intaskController.showMessageLabel = YES;
     self.intaskController.messageLabel.hidden = YES;
     */
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showInTask"])
    {
        self.intaskController = (InTaskController *)[segue destinationViewController];
        self.intaskController.mapViewController = self;
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
