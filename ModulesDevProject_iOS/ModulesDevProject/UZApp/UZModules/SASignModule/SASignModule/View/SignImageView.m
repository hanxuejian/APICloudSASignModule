//
//  SignImageView.m
//  EFlightDelivery
//
//  Created by LiuXiaoMeng on 15-9-11.
//  Copyright (c) 2015年 SpringAirlines. All rights reserved.
//

#import "SignImageView.h"

@implementation SignImageView

//保存线条颜色
static NSMutableArray *colorArray;
//保存被移除的线条颜色
static NSMutableArray *deleColorArray;
//每次触摸结束前经过的点，形成线的点数组
static NSMutableArray *pointArray;
//删除的线的数组，方便重做时取出来
static NSMutableArray *deleArray;
//线条宽度的数组
static float lineWidthArray[10]={5.0,10.0,12.0,14.0,16.0,20.0,22.0,24.0,26.0,28.0};
//删除线条时删除的线条宽度储存的数组
static NSMutableArray *deleWidthArray;
//正常存储的线条宽度的数组
static NSMutableArray *WidthArray;
//确定颜色的值，将颜色计数的值存到数组里默认为0，即为黑色
static int colorCount;
//确定宽度的值，将宽度计数的值存到数组里默认为0，即为5.0
static int widthCount;
//保存颜色的数组
static NSMutableArray *colors;
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化颜色数组，将用到的颜色存储到数组里
        colors=[[NSMutableArray alloc]initWithObjects:[UIColor blackColor],[UIColor greenColor],[UIColor blueColor],[UIColor redColor],[UIColor blackColor],[UIColor whiteColor], nil];
        WidthArray=[[NSMutableArray alloc]init];
        deleWidthArray=[[NSMutableArray alloc]init];
        pointArray=[[NSMutableArray alloc]init];
        self.lineArray=[[NSMutableArray alloc]init];
        deleArray=[[NSMutableArray alloc]init];
        colorArray=[[NSMutableArray alloc]init];
        deleColorArray=[[NSMutableArray alloc]init];
        //颜色和宽度默认都取当前数组第0位为默认值
        colorCount=0;
        widthCount=0;
        // Initialization code
    }
    return self;
}

