//
//  CXIDGFJListCell.m
//  InjoyIDG
//
//  Created by ^ on 2018/5/9.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXIDGFJListCell.h"
#import "Masonry.h"
#import "CXInternalBulletinDetailViewController.h"
#import "CXInternalBulletinListViewController.h"
#import "AFNetworking.h"
#import "HttpTool.h"
#import "PlayerManager.h"
#import "CXButtonDownload.h"

@interface CXIDGFJListCell()<PlayingDelegate>
@property(nonatomic, strong)NSString *filepath;
@property(nonatomic, assign)bool dataCompleted;
@property(nonatomic, assign)bool audioIsPlaying;
@property(nonatomic, strong)CXButtonDownload *btn;
@end
@implementation CXIDGFJListCell{
    NSString *tempFilePath;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setUpUI];
    }
    return self;
}
-(void)setUpUI{
    self.imgCon = [[UIImageView alloc]initWithImage:Image(@"pdf.png")];
    [self.contentView addSubview:self.imgCon];
    
    self.firstLabel = [[UILabel alloc] init];
    self.firstLabel.font = KCXCellOneTitleFontSize;
    self.firstLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.firstLabel];
    
    self.secondLabel = [[UILabel alloc] init];
    self.secondLabel.font = KCXCellOneTimeFontSize;
    self.secondLabel.textColor = [UIColor lightGrayColor];
    [self.secondLabel setTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.secondLabel];
    
    self.btn = [CXButtonDownload buttonWithType:UIButtonTypeCustom];
    [self.btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.btn.backgroundColor = kColorWithRGB(237, 237, 237);
    self.btn.layer.cornerRadius = 6.f;
    self.btn.layer.masksToBounds = YES;
    [self.contentView addSubview:self.btn];
    
    
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.2];
    [self.contentView addSubview:self.lineLabel];
    
    [self.imgCon mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.top.mas_equalTo(self.mas_top).offset(15);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
        make.width.mas_equalTo(50);
    }];
    [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgCon.mas_right).offset(5);
        make.top.equalTo(self.mas_top).offset(10);
        make.height.mas_offset(30);
        make.right.mas_equalTo(self.mas_right).offset(-85);
       // make.width.mas_equalTo(Screen_Width-85);
    }];
    [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgCon.mas_right).offset(5);
        make.top.equalTo(self.firstLabel.mas_bottom);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.width.mas_equalTo(150);
    }];

    [self.btn mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(self.mas_right).offset(-5);
        make.top.mas_equalTo(self.mas_top).offset(20);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-20);
        make.width.mas_equalTo(60);
    }];
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-0.4);
        make.height.mas_equalTo(0.4);
        make.width.mas_equalTo(Screen_Width);
    }];
    [self layoutIfNeeded];
    
}

