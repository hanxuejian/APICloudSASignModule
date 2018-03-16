//
//  CabinSignView.m
//  ESafetyOfficerLog
//
//  Created by Carol_M on 16-8-31.
//  Copyright (c) 2016年 SpringAirlines. All rights reserved.
//

#import "CabinSignView.h"
#import "SignImageView.h"

@interface CabinSignView ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (nonatomic, strong) SignImageView *signView;
@property (nonatomic, strong) CAShapeLayer *borderLayer;
@end

@implementation CabinSignView

+ (void)showSignView:(NSString *)title delegate:(id <CabinSignViewDeleagte>)delegate {
    
    NSString *path = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"widget/res/SASignBundle.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    
    NSString *bundle1 = [[NSBundle mainBundle]pathForResource:@"SASignBundle" ofType:@"bundle"];
    
    NSError *error ;
    [bundle loadAndReturnError:&error];
    
    NSLog(@"path : %@ bundle : \n  %@  \n error : %@  | %@",path ,bundle ,error,bundle1);
    //bundle = [NSBundle mainBundle];
    CabinSignView *csView = [[bundle loadNibNamed:@"CabinSignView" owner:nil options:nil]lastObject];
    csView.delegate = delegate;
    csView.titleLabel.text = title.length == 0 ? @"签 字" : title;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    csView.frame = window.bounds;
    [window addSubview:csView];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(btnIsActiveForLine) name:kSALineAddNotification object:nil];
}

- (void)layoutSubviews {
    CGFloat startY = self.titleLabel.frame.origin.x + self.titleLabel.frame.size.height;
    CGFloat height = self.contentView.frame.size.height - startY;
    CGRect rect = CGRectMake(0, startY, self.contentView.frame.size.width, height);
    self.signView.frame = rect;
    
    //[self.borderLayer removeFromSuperlayer];
    //self.borderLayer.frame = self.contentView.bounds;
    //self.borderLayer.position = CGPointMake(CGRectGetMidX(self.contentView.bounds), CGRectGetMidY(self.contentView.bounds));
    //[self.contentView.layer addSublayer:self.borderLayer];
    //[self.contentView.layer setNeedsLayout];
    
    CGFloat width = self.contentView.superview.bounds.size.width/2.0;
    rect = self.clearButton.frame;
    rect.origin.x = width - 200 - 30;
    self.clearButton.frame = rect;
    rect.origin.x = width + 30;
    self.saveButton.frame = rect;
}

- (void)initView {
    CGFloat startY = self.titleLabel.frame.origin.x + self.titleLabel.frame.size.height;
    CGFloat height = self.contentView.frame.size.height - startY;
    CGRect rect = CGRectMake(0, startY, self.contentView.frame.size.width, height);
    
    self.signView = [[SignImageView alloc]initWithFrame:rect];
    self.signView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.signView];
    
    /*//虚线边框
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.bounds = self.contentView.layer.bounds;//rect;//CGRectMake(50, 50, 800, 450);
    borderLayer.position = CGPointMake(CGRectGetMidX(self.contentView.bounds), CGRectGetMidY(self.contentView.bounds));
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:3].CGPath;
    borderLayer.lineWidth = 1;
    borderLayer.lineDashPattern = @[@4, @4];
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = [UIColor grayColor].CGColor;
    self.borderLayer = borderLayer;
    [self.contentView.layer addSublayer:borderLayer];*/
    
    self.clearButton.layer.cornerRadius = 5.0;
    self.clearButton.titleLabel.numberOfLines = 2;
    self.saveButton.layer.cornerRadius = 5.0;
    self.saveButton.titleLabel.numberOfLines = 2;
    [self btnIsActiveForLine];
}

#pragma mark -返回点击事件
- (IBAction)closeBtnClicked:(id)sender {
    [self removeFromSuperview];
}

#pragma mark -清空点击事件
- (IBAction)clearBtnClicked:(id)sender {
    [self.signView clear];
}

#pragma mark -保存点击事件
- (IBAction)saveBtnClicked:(id)sender {
    UIImage *image = [self saveScreen];
    if (self.delegate && [self.delegate respondsToSelector:@selector(signImageBack:)]) {
        [self.delegate signImageBack:image];
    }
    [self removeFromSuperview];
}

- (UIImage *)saveScreen{
    UIView *screenView = self.signView;
    UIGraphicsBeginImageContext(screenView.bounds.size);
    [screenView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"001.png"];
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:filePath atomically:YES];
    return  image;
}

#pragma mark -判断页面是否无笔迹按钮的活性
- (void)btnIsActiveForLine {
    if (self.signView.lineArray.count == 0) {
        self.clearButton.enabled = NO;
        self.saveButton.enabled = NO;
        self.clearButton.backgroundColor = [UIColor colorWithRed:144/255.0 green:145/255.0 blue:155/255.0 alpha:1.0];
        [self.clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.saveButton.backgroundColor = [UIColor colorWithRed:144/255.0 green:145/255.0 blue:155/255.0 alpha:1.0];
        [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else {
        self.clearButton.enabled = YES;
        self.saveButton.enabled = YES;
        self.clearButton.backgroundColor = [UIColor colorWithRed:162/255.0 green:227/255.0 blue:107/255.0 alpha:1.0];
        [self.clearButton setTitleColor:[UIColor colorWithRed:71/255.0 green:109/255.0 blue:39/255.0 alpha:1.0] forState:UIControlStateNormal];
        self.saveButton.backgroundColor = [UIColor colorWithRed:162/255.0 green:227/255.0 blue:107/255.0 alpha:1.0];
        [self.saveButton setTitleColor:[UIColor colorWithRed:71/255.0 green:109/255.0 blue:39/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
