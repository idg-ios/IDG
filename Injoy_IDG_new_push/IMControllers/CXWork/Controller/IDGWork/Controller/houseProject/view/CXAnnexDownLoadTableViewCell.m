//
//  CXAnnexDownLoadTableViewCell.m
//  InjoyIDG
//
//  Created by ^ on 2018/5/29.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXAnnexDownLoadTableViewCell.h"
#import "CXIDGDJListModel.h"
#import "CXAnnexDownloadModel.h"
#import "CXAnnexFileModel.h"
#import "AFNetworking.h"
#import "PlayerManager.h"


#define uinitpx (Screen_Width/375.0)
#define margin (15*uinitpx)
@interface CXAnnexDownLoadTableViewCell()
@property (nonatomic, copy) NSString *fileType;
@property (nonatomic, strong) UIImageView *downLoadImageView;
@property (nonatomic, strong) UIButton *downloadButton;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, assign)bool audioIsPlaying;
@property (nonatomic, copy) NSString *audioPath;
@end
@implementation CXAnnexDownLoadTableViewCell

#define kCellHeigt (80 * uinitpx)

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setUpUI];
        
    }
    return self;
}
- (void)layoutSubviews{
    if(_downLoadImageView.userInteractionEnabled == NO){
        _downLoadImageView.hidden = YES;
    }
    self.imageView.frame = CGRectMake(margin, (kCellHeigt - 48*uinitpx)/ 2.0f, 48*uinitpx, 48*uinitpx);
    _downLoadImageView.frame = CGRectMake(Screen_Width - 18*(kCellHeigt - 27*uinitpx - 28*uinitpx)/17.0 - margin, (kCellHeigt - (kCellHeigt - 27*uinitpx - 28*uinitpx))/ 2.0f, 18*(kCellHeigt - 27*uinitpx - 28*uinitpx)/17.0, (kCellHeigt - 27*uinitpx - 28*uinitpx));
    _downLoadImageView.contentMode = UIViewContentModeScaleAspectFill;
  //  self.downloadButton.frame = CGRectMake(Screen_Width - 36*uinitpx, (kCellHeigt - 40*uinitpx)/ 2.0f, 18*uinitpx, 17*uinitpx);
    self.textLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 12*uinitpx, CGRectGetMinY(self.imageView.frame), CGRectGetMinX(_downLoadImageView.frame) - CGRectGetMaxX(self.imageView.frame) - 2*12*uinitpx, 25*uinitpx);
    self.detailTextLabel.frame = CGRectMake(CGRectGetMinX(self.textLabel.frame), CGRectGetMaxY(self.textLabel.frame), CGRectGetWidth(self.textLabel.frame), 20*uinitpx);
    self.line.frame = CGRectMake(CGRectGetMinX(self.textLabel.frame), kCellHeigt -1, Screen_Width - CGRectGetWidth(self.imageView.frame) - margin - 12*uinitpx, 1.0f);
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_downloadButton.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(6.f, 6.f)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
//    maskLayer.frame = _downloadButton.bounds;
//    maskLayer.path = maskPath.CGPath;
//    _downloadButton.layer.mask = maskLayer;

}

- (void)setUpUI{
    _downLoadImageView = [[UIImageView alloc]init];
    _downLoadImageView.image = Image(@"icon_download");
    _line = [[UIView alloc]init];
    _line.backgroundColor = kColorWithRGB(245, 246, 248);
    [self.contentView addSubview:_line];
    _downLoadImageView.userInteractionEnabled = YES;
    [_downLoadImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(downloadTap)]];
    [self.contentView addSubview:_downLoadImageView];
    
