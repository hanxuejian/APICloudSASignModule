//
//  SignImageView.h
//  EFlightDelivery
//
//  Created by LiuXiaoMeng on 15-9-11.
//  Copyright (c) 2015年 SpringAirlines. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSALineAddNotification @"kSALineAddNotification"

@interface SignImageView : UIView

@property (nonatomic,strong) NSMutableArray *lineArray;//每次触摸结束后的线数组

-(void)addPA:(CGPoint)nPoint;
-(void)addLA;
-(void)clear;

//-(void)setLineColor:(NSInteger)color;
//-(void)setlineWidth:(NSInteger)width;

//颜色替换
+ (UIImage*) imageToTransparent:(UIImage*) image;

@end
