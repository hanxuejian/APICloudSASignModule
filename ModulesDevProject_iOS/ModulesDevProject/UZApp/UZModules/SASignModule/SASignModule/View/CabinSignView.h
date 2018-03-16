//
//  CabinSignView.h
//  ESafetyOfficerLog
//
//  Created by Carol_M on 16-8-31.
//  Copyright (c) 2016年 SpringAirlines. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CabinSignViewDeleagte;

@interface CabinSignView : UIView

///签名标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, weak)id <CabinSignViewDeleagte> delegate;

///显示签名界面
+ (void)showSignView:(NSString *)title delegate:(id <CabinSignViewDeleagte>)delegate;

@end

@protocol CabinSignViewDeleagte<NSObject>

///返回签名图片
- (void)signImageBack: (UIImage *)image;

@end