/*
//给界面按钮操作时获取tag值作为width的计数。来确定宽度，颜色同理
-(void)setlineWidth:(NSInteger)width{
    widthCount=width;
}
-(void)setLineColor:(NSInteger)color{
    colorCount=color;
}
 */

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//uiview默认的drawRect方法，覆盖重写，可在界面上重绘，并将AViewController.xib的文件设置为自定义的MyView
- (void)drawRect:(CGRect)rect
{
    //获取当前上下文，
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 10.0f);
    //线条拐角样式，设置为平滑
    CGContextSetLineJoin(context,kCGLineJoinRound);
    //线条开始样式，设置为平滑
    CGContextSetLineCap(context, kCGLineCapRound);
    //查看lineArray数组里是否有线条，有就将之前画的重绘，没有只画当前线条
    if ([self.lineArray count]>0) {
        for (int i=0; i<[self.lineArray count]; i++) {
            NSArray * array=[NSArray
                             arrayWithArray:[self.lineArray objectAtIndex:i]];
            
            if ([array count]>0)
            {
                CGContextBeginPath(context);
                CGPoint myStartPoint=CGPointFromString([array objectAtIndex:0]);
                CGContextMoveToPoint(context, myStartPoint.x, myStartPoint.y);
                
                for (int j=0; j<[array count]-1; j++)
                {
                    CGPoint myEndPoint=CGPointFromString([array objectAtIndex:j+1]);
                    //--------------------------------------------------------
                    CGContextAddLineToPoint(context, myEndPoint.x,myEndPoint.y);
                }
                //获取colorArray数组里的要绘制线条的颜色
                NSNumber *num=[colorArray objectAtIndex:i];
                int count=[num intValue];
                UIColor *lineColor=[colors objectAtIndex:count];
                //获取WidthArray数组里的要绘制线条的宽度
                NSNumber *wid=[WidthArray objectAtIndex:i];
                int widthc=[wid intValue];
                float width=lineWidthArray[widthc];
                //设置线条的颜色，要取uicolor的CGColor
                CGContextSetStrokeColorWithColor(context,[lineColor CGColor]);
                //-------------------------------------------------------
                //设置线条宽度
                CGContextSetLineWidth(context, width);
                //保存自己画的
                CGContextStrokePath(context);
            }
        }
    }
    //画当前的线
    if ([pointArray count]>0)
    {
        CGContextBeginPath(context);
        CGPoint myStartPoint=CGPointFromString([pointArray objectAtIndex:0]);
        CGContextMoveToPoint(context, myStartPoint.x, myStartPoint.y);
        
        for (int j=0; j<[pointArray count]-1; j++)
        {
            CGPoint myEndPoint=CGPointFromString([pointArray objectAtIndex:j+1]);
            //--------------------------------------------------------
            CGContextAddLineToPoint(context, myEndPoint.x,myEndPoint.y);
        }
        UIColor *lineColor=[colors objectAtIndex:colorCount];
        float width=lineWidthArray[widthCount];
        CGContextSetStrokeColorWithColor(context,[lineColor CGColor]);
        //-------------------------------------------------------
        CGContextSetLineWidth(context, width);
        CGContextStrokePath(context);
    }
    
    
}
//在touch结束前将获取到的点，放到pointArray里
-(void)addPA:(CGPoint)nPoint{
    NSString *sPoint=NSStringFromCGPoint(nPoint);
    [pointArray addObject:sPoint];
}
//在touchend时，将已经绘制的线条的颜色，宽度，线条线路保存到数组里
-(void)addLA{
    NSNumber *wid=[[NSNumber alloc]initWithInt:widthCount];
    NSNumber *num=[[NSNumber alloc]initWithInt:colorCount];
    [colorArray addObject:num];
    [WidthArray addObject:wid];
    NSArray *array=[NSArray arrayWithArray:pointArray];
    [self.lineArray addObject:array];
    pointArray=[[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter]postNotificationName:kSALineAddNotification object:self.lineArray];
}


//手指开始触屏开始
static CGPoint MyBeganpoint;
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}
//手指移动时候发出
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch=[touches anyObject];
    MyBeganpoint=[touch locationInView:self];
    NSString *sPoint=NSStringFromCGPoint(MyBeganpoint);
    [pointArray addObject:sPoint];
    [self setNeedsDisplay];
}
//当手指离开屏幕时候
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self addLA];
}


//颜色替换
+ (UIImage*) imageToTransparent:(UIImage*) image
{
    // 分配内存
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++)
    {
        
        
        
        //把绿色变成黑色，把背景色变成透明
        if ((*pCurPtr & 0x65815A00) == 0x65815a00)    // 将背景变成透明
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
        else if ((*pCurPtr & 0x00FF0000) == 0x00ff0000)    // 将绿色变成黑色
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = 0; //0~255
            ptr[2] = 0;
            ptr[1] = 0;
        }
        else if ((*pCurPtr & 0xFFFFFF00) == 0xffffff00)    // 将白色变成透明
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
        else
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = 0; //0~255
            ptr[2] = 0;
            ptr[1] = 0;
        }
        
    }
    
    // 将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    // free(rgbImageBuf) 创建dataProvider时已提供释放函数，这里不用free
    
    return resultUIImage;
}

/** 颜色变化 */
void ProviderReleaseData (void *info, const void *data, size_t size)
{
    free((void*)data);
}


-(void)clear{
    //移除所有信息并重绘
    [deleArray removeAllObjects];
    [deleColorArray removeAllObjects];
    colorCount=0;
    [colorArray removeAllObjects];
    [self.lineArray removeAllObjects];
    [pointArray removeAllObjects];
    [deleWidthArray removeAllObjects];
    widthCount=0;
    [WidthArray removeAllObjects];
    [self setNeedsDisplay];
    [[NSNotificationCenter defaultCenter]postNotificationName:kSALineAddNotification object:self.lineArray];
}
@end