#pragma mark - delegate
-(bool)isFileEXist{
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [docDir stringByAppendingPathComponent:FJPath];
    bool isDir = NO;
    if(![fileManager fileExistsAtPath:filePath isDirectory:&isDir]){
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
        if(!isDir){
            [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        }else{
            NSString *fileName = [NSString stringWithFormat:@"%@.%@",self.model.boxId,self.model.fileType];
            tempFilePath = [filePath stringByAppendingPathComponent:fileName];
            if([fileManager fileExistsAtPath:tempFilePath]){
                self.filepath = tempFilePath;
                return YES;
            }
        }
    }
    return NO;
}
-(void)H5Cclick{
    CXInternalBulletinDetailViewController *vc = [[CXInternalBulletinDetailViewController alloc]initWithEid:self.model.boxId.integerValue type:isFJListH5 andTitle:self.model.attaName];
    [self.vc.navigationController pushViewController:vc animated:YES];
    
}
-(void)downLoadClick{
  //  NSData * nameData = [self.model.attaName dataUsingEncoding:NSUTF8StringEncoding];
    if(!self.hasRightDownload){
        CXAlert(@"您没有下载权限！");
        return;
    }
    [self.btn setTitle:@"下载中" forState:UIControlStateNormal];
    self.btn.userInteractionEnabled = NO;
    NSString *fileName = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self.model.attaName, NULL, NULL, kCFStringEncodingUTF8));
    NSString *url = [NSString stringWithFormat:@"%@project/detail/annex/download.htm",urlPrefix];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:fileName forKey:@"fileName"];
    [params setValue:self.model.boxId forKey:@"boxId"];
    [params setValue:VAL_token forKey:@"token"];
    [params setValue:[NSString stringWithFormat:@"%zd",self.projId] forKey:@"projId"];
        
    NSProgress *progress = nil;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    NSMutableURLRequest *request= [manager.requestSerializer requestWithMethod:@"GET" URLString:url parameters:params error:nil];
    NSLog(@"request is%@",request);
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://125.35.14.214:8081/idg-api/project/detail/annex/download.htm?token=OGJhMDcxNjNlYzgyNGIwOGIzNDAxYTRiNDc3OWE2YWQ=&fileName=1111.xls&boxId=47277&projId=16322"]];
    NSURLSessionDownloadTask *dataTask = [manager downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
        NSLog(@"response is %@",[resp allHeaderFields]);
        return [NSURL fileURLWithPath:tempFilePath];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if(!error){
            self.dataCompleted = YES;
        }else{
            [self deleteFileWithPath:tempFilePath];
            CXAlert(KNetworkFailRemind);
            NSLog(@"文件下载失败！error:%@", error);
        }
        NSLog(@"File downloaded to: %@ %@", filePath, error);
    }];
    [progress addObserver:self forKeyPath:@"completedUnitCount" options:NSKeyValueObservingOptionNew context:NULL];//fractionCompleted
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [dataTask resume];
    });
    
}
-(void)deleteFileWithPath:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:filePath]){
        return;
    }else{
//        bool isDir = NO;
//        [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
//        if(!isDir){
        NSError *err;
        [fileManager removeItemAtPath:filePath error:&err];
        if(err){
            CXAlert(@"文下载完成文件清理失败！");
        }
//        }
    }
}
-(void)audioPlay{
    self.audioIsPlaying = !self.audioIsPlaying;
    PlayerManager *playManager = [PlayerManager sharedManager];
    if(!self.audioIsPlaying){
        [playManager playAudioWithFileName:self.filepath delegate:self];
    }else{
        [self playingStoped];
    }
}
-(void)playingStoped{
    PlayerManager *playManager = [PlayerManager sharedManager];
    [playManager stopPlaying];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"completedUnitCount"] && [object isKindOfClass:[NSProgress class]]) {
        NSProgress *progress = (NSProgress *)object;
        NSLog(@"progress is%f %@ %@",progress.fractionCompleted, progress.localizedDescription, progress.localizedAdditionalDescription);
        if(progress.completedUnitCount == progress.totalUnitCount){
           // self.dataCompleted = YES;
        }else{
            if(progress.totalUnitCount>0){
                self.btn.progress = progress.completedUnitCount*1.0/progress.totalUnitCount;
                 [self.btn progressOnButton];
            }
        }
        NSLog(@"Progress is %lld all is %lld",progress.completedUnitCount,progress.totalUnitCount);
    
    }
}
-(void)setModel:(CXIDGDJListModel *)model{
     _model = model;
    UIImage *image = nil;
    [self.btn removeTarget:self action:@selector(H5Cclick) forControlEvents:UIControlEventTouchUpInside];
    [self.btn removeTarget:self action:@selector(downLoadClick) forControlEvents:UIControlEventTouchUpInside];
    if([[model.fileType lowercaseString] isEqualToString:@"mp3"]){
        image = Image(@"mp3");
    }else if ([[model.fileType lowercaseString] isEqualToString:@"xlsx"]||[[model.fileType lowercaseString] isEqualToString:@"xls"]){
        image = Image(@"excel");
    }else if ([[model.fileType lowercaseString] isEqualToString:@"pptx"]||[[model.fileType lowercaseString] isEqualToString:@"ppt"]){
        image = Image(@"ppt");
    }else if ([[model.fileType lowercaseString] isEqualToString:@"csv"]){
        image = Image(@"csv");
    }else if ([[model.fileType lowercaseString] isEqualToString:@"doc"]||[[model.fileType lowercaseString] isEqualToString:@"docx"]){
        image = Image(@"word");
    }else if ([[model.fileType lowercaseString] isEqualToString:@"rtf"]){
        image = Image(@"rtf");
    }else if ([[[model.fileType lowercaseString] lowercaseString] isEqualToString:@"pdf"]){
        image = Image(@"pdf");
    }else if([[model.fileType lowercaseString] isEqualToString:@"rar"]||[[model.fileType lowercaseString] isEqualToString:@"zip"]){
        image = Image(@"yasuo");
    }else{
        image = Image(@"unknown");
    }
    self.imgCon.image = image;
    bool isExist =  [self isFileEXist];
    if(!isExist){
        [self.btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.btn.userInteractionEnabled = YES;
        if([[model.fileType lowercaseString] isEqualToString:@"pdf"]){
            [self.btn setTitle:@"查看" forState:UIControlStateNormal];
            [self.btn addTarget:self action:@selector(H5Cclick) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [self.btn setTitle:@"下载" forState:UIControlStateNormal];
            [self.btn addTarget:self action:@selector(downLoadClick) forControlEvents:UIControlEventTouchUpInside];
        }
    }else{
        if([[model.fileType lowercaseString] isEqualToString:@"mp3"]){
            [self.btn setImage:Image(@"OldAnnex_voice") forState:UIControlStateNormal];
            [self.btn setTitle:@"" forState:UIControlStateNormal];
            [self.btn addTarget:self action:@selector(audioPlay) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [self.btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.btn setTitle:@"已下载" forState:UIControlStateNormal];
            self.btn.userInteractionEnabled = NO;
        }
    }
  
}

-(void)setDataCompleted:(bool)dataCompleted{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.btn setTitle:@"已下载" forState:UIControlStateNormal];
        self.btn.userInteractionEnabled = NO;
        if([self.model.fileType isEqualToString:@"mp3"]){
            [self.btn setImage:Image(@"OldAnnex_voice") forState:UIControlStateNormal];
            [self.btn setTitle:@"" forState:UIControlStateNormal];
        }
    });
    self.filepath = tempFilePath;
    _dataCompleted = YES;
}
@end
