//
//  SASignModule.m
//  SASignModule
//
//  Created by HanXueJian on 2018/3/15.
//  Copyright © 2018年 Spring Air Lines. All rights reserved.
//

#import "SASignModule.h"
#import "UZAppDelegate.h"
#import "NSDictionaryUtils.h"
#import "CabinSignView.h"

@interface SASignModule ()<CabinSignViewDeleagte>
{
    NSInteger _cbId;
    CGFloat _width;
    CGFloat _height;
    NSString *_path;
}

@end

@implementation SASignModule

- (id)initWithUZWebView:(UZWebView *)webView_ {
    if (self = [super initWithUZWebView:webView_]) {
        
    }
    return self;
}

- (void)dispose {
    //do clean
}

- (void)showSignView:(NSDictionary *)paramDict {
    _cbId = [paramDict integerValueForKey:@"cbId" defaultValue:0];
    
    NSString *path = [paramDict stringValueForKey:@"path" defaultValue:nil];
    if (path) {
        _path = [self getPathWithUZSchemeURL:path];
    }
    _width = [paramDict floatValueForKey:@"width" defaultValue:0];
    _height = [paramDict floatValueForKey:@"height" defaultValue:0];

    [CabinSignView showSignView:nil delegate:self];
}

#pragma mark - <CabinSignViewDeleagte>
- (void)signImageBack:(UIImage *)image {
    
    if (_width!=0 && _height!=0){
        image = [self imageWithImage:image scaledToSize:CGSizeMake(_width, _height)];
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    BOOL isWriteSuccess = NO;
    if (_path.length != 0){
        [[NSFileManager defaultManager]createDirectoryAtPath:[_path stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
        isWriteSuccess = [imageData writeToFile:_path atomically:YES];
    }
    
    NSDictionary *ret = @{@"imageData":imageData,@"path":_path,@"isImageWriteSuccess":@(isWriteSuccess)};
    [self sendResultEventWithCallbackId:_cbId dataDict:ret errDict:nil doDelete:YES];
}

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

@end
