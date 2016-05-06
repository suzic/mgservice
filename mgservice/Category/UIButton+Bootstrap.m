//
//  UIButton+Bootstrap.m
//  UIButton+Bootstrap
//
//  Created by Oskur on 2013-09-29.
//  Copyright (c) 2013 Oskar Groth. All rights reserved.
//
#import "UIButton+Bootstrap.h"
#import <QuartzCore/QuartzCore.h>
@implementation UIButton (Bootstrap)

-(void)bootstrapStyle{
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 4.0;
    self.layer.masksToBounds = YES;
    [self setAdjustsImageWhenHighlighted:NO];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
}

-(void)setLabelFont:(UIFont*)font
{
[self.titleLabel setFont:font];
}

-(void)defaultStyle
{
    [self bootstrapStyle];
    [self setTitleColor:[UIColor colorWithRed:111/255.0 green:167/255.0 blue:142/255.0 alpha:1]forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

-(void)ukeyStyle{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:122/255.0 green:177/255.0 blue:147/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:122/255.0 green:177/255.0 blue:147/255.0 alpha:1]] forState:UIControlStateHighlighted];
    [self.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
}

-(void)whiteBorderStyle
{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderColor = [[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1] CGColor];
    [self.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
//    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:122/255.0 green:177/255.0 blue:147/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

-(void)worldStyle
{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:122/255.0 green:177/255.0 blue:147/255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:122/255.0 green:177/255.0 blue:147/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor colorWithRed:72/255.0 green:75/255.0 blue:89/255.0 alpha:1.0] forState:UIControlStateHighlighted];
}

- (void)loginSubStyle
{
    [self setAdjustsImageWhenHighlighted:NO];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    self.backgroundColor = [UIColor colorWithRed:122/255.0 green:177/255.0 blue:147/255.0 alpha:1];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:132/255.0 green:118/255.0 blue:120/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

-(void)loginStyle
{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:122/255.0 green:177/255.0 blue:147/255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:122/255.0 green:177/255.0 blue:147/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:132/255.0 green:118/255.0 blue:120/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

-(void)primaryStyle
{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:66/255.0 green:139/255.0 blue:202/255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:53/255.0 green:126/255.0 blue:189/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:51/255.0 green:119/255.0 blue:172/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

-(void)successStyle
{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:92/255.0 green:184/255.0 blue:92/255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:76/255.0 green:174/255.0 blue:76/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:69/255.0 green:164/255.0 blue:84/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

-(void)infoStyle
{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:91/255.0 green:192/255.0 blue:222/255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:70/255.0 green:184/255.0 blue:218/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:57/255.0 green:180/255.0 blue:211/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

-(void)warningStyle
{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:240/255.0 green:173/255.0 blue:78/255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:238/255.0 green:162/255.0 blue:54/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:237/255.0 green:155/255.0 blue:67/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

-(void)dangerStyle{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:212/255.0 green:63/255.0 blue:58/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:210/255.0 green:48/255.0 blue:51/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

- (void)addAwesomeIcon:(FAIcon)icon beforeTitle:(BOOL)before
{
    NSString *iconString = [NSString stringFromAwesomeIcon:icon];
    self.titleLabel.font = [UIFont fontWithName:@"FontAwesome"
                                           size:self.titleLabel.font.pointSize];
    
    NSString *title = [NSString stringWithFormat:@"%@", iconString];
    
    if(self.titleLabel.text) {
        if(before)
            title = [title stringByAppendingFormat:@" %@", self.titleLabel.text];
        else
            title = [NSString stringWithFormat:@"%@  %@", self.titleLabel.text, iconString];
    }
    
    [self setTitle:title forState:UIControlStateNormal];
}

- (UIImage *) buttonImageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
