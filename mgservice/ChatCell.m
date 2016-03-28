//
//  ChatCell.m
//  mgservice
//
//  Created by sjlh on 16/3/24.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "ChatCell.h"
#import "UIImage+ResizeImage.h"
#import "NSString+Addtions.h"
@interface ChatCell ()

@property (retain, nonatomic) UIButton *messageButton;
@property (retain, nonatomic) UIImageView *userView;

@end;
@implementation ChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //文本
    self.messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.messageButton.titleLabel.numberOfLines = 0;
    self.messageButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [self.messageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.messageButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 12, 10);
    self.messageButton.enabled = NO;
    [self.contentView addSubview:self.messageButton];
    self.userView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img82"]];
    [self.contentView addSubview:self.userView];
}

- (void)setTaskChat:(DBTaskChat *)taskChat
{
    if (_taskChat != taskChat)
    {
        _taskChat = taskChat;
        // 服务员发送消息
//        if ([_taskChat.byUserOrWaiter isEqualToString:@"0"])
//        {
            self.messageButton.frame = [self setUpButtonFrame:@"你好,我是客人，请问你有什么服务?" withMessageType:@"0"];
            [self.messageButton setBackgroundImage:[UIImage resizeImage:@"icon_message_user"] forState:UIControlStateNormal];//taskChat.answer
        
//        }
        // 用户发出的消息
//        else if ([_taskChat.byUserOrWaiter isEqualToString:@"1"])
//        {
//            self.messageButton.frame = [self setUpButtonFrame:@"你好,我是服务员，请问你需要什么服务?" withMessageType:@"1"];
//            [self.messageButton setBackgroundImage:[UIImage resizeImage:@"icon_message_waiter"] forState:UIControlStateNormal];//taskChat.question
//        }
        
    }
}
- (CGRect)setUpButtonFrame:(NSString *)text withMessageType:(NSString *)messageType
{
    //3.内容的Frame
    CGSize textMaxSize = CGSizeMake(200,MAXFLOAT);
    CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:16.0] maxSize:textMaxSize];
    CGSize textRealSize = CGSizeMake(textSize.width ,textSize.height );
    CGFloat textFrameY = 5;
    CGFloat textFrameX = 10;
    
    CGFloat iconFrameX = 0;
    // 服务员
//    if ([messageType isEqualToString:@"0"])
//    {
        textFrameX = 40;
        iconFrameX = 5;
//    }
    // 用户
//    else if ([messageType isEqualToString:@"1"])
//    {
//        textFrameX = kScreenWidth- textRealSize.width-55;
//        iconFrameX = kScreenWidth - 35;
//    }
    self.userView.frame = CGRectMake(iconFrameX, 0, 40, 40);
    CGRect textFrame = (CGRect){textFrameX, textFrameY, textRealSize.width +25,textRealSize.height + 10};
    [self.messageButton setTitle:text forState:UIControlStateNormal];
    return textFrame;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
