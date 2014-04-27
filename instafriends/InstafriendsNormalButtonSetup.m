//
//  InstafriendsNormalButtonSetup.m
//  instafriends
//
//  Created by Daniel Camargo on 14/08/12.
//  Copyright (c) 2012 Daniel Camargo. All rights reserved.
//

#import "InstafriendsNormalButtonSetup.h"

@implementation InstafriendsNormalButtonSetup

+(void)setupButton:(UIButton *) button{
    UIImage * buttonBackground = [UIImage imageNamed:@"buttonNormal.png"];
    float w = buttonBackground.size.width / 2, h = buttonBackground.size.height / 2;
    UIImage *stretch = [buttonBackground stretchableImageWithLeftCapWidth:w topCapHeight:h];
    [button setBackgroundImage:stretch forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0]];
    [button setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
}

@end