//    _downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _downloadButton.backgroundColor = kColorWithRGB(174,17,41);
//    [_downloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_downloadButton addTarget:self action:@selector(downloadTap) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:_downloadButton];

}
#pragma mark -- 下载
- (void)downloadTap{
    if(!self.hasRightDownload){
        CXAlert(@"您没有下载权限");
        return;
    }
    _downLoadImageView.userInteractionEnabled = NO;//下载过程中关闭交互,防止多次重复下载
    
    CXAnnexDownloadModel *downloadModel = [[CXAnnexDownloadModel alloc]init];
    if([_model isKindOfClass:[CXIDGDJListModel class]]){
        CXIDGDJListModel *cellModel = _model;
        downloadModel.fileName = [NSString stringWithFormat:@"%@.%@",cellModel.boxId,cellModel.fileType];
        
        NSString *fileName = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)cellModel.attaName, NULL, NULL, kCFStringEncodingUTF8));
        NSString *url = [NSString stringWithFormat:@"%@project/detail/annex/download.json",urlPrefix];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:fileName forKey:@"fileName"];
        [params setValue:cellModel.boxId forKey:@"boxId"];
        [params setValue:VAL_token forKey:@"token"];
        [params setValue:[NSString stringWithFormat:@"%zd",self.projId] forKey:@"projId"];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
        NSMutableURLRequest *request= [manager.requestSerializer requestWithMethod:@"GET" URLString:url parameters:params error:nil];
        
        downloadModel.requestURL = request;
        downloadModel.resourceURLString = cellModel.boxId;
    }else if ([_model isKindOfClass:[CXAnnexFileModel class]]){
        CXAnnexFileModel *cellModel = _model;
        downloadModel.fileName = [NSString stringWithFormat:@"%@.%@" , cellModel.id, cellModel.type];
        NSString *fileName = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)cellModel.fileName, NULL, NULL, kCFStringEncodingUTF8));
        NSString *url = [NSString stringWithFormat:@"%@cost/detail/annex/download.json",urlPrefix];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:fileName forKey:@"fileName"];
        [params setValue:cellModel.id forKey:@"eid"];
        [params setValue:VAL_token forKey:@"token"];
        [params setValue:cellModel.type forKey:@"type"];
        [params setValue:cellModel.fileUrl forKey:@"fileUrl"];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
        NSMutableURLRequest *request= [manager.requestSerializer requestWithMethod:@"GET" URLString:url parameters:params error:nil];
        
        downloadModel.requestURL = request;
        downloadModel.resourceURLString = cellModel.id;
        NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"costOf%@", VAL_USERID]];
        BOOL isDir;
        NSFileManager *filemaneger = [NSFileManager defaultManager];
        if([filemaneger fileExistsAtPath:filePath isDirectory:&isDir]){
            if(!isDir){
                [filemaneger createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
        }else{
            [filemaneger createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        downloadModel.filePath = filePath;
    }
    
    [CXAnnexDownLoadManager sharedManager].delegate = self.vc;
    [[CXAnnexDownLoadManager sharedManager]addDownLoadTask:downloadModel];
}
-(void)audioPlay{
    self.audioIsPlaying = !self.audioIsPlaying;
    PlayerManager *playManager = [PlayerManager sharedManager];
    if(!self.audioIsPlaying){
        [playManager playAudioWithFileName:self.audioPath delegate:self];
    }else{
        [self playingStoped];
    }
}
-(void)playingStoped{
    PlayerManager *playManager = [PlayerManager sharedManager];
    [playManager stopPlaying];
}
- (void)setModel:(id)model{
    _model = model;
    self.downloadButton.hidden = NO;
    if([model isKindOfClass:[CXIDGDJListModel class]]){
        
        CXIDGDJListModel *dataModel = (CXIDGDJListModel *)model;
        self.textLabel.text = dataModel.attaName?:@"";
        self.textLabel.font = [UIFont systemFontOfSize:18.f];
        self.detailTextLabel.text = dataModel.uploadTime?:@"";
        self.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
        self.detailTextLabel.textColor = kColorWithRGB(132,142,153);
        [self.downloadButton setTitle:@"下载" forState:UIControlStateNormal];
        
        self.fileType = [dataModel.fileType lowercaseString];
    }else if ([model isKindOfClass:[CXAnnexFileModel class]]){
        CXAnnexFileModel *dataModel = (CXAnnexFileModel *)model;
        self.textLabel.text = dataModel.fileName?:@"";
        self.textLabel.font = [UIFont systemFontOfSize:18.f];
        [self.downloadButton setTitle:@"下载" forState:UIControlStateNormal];
        
        self.fileType = [dataModel.type lowercaseString];
    }
    if([self.fileType isEqualToString:@"ppt"] || [self.fileType isEqualToString:@"pptx"]){
        self.imageView.image = Image(@"pic_ppt");
    }else if ([self.fileType isEqualToString:@"pdf"]){
//        [self.downloadButton setTitle:@"查看" forState:UIControlStateNormal];
//        self.downloadButton.userInteractionEnabled = NO;
//        [self.downloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.downLoadImageView.hidden = YES;
        self.imageView.image = Image(@"pic_pdf");
        
    }else if ([self.fileType isEqualToString:@"doc"] || [self.fileType isEqualToString:@"docx"]){
        self.imageView.image = Image(@"pic_word");
    }else if ([self.fileType isEqualToString:@"xls"] || [self.fileType isEqualToString:@"xlsx"]){
        self.imageView.image = Image(@"pic_xls");
    }else if([self.fileType isEqualToString:@"mp3"]){
        self.imageView.image = Image(@"mp3");
    }else if ([self.fileType isEqualToString:@"csv"]){
        self.imageView.image = Image(@"csv");
    }else if ([self.fileType isEqualToString:@"rtf"]){
        self.imageView.image = Image(@"rtf");
    }else if ([self.fileType isEqualToString:@"msg"]){
        self.imageView.image = Image(@"pic_yj");
    }else if([self.fileType isEqualToString:@"rar"]||[self.fileType isEqualToString:@"zip"]){
        self.imageView.image = Image(@"yasuo");
    }else if([self.fileType isEqualToString:@"jpg"] || [self.fileType isEqualToString:@"jpeg"] || [self.fileType isEqualToString:@"png"] || [self.fileType isEqualToString:@"psd"]){
        self.imageView.image = Image(@"images");
        
    } else{
        self.imageView.image = Image(@"unknown");
    }
}
- (NSString *)getAudioFilePath:(id)model{
    if([model isKindOfClass:[CXIDGDJListModel class]]){
        CXIDGDJListModel *dataModel = (CXIDGDJListModel *)model;
        NSString *fileName = [NSString stringWithFormat:@"%@.%@",dataModel.boxId,dataModel.fileType];
        return [[CXAnnexDownLoadManager sharedManager]filePathOfDownloded:fileName];
    }else if ([model isKindOfClass:[CXAnnexFileModel class]]){
          CXAnnexFileModel *dataModel = (CXAnnexFileModel *)model;
        NSString *fileName = [NSString stringWithFormat:@"%@.%@",dataModel.id,dataModel.type];
        NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"costOf%@", VAL_USERID]];
        return [[CXAnnexDownLoadManager sharedManager]filePathOfDownloded:filePath andName:fileName];
    }else{
        return nil;
    }
}
- (void)setStatus:(downloadStatus)status{
    if([self.fileType isEqualToString:@"pdf"]){
        return;
    }
    switch (status) {
        case downloadSucess:{
//            [self.downloadButton setTitle:@"查看" forState:UIControlStateNormal];
//            [self.downloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            self.downloadButton.userInteractionEnabled = NO;
            self.downLoadImageView.hidden = YES;
            if([self.fileType isEqualToString:@"mp3"]){
                self.audioPath = [self getAudioFilePath:self.model];
                [self.downloadButton setImage:Image(@"OldAnnex_voice") forState:UIControlStateNormal];
                [self.downloadButton setTitle:@"" forState:UIControlStateNormal];
                [self.downloadButton addTarget:self action:@selector(audioPlay) forControlEvents:UIControlEventTouchUpInside];
            }
        }
            break;
        case start:
        case downloading:{
//            [self.downloadButton setTitle:@"下载中" forState:UIControlStateNormal];
//            [self.downloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            self.downloadButton.userInteractionEnabled = NO;
            self.downLoadImageView.userInteractionEnabled = NO;
        }
            break;
        case hasDownload:
        {
//            self.downLoadImageView.image = nil;
//             self.downLoadImageView.userInteractionEnabled = NO;
//            [self.downloadButton setTitle:@"查看" forState:UIControlStateNormal];
//            [self.downloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            self.downloadButton.userInteractionEnabled = NO;
            self.downLoadImageView.hidden = YES;
            if([self.fileType isEqualToString:@"mp3"]){
                self.audioPath = [self getAudioFilePath:self.model];
                [self.downloadButton setImage:Image(@"OldAnnex_voice") forState:UIControlStateNormal];
                [self.downloadButton setTitle:@"" forState:UIControlStateNormal];
                [self.downloadButton addTarget:self action:@selector(audioPlay) forControlEvents:UIControlEventTouchUpInside];
            }
            
        }
            break;
        case downloadFaild:{
//            self.imageView.image = Image(@"downLoad");
//            self.downLoadImageView.userInteractionEnabled = YES;
//            [self.downloadButton setTitle:@"下载" forState:UIControlStateNormal];
//            [self.downloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            self.downloadButton.userInteractionEnabled = YES;
            self.downLoadImageView.hidden = NO;
            CXAlert(@"一个文件下载失败");
        }
            break;
        case waiting:{
//            [self.downloadButton setTitle:@"等待中" forState:UIControlStateNormal];
//            [self.downloadButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//            self.downloadButton.userInteractionEnabled = NO;
            self.downLoadImageView.hidden = NO;
            self.downLoadImageView.userInteractionEnabled = NO;
        }
            break;
        case notFound:{
//            [self.downloadButton setTitle:@"下载" forState:UIControlStateNormal];
//            [self.downloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            self.downloadButton.userInteractionEnabled = YES;
            self.downLoadImageView.hidden = NO;
            self.imageView.userInteractionEnabled = YES;
        }
        default:
            break;
    }
    _status = status;
}
#pragma mark --低版本cell分割线
- (void)drawRect:(CGRect)rect {
    if([UIDevice currentDevice].systemVersion.doubleValue  < 10){
        
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor); CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));
    CGContextSetStrokeColorWithColor(context, [UIColor yy_colorWithHexString:@"e2e2e2"].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, rect.size.height, rect.size.width - 10, 1));
    }
}
@end
