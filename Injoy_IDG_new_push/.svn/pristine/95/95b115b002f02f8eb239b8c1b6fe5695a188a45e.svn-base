/*
 * QRCodeReaderViewController
 *
 * Copyright 2014-present Yannick Loriot.
 * http://yannickloriot.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "QRCodeReaderView.h"
#import <AVFoundation/AVFoundation.h>
#import "Masonry.h"

#define DeviceMaxHeight ([UIScreen mainScreen].bounds.size.height)
#define DeviceMaxWidth ([UIScreen mainScreen].bounds.size.width)
#define widthRate DeviceMaxWidth/320

#define contentTitleColorStr @"666666" //正文颜色较深

@interface QRCodeReaderView ()<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession * session;
    
    NSTimer * countTime;
}
@property (nonatomic, strong) CAShapeLayer *overlay;
@property (nonatomic, strong) UIImageView *scanImageView;

@end

@implementation QRCodeReaderView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {

        [self instanceDevice];
  }
  
  return self;
}

- (void)instanceDevice
{
    //扫描区域
    UIImage *hbImage=[UIImage imageNamed:@"scanscanBg"];
    UIImageView * scanZomeBack=[[UIImageView alloc] init];
    scanZomeBack.backgroundColor = [UIColor clearColor];
//    scanZomeBack.layer.borderColor = [UIColor whiteColor].CGColor;
//    scanZomeBack.layer.borderWidth = 2.5;
    scanZomeBack.image = hbImage;
    //添加一个背景图片
    CGRect mImagerect = CGRectMake((Screen_Width - hbImage.size.width)/2,(Screen_Height-hbImage.size.width - navHigh)/2 - 45, hbImage.size.width, hbImage.size.width);
//    CGRect mImagerect = CGRectMake(60*widthRate, (DeviceMaxHeight-200*widthRate)/2, 200*widthRate, 200*widthRate);
    
    [scanZomeBack setFrame:mImagerect];
    self.scanImageView = scanZomeBack;
    CGRect scanCrop=[self getScanCrop:mImagerect readerViewBounds:self.bounds];
    NSLog(@"000000---%@",NSStringFromCGRect(self.frame));
    [self addSubview:scanZomeBack];
    NSLog(@"233333---%@",NSStringFromCGRect(scanCrop));
    
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//    output.rectOfInterest = scanCrop;
    
    
    
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    if (input) {
        [session addInput:input];
    }
    if (output) {
        [session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        NSMutableArray *a = [[NSMutableArray alloc] init];
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            [a addObject:AVMetadataObjectTypeQRCode];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
            [a addObject:AVMetadataObjectTypeEAN13Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
            [a addObject:AVMetadataObjectTypeEAN8Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
            [a addObject:AVMetadataObjectTypeCode128Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeDataMatrixCode]) {
            [a addObject:AVMetadataObjectTypeDataMatrixCode];
        }
        output.metadataObjectTypes=a;
    }
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.layer.bounds;
    [self.layer insertSublayer:layer atIndex:0];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureInputPortFormatDescriptionDidChangeNotification
                                                      object:nil
                                                       queue:[NSOperationQueue currentQueue]
                                                  usingBlock: ^(NSNotification *_Nonnull note) {
                                                      output.rectOfInterest = [layer metadataOutputRectOfInterestForRect:mImagerect];
                                                  }];
    
    [self setOverlayPickerView:self];
    
    //开始捕获
    [session startRunning];
    
}

-(void)loopDrawLine
{
    _is_AnmotionFinished = NO;
//    CGRect rect = CGRectMake(60*widthRate, (DeviceMaxHeight-200*widthRate)/2, 200*widthRate, 2);
    CGFloat wid = CGRectGetMinX(self.scanImageView.frame);
    CGFloat heih = CGRectGetMinY(self.scanImageView.frame);
    CGFloat scanImageWith = CGRectGetWidth(self.scanImageView.frame);
    CGFloat scanImageHeith = CGRectGetHeight(self.scanImageView.frame);
    
    CGRect rect = CGRectMake(wid, heih, scanImageWith, 2);
    if (_readLineView) {
        _readLineView.alpha = 1;
        _readLineView.frame = rect;
    }
    else{
        _readLineView = [[UIImageView alloc] initWithFrame:rect];
        [_readLineView setImage:[UIImage imageNamed:@"scanLine"]];
        [self addSubview:_readLineView];
    }
    
    [UIView animateWithDuration:1.5 animations:^{
        //修改fream的代码写在这里
        _readLineView.frame =CGRectMake(wid, (heih+scanImageHeith), scanImageWith, 2);
    } completion:^(BOOL finished) {
        if (!_is_Anmotion) {
            [self loopDrawLine];
        }
        _is_AnmotionFinished = YES;
    }];
}

- (void)setOverlayPickerView:(QRCodeReaderView *)reader
{
    
    CGFloat wid = CGRectGetMinX(self.scanImageView.frame);
    CGFloat heih = CGRectGetMinY(self.scanImageView.frame);
    CGFloat scanImageHeight = CGRectGetHeight(self.scanImageView.frame);
    
    //最上部view
    CGFloat alpha = 1;
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, heih)];
    upView.alpha = alpha;
//    upView.backgroundColor = [self colorFromHexRGB:contentTitleColorStr];
    upView.backgroundColor = kColorWithRGB(23, 23, 24);
    [reader addSubview:upView];
    
    //左侧的view
    UIView * cLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, heih, wid, scanImageHeight)];
    cLeftView.alpha = alpha;
//    cLeftView.backgroundColor = [self colorFromHexRGB:contentTitleColorStr];
    cLeftView.backgroundColor = kColorWithRGB(23, 23, 24);
    [reader addSubview:cLeftView];
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(Screen_Width-wid, heih, wid, scanImageHeight)];
    rightView.alpha = alpha;
//    rightView.backgroundColor = [self colorFromHexRGB:contentTitleColorStr];
    rightView.backgroundColor = kColorWithRGB(23, 23, 24);
    [reader addSubview:rightView];
    
    //底部view
    UIView * downView = [[UIView alloc] initWithFrame:CGRectMake(0, heih+scanImageHeight, Screen_Width, Screen_Height - heih-scanImageHeight)];
    downView.alpha = alpha;
//    downView.backgroundColor = [self colorFromHexRGB:contentTitleColorStr];
    downView.backgroundColor = kColorWithRGB(23, 23, 24);
    [reader addSubview:downView];
    
    //用于说明的label
    UILabel * labIntroudction= [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame=CGRectMake(10, 30, Screen_Width - 20, 50);
    labIntroudction.numberOfLines = 0;
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将条形码或二维码放入框内，即可自动扫描";
    [downView addSubview:labIntroudction];
    
    //开关灯button
//    UIButton * turnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    turnBtn.backgroundColor = [UIColor clearColor];
//    [turnBtn setBackgroundImage:[UIImage imageNamed:@"lightSelect"] forState:UIControlStateNormal];
//    [turnBtn setBackgroundImage:[UIImage imageNamed:@"lightNormal"] forState:UIControlStateSelected];
//    turnBtn.frame=CGRectMake((DeviceMaxWidth-50*widthRate)/2, (CGRectGetHeight(downView.frame)-50*widthRate)/2, 50*widthRate, 50*widthRate);
//    [turnBtn addTarget:self action:@selector(turnBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [downView addSubview:turnBtn];
    
}

- (void)turnBtnEvent:(UIButton *)button_
{
    button_.selected = !button_.selected;
    if (button_.selected) {
        [self turnTorchOn:YES];
    }
    else{
        [self turnTorchOn:NO];
    }
    
}

- (void)turnTorchOn:(bool)on
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}

-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    NSLog(@"111----%@",NSStringFromCGRect(rect));
    NSLog(@"222----%@",NSStringFromCGRect(readerViewBounds));
    
//    CGFloat x,y,width,height;
//    
//    x = (CGRectGetHeight(readerViewBounds)-CGRectGetHeight(rect))/2/CGRectGetHeight(readerViewBounds);
//    y = (CGRectGetWidth(readerViewBounds)-CGRectGetWidth(rect))/2/CGRectGetWidth(readerViewBounds);
//    width = CGRectGetHeight(rect)/CGRectGetHeight(readerViewBounds);
//    height = CGRectGetWidth(rect)/CGRectGetWidth(readerViewBounds);
//
//    return CGRectMake(x, y, width, height);
    
    CGFloat x,y,width,height;
    x = rect.origin.y / readerViewBounds.size.height;
    y = 1 - (rect.origin.x + rect.size.width) / readerViewBounds.size.width;
    width = (rect.origin.y + rect.size.height) / readerViewBounds.size.height;
    height = 1 - rect.origin.x / readerViewBounds.size.width;
    
    CGRect fr = CGRectMake(x, y, width, height);
    NSLog(@"333----%@",NSStringFromCGRect(fr));
    
    return CGRectMake(x, y, width, height);

}

- (void)start
{
    [session startRunning];
}

- (void)stop
{
    [session stopRunning];
}

#pragma mark - 扫描结果
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects && metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //输出扫描字符串
        if (_delegate && [_delegate respondsToSelector:@selector(readerScanResult:)]) {
            [_delegate readerScanResult:metadataObject.stringValue];
        }
    }
}

#pragma mark - 颜色
//获取颜色
- (UIColor *)colorFromHexRGB:(NSString *)inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}


@end
