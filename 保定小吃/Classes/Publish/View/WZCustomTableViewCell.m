//
//  WZCustomTableViewCell.m
//  保定小吃
//
//  Created by 王震 on 14-8-11.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//  自定义TableViewCell

#import "WZCustomTableViewCell.h"
#import "WZImageTool.h"
#import "UILabel+StringFrame.h"
#import "UIImageView+WebCache.h"
#import "WZImageTool.h"
#import "UIImage+WZ.h"
#import "WZCustomUIImageView.h"
#import "Common.h"



#define kUserIconWidth 44 //用户图标距宽度
#define kUserIconHeight 44 //用户图标高度
#define kUserIconLeftMargain 10 //用户图标距左侧的距离
#define kUserIconTopMargain 10 //用户图标距顶部的距离
#define myUserNameleftMargin 10 //用户姓名距离左侧头像的距离
#define myPulishDateTopMargin 20 //发布时间距离发布用户的距离
#define myTextIntroduceTopMargin 40 //用户发布的详情距离上一组件的距离


@implementation WZCustomTableViewCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addCellBg];
        
    }
    return self;
}

-(void) addCellBg
{
    //清空Cell背景色
    self.backgroundColor = [UIColor clearColor];
    //默认Cell背景
    UIImage *image = [UIImage tileMyImage:@"common_card_background.png"];
    self.backgroundView = [[UIImageView alloc] initWithImage:image];// 套用自己的圖片做為背景
    
    
    //选中Cell时的图片背景
    UIImage *image2 = [UIImage tileMyImage:@"common_card_background_highlighted.png"];
    self.selectedBackgroundView =[[UIImageView alloc] initWithImage:image2];// 套用自己的圖片做為背景

    
}


#pragma  mark 为Cell添加自定义样式
- (CGFloat)addCustomStyle
{
    
    CGFloat myCellHeight = 0;
   
    //添加用户头像图片
    UIImageView * myUserIcon  = [[UIImageView alloc] init];
    if(_publicShow.userIcon == NULL || _publicShow.userIcon == nil){
        [myUserIcon setImage:[UIImage imageNamed:@"icon.png"]];
    }else{
        [myUserIcon sd_setImageWithURL:[NSURL URLWithString:_publicShow.userIcon]
                      placeholderImage:[UIImage imageNamed:@"icon.png"]];
    }
   
    
    myUserIcon.frame = CGRectMake(kUserIconLeftMargain, kUserIconTopMargain, kUserIconWidth, kUserIconHeight);
    
    [self.contentView addSubview:myUserIcon];

    
    //添加用户名
    UILabel *myUserName = [[UILabel alloc] initWithFrame:CGRectMake(
    kUserIconWidth + kUserIconLeftMargain +myUserNameleftMargin, kUserIconTopMargain, 100, 20)];
    
    myUserName.text =_publicShow.userName;
    [self.contentView addSubview:myUserName];
    
    
    //添加发布时间
    UILabel *myPulishDate = [[UILabel alloc] initWithFrame:CGRectMake(
                           kUserIconWidth + kUserIconLeftMargain + myUserNameleftMargin, kUserIconTopMargain + myPulishDateTopMargin, 120, 20)];
    
    myPulishDate.text = _publicShow.pulishDate;
    myPulishDate.font = [UIFont fontWithName:nil size:12];
    [self.contentView addSubview:myPulishDate];
    
    //添加文字介绍
    UILabel *myTextIntroduce =[[UILabel alloc] init];
                               
    myTextIntroduce.text = _publicShow.textIntroduce;
    
    myTextIntroduce.font = [UIFont fontWithName:nil size:18];
    
    [myTextIntroduce setNumberOfLines:0];
    //获得UILable中的字头高度
    CGSize myTextIntroduceSize = [myTextIntroduce boundingRectWithSize:CGSizeMake(self.frame.size.width, 0)];
    
    myTextIntroduce.frame = CGRectMake(kUserIconLeftMargain, kUserIconTopMargain + 20 + myTextIntroduceTopMargin,myTextIntroduceSize.width, myTextIntroduceSize.height);
    
    [self.contentView addSubview:myTextIntroduce];
    
    int myFoodIconsHeight = 0;
//    //添加保定小吃图片展示
    NSMutableArray * myFoodIcons =  _publicShow.foodIcons;
    //多图片内容展示
    if(myFoodIcons.count > 0){
        
        int j = 0;
        int imageWidth = self.frame.size.width - 10;
        if(myFoodIcons.count == 2){
            imageWidth = imageWidth / 2;
        }else if(myFoodIcons.count > 2){
            imageWidth = imageWidth / 3;
        }
       
        for (int i = 0; i < myFoodIcons.count; i++) {
            NSMutableDictionary *data = [myFoodIcons objectAtIndex:i];
            NSString *picUrl = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@%@",ROOT,[data objectForKey:@"picUrl"]]];
            UIImageView * myFoodIcon  = [[UIImageView alloc] init];
                        [myFoodIcon sd_setImageWithURL:[NSURL URLWithString:picUrl]
                       placeholderImage:[UIImage imageNamed:@"icon.png"]];
            if(i%3 == 0 && i != 0){
                j++;
            }
            myFoodIcon.contentMode = UIViewContentModeScaleAspectFit;//图片按比例缩放完全显示

            myFoodIcon.frame = CGRectMake( kUserIconLeftMargain + 100 * (i % 3), myTextIntroduceSize.height + kUserIconTopMargain + 30 + myTextIntroduceTopMargin + 100 * j, imageWidth - kUserIconLeftMargain, 200 );
            [self.contentView addSubview:myFoodIcon];
            
        }
        
        //计算展示高度图片
        myFoodIconsHeight = 200 * ((myFoodIcons.count % 3) == 0 ? (myFoodIcons.count / 3) : ((myFoodIcons.count / 3) + 1));
        
        
    }
    
    myCellHeight  += myTextIntroduceSize.height + kUserIconTopMargain + 30 + myTextIntroduceTopMargin + myFoodIconsHeight;
   
    //NSLog(@"%f", myCellHeight);
    
    
    //添加按钮
    WZCustomUIImageView *customUIImageView = [[WZCustomUIImageView alloc] initWithFrame:CGRectMake(0, myCellHeight, self.frame.size.width, 44)];
    
    [self.contentView addSubview:customUIImageView];
    
    
    myCellHeight = myCellHeight + 54;
    return myCellHeight;
}


#pragma  mark 覆盖父类setFrame方法
-(void)setFrame:(CGRect)frame
{
    frame.origin.x = 10;
    frame.origin.y += 10;
    
    frame.size.width -= 10 * 2;
    frame.size.height -= 10;
    [super setFrame:frame];

}



- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
