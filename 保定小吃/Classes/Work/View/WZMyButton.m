//
//  WZMyButton.m
//  保定小吃
//
//  Created by 王震 on 14-9-13.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//  自定义button样式

#import "WZMyButton.h"

@implementation WZMyButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    // Center image
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width/2;
    center.y = self.imageView.frame.size.height/2;
    self.imageView.center = center;
    //Center text
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = self.imageView.frame.size.height + 65;
    newFrame.size.width = self.frame.size.width;

    self.titleLabel.frame = newFrame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
}
@end
