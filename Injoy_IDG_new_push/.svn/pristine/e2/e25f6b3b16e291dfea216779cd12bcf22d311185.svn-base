//
//  CXOLDERPAnnexView.m
//  InjoyYJ1
//
//  Created by wtz on 2017/8/22.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXOLDERPAnnexView.h"
#import "SDDockImageModel.h"
#import "SDRecordViewController.h"
#import "SDUploadFileModel.h"
#import "SDDetailInfoViewController.h"
#import "PlayerManager.h"
#import "CXAnnexViewController.h"

#define kAudioNetWorkPath [NSString stringWithFormat:@"%@/Documents/NetWorkAudio", NSHomeDirectory()]

@interface CXOLDERPAnnexView()<setUpVideo, SDShowPicControllerDegate, PlayingDelegate>

/** 所有的按钮 */
@property(nonatomic, strong) NSMutableArray *btnArray;
/// 相册图片数组
@property(nonatomic, strong) NSMutableArray *albumImageArray;
/// 已选中的照片对象
@property(nonatomic, strong) NSMutableArray *selectedAssetArray;
/// 相机照片
//@property (nonatomic, strong) NSMutableArray* caramaImageArray;
/// 录音声音model数组
@property(nonatomic, strong) NSMutableArray *selectVoiceArr;
/// 声音字典
@property(nonatomic, strong) NSMutableDictionary *voiceDict;
/// 安卓附件数组
@property (nonatomic, strong) NSMutableArray *annexFileArr;

@property(nonatomic, strong) NSMutableArray *assets;
@property(nonatomic, strong) NSMutableArray *groups;
@property(nonatomic, strong) ALAssetsLibrary *assetsLibrary;

//录音功能
@property(nonatomic, strong) SDRecordViewController *recordVc;
@property(nonatomic, strong) NSMutableDictionary *detailVoiceDict;
/*录音按钮，实现暂停播放的功能**/
@property(nonatomic, assign) BOOL isPlaySound;

@property(nonatomic) CGFloat viewWidth;

@property (nonatomic) BOOL isOnlyPicture;

@end

@implementation CXOLDERPAnnexView

- (id)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self creatViews];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame AndViewWidth:(CGFloat)viewWidth {
    if ([super initWithFrame:frame]) {
        
        self.viewWidth = viewWidth;
        [self creatViews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame AndViewWidth:(CGFloat)viewWidth AndIsOnlyPicture:(BOOL)isOnlyPicture
{
    if ([super initWithFrame:frame]) {
        self.isOnlyPicture = isOnlyPicture;
        self.viewWidth = viewWidth;
        [self creatViews];
    }
    return self;
}

#pragma mark -- 清空所有附件的数据

- (void)cleanData {
    [_AllAnnexDataArray removeAllObjects];
    [_albumImageArray removeAllObjects];
    [_selectedAssetArray removeAllObjects];
    [_selectVoiceArr removeAllObjects];
    [_voiceDict removeAllObjects];
    self.voiceDict = nil;
    _detailVoiceDict = nil;
    
    NSArray *imageNameArr = @[@"annex_carame_n.png", @"OldAnnex_image.png", @"OldAnnex_voice.png", @"OldAnnex_file.png"];
    for (NSInteger i = 0; i < self.btnArray.count; i++) {
        UIButton *button = self.btnArray[i];
        [button setImage:[UIImage imageNamed:imageNameArr[i]] forState:UIControlStateNormal];
    }
    
}

#pragma mark - get*set

- (NSMutableArray *)AllAnnexDataArray {
    if (nil == _AllAnnexDataArray) {
        _AllAnnexDataArray = [[NSMutableArray alloc] init];
    }
    return _AllAnnexDataArray;
}

- (NSMutableArray *)albumImageArray {
    if (nil == _albumImageArray) {
        _albumImageArray = [[NSMutableArray alloc] init];
    }
    return _albumImageArray;
}

- (NSMutableArray *)selectedAssetArray {
    if (nil == _selectedAssetArray) {
        _selectedAssetArray = [[NSMutableArray alloc] init];
    }
    return _selectedAssetArray;
}

- (NSMutableArray *)selectVoiceArr {
    if (nil == _selectVoiceArr) {
        _selectVoiceArr = [[NSMutableArray alloc] init];
    }
    return _selectVoiceArr;
}

- (NSMutableDictionary *)voiceDict {
    if (nil == _voiceDict) {
        _voiceDict = [[NSMutableDictionary alloc] init];
    }
    return _voiceDict;
}

- (NSMutableArray*)annexFileArr
{
    if (nil == _annexFileArr) {
        _annexFileArr = [[NSMutableArray alloc] init];
    }
    return _annexFileArr;
}

- (NSMutableArray *)btnArray {
    if (nil == _btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

- (NSMutableDictionary *)annexDataDict {
    if (nil == _annexDataDict) {
        _annexDataDict = [NSMutableDictionary dictionary];
    }
    return _annexDataDict;
}

#pragma mark - UI

- (void)creatViews {
    //按钮
    NSArray *imageNameArr = @[@"annex_carame_n.png", @"OldAnnex_image.png", @"OldAnnex_voice.png", @"OldAnnex_file.png"];
    
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (self.viewWidth && self.viewWidth > 0) {
            [btn setFrame:CGRectMake(((i + 1) * (self.viewWidth - 30 * 4) / 5 + i * 30), (kLineHeight - 30) / 2.0, 30, 30)];
        } else {
            [btn setFrame:CGRectMake(40 * i, (kLineHeight - 30) / 2.0, 30, 30)];
        }
        [btn setImage:[UIImage imageNamed:imageNameArr[i]] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13.f]];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = kColorWithRGB(103, 103, 103);
        btn.layer.cornerRadius = 15;
        btn.layer.masksToBounds = YES;
        [btn setTag:i + 10];
        if(self.isOnlyPicture){
            if(i==0 || i==1){
                [self addSubview:btn];
                [self.btnArray addObject:btn];
            }
        }else{
            [self addSubview:btn];
            [self.btnArray addObject:btn];
        }
    }
}

// (新建时选择好附件重新点击附件时赋值)
- (void)putImageVoiceData {
    self.selectedAssetArray = self.annexDataDict[@"ImageAsset"];
    self.selectVoiceArr = self.annexDataDict[@"VoiceArray"];
    
    if (_selectedAssetArray.count) {
        [self.btnArray[1] setImage:[UIImage imageNamed:@"OldAnnex_image_y"] forState:UIControlStateNormal];
    }
    if (_selectVoiceArr.count) {
        [self.btnArray[2] setImage:[UIImage imageNamed:@"OldAnnex_voice_y"] forState:UIControlStateNormal];
    }
}

// (详情时必须传进来)
- (void)setAnnexDataArray:(NSMutableArray *)annexDataArray {
    _annexDataArray = annexDataArray;
    _detailVoiceDict = [NSMutableDictionary dictionary];
    
    //清空之前的附件数据
    [self.albumImageArray removeAllObjects];
    self.voiceDict = nil;
    
    for (NSMutableDictionary *dict in _annexDataArray) {
        if ([dict[@"type"] isEqualToString:@"jpg"] || [dict[@"type"] isEqualToString:@"png"]) {
            [self.albumImageArray addObject:dict];
        }
        if ([dict[@"type"] isEqualToString:@"spx"]) {
            [_detailVoiceDict setValue:dict[@"path"] forKey:@"voicePath"];
            [_detailVoiceDict setValue:dict[@"srcName"] forKey:@"srcName"];
            self.voiceDict = _detailVoiceDict;
        }
        if ([[NSString stringWithFormat:@"%@",dict[@"showType"]] isEqualToString:@"1"]) {
            [self.annexFileArr addObject:dict];
        }
    }
    
    if ([self.albumImageArray count]) {
        UIButton *button = self.btnArray[1];
        [self.btnArray[1] setImage:[UIImage imageNamed:@"OldAnnex_image_y"] forState:UIControlStateNormal];
        button.userInteractionEnabled = YES;
        
    } else {
        UIButton *button = self.btnArray[1];
        [self.btnArray[1] setImage:[UIImage imageNamed:@"OldAnnex_image"] forState:UIControlStateNormal];
        button.userInteractionEnabled = NO;
    }
    
    if ([self.voiceDict count]) {
        UIButton *button = self.btnArray[2];
        [self.btnArray[2] setImage:[UIImage imageNamed:@"OldAnnex_voice_y"] forState:UIControlStateNormal];
        button.userInteractionEnabled = YES;
    } else {
        UIButton *button = self.btnArray[2];
        [button setImage:[UIImage imageNamed:@"OldAnnex_voice"] forState:UIControlStateNormal];
        button.userInteractionEnabled = NO;
    }
    
    if ([self.annexFileArr count]) {
        UIButton *button = self.btnArray[3];
        [self.btnArray[3] setImage:[UIImage imageNamed:@"OldAnnex_file_y"] forState:UIControlStateNormal];
        button.userInteractionEnabled = YES;
    } else {
        UIButton *button = self.btnArray[3];
        [self.btnArray[3] setImage:[UIImage imageNamed:@"OldAnnex_file"] forState:UIControlStateNormal];
        button.userInteractionEnabled = NO;
    }
    /** 关闭照相机的点击事件 */
    UIButton *button = self.btnArray[0];
    button.userInteractionEnabled = NO;
}

- (void)setSendDataArray:(NSMutableArray *)sendDataArray {
    _sendDataArray = sendDataArray;
    for (NSMutableDictionary *dict in _sendDataArray) {
        if ([dict[@"type"] isEqualToString:@"jpg"] || [dict[@"type"] isEqualToString:@"png"]) {
            [self.albumImageArray addObject:dict];
        }
        if ([dict[@"type"] isEqualToString:@"spx"]) {
            [_detailVoiceDict setValue:dict[@"path"] forKey:@"voicePath"];
            [_detailVoiceDict setValue:dict[@"srcName"] forKey:@"srcName"];
            self.voiceDict = _detailVoiceDict;
        }
    }
    
    if ([self.albumImageArray count]) {
        [self.btnArray[1] setImage:[UIImage imageNamed:@"OldAnnex_image_y"] forState:UIControlStateNormal];
    } else {
        UIButton *button = self.btnArray[1];
        button.userInteractionEnabled = NO;
    }
    
    if ([self.voiceDict count]) {
        [self.btnArray[2] setImage:[UIImage imageNamed:@"OldAnnex_voice_y"] forState:UIControlStateNormal];
    } else {
        UIButton *button = self.btnArray[2];
        button.userInteractionEnabled = NO;
    }
}

- (void)btnClick:(UIButton *)button {
    if (button.tag == 10) {
        /** 相机点击 */
        if (!_isDetail) {
            [self takePhoto];
        }
    } else if (button.tag == 11) {
        /** 图片点击 */
        if (_isDetail && self.albumImageArray.count) {
            // 详情
            SDDetailInfoViewController *detailVC = [[SDDetailInfoViewController alloc] init];
            detailVC.annexArray = self.albumImageArray;
            detailVC.index = 0;
            [self.window.rootViewController presentViewController:detailVC animated:YES completion:nil];
        } else if(!_isDetail){
            [self LocalPhoto];
        }
    } else if (button.tag == 12) {
        /** 录音点击 */
        if (_isDetail) {
            [self voicePlay];
        } else {
            [self.recordVc.view removeFromSuperview];
            self.recordVc.delegate = self;
            [KEY_WINDOW addSubview:self.recordVc.view];
        }
    } else if (button.tag == 13) {
        /** 附件点击 */
        if ([self.annexFileArr count]) {
            //点击附件，显示附件
            UINavigationController *nav = [self getNavigaTionController];
            CXAnnexViewController *annexViewController = [[CXAnnexViewController alloc] init];
            annexViewController.annexDataArray = self.annexFileArr;
            [nav pushViewController:annexViewController animated:YES];
        }
    }
}
#pragma mark -- 获取视图控制器
-(UINavigationController *)getNavigaTionController
{
    for (UIView *view = self.superview; view; view = view.superview) {
        
        if ([view.nextResponder isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)view.nextResponder;
        }
        
    }
    
    return nil;
}

#pragma mark - 按钮的点击事件

// 拍照
- (void)takePhoto {
    //先设定sourceType为相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self.vc presentViewController:picker animated:YES completion:nil];
    } else {
        TTAlertNoTitle(@"模拟机无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
- (void)LocalPhoto {
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 10;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset *) evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset *) evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    
    [self.vc presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - 本地相册选择 ZYQAssetPickerController Delegate

- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    for (NSInteger i = self.AllAnnexDataArray.count - 1; i >= 0; i--) {
        SDUploadFileModel *model = self.AllAnnexDataArray[i];
        if ([model.mimeType isEqualToString:@"image/jpg"]) {
            [self.AllAnnexDataArray removeObjectAtIndex:i];
        }
    }
    // 获取照片、照片实体、照片对象
    NSMutableArray *imageModelAry = [[NSMutableArray alloc] init];
    NSMutableArray *imageArray = [NSMutableArray array];
    
    for (int i = 0; i < assets.count; i++) {
        ALAsset *asset = assets[i];
        UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [imageArray addObject:tempImg];
        
        SDDockImageModel *imageModel = [[SDDockImageModel alloc] init];
        imageModel.imageName = asset.defaultRepresentation.filename;
        imageModel.selectImage = tempImg;
        [imageModelAry addObject:imageModel];
    }
    // 保存相册选中图片图片
    [self.albumImageArray removeAllObjects];
    self.albumImageArray = imageArray;
    //NSLog(@"已选相片数：%lu",(unsigned long)[self.albumImageArray count]);
    
    // 保存相片对象
    [self.selectedAssetArray removeAllObjects];
    [self.selectedAssetArray addObjectsFromArray:assets];
    
    if (self.albumImageArray.count) {
        [self.btnArray[1] setImage:[UIImage imageNamed:@"OldAnnex_image_y"] forState:UIControlStateNormal];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        long fileNameNumber = [str longLongValue];
        
        for (int i = 0; i < _albumImageArray.count; i++) {
            SDUploadFileModel *model = [[SDUploadFileModel alloc] init];
            UIImage *compressedImage = [self compressedImage:_albumImageArray[i]];
            NSData *data = UIImageJPEGRepresentation(compressedImage, kImageCompressRate);
            model.fileData = data;
            fileNameNumber += i;
            NSString *fileName = [NSString stringWithFormat:@"%ld.jpg", fileNameNumber];
            model.fileName = fileName;
            model.mimeType = @"image/jpg";
            [self.AllAnnexDataArray addObject:model];
        }
    }
    [self.annexDataDict setValue:_selectedAssetArray forKey:@"ImageAsset"];
}

/**
 *  处理图片的压缩问题
 */
- (UIImage *)compressedImage:(UIImage *)image {
    const CGFloat scaleSize = kImageCompressRate;
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return compressedImage;
}

#pragma  mark -- 本地相册选择 picker的代理方法 已选的图片

- (NSMutableArray *)assetPickerControllerWithSelectedAssetArray {
    //NSLog(@"相册对象：%@",self.selectedAssetArray);
    //NSLog(@"相册对象数：%lu",(unsigned long)[self.selectedAssetArray count]);
    return self.selectedAssetArray;
}

#pragma mark - 拍照后图片后的回调

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    
    //if ([self.delegate respondsToSelector:@selector(getCameraImage:)]) {
    //    [self.delegate getCameraImage:image];
    //}
    [self.albumImageArray removeAllObjects];
    [self.albumImageArray addObject:image];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self performSelector:@selector(setupGroup) withObject:nil afterDelay:0.5f];
    
    if (self.albumImageArray.count) {
        [self.btnArray[1] setImage:[UIImage imageNamed:@"OldAnnex_image_y"] forState:UIControlStateNormal];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        long fileNameNumber = [str longLongValue];
        
        for (int i = 0; i < _albumImageArray.count; i++) {
            SDUploadFileModel *model = [[SDUploadFileModel alloc] init];
            UIImage *compressedImage = [self compressedImage:_albumImageArray[i]];
            NSData *data = UIImageJPEGRepresentation(compressedImage, kImageCompressRate);
            model.fileData = data;
            fileNameNumber += i;
            NSString *fileName = [NSString stringWithFormat:@"%ld.jpg", fileNameNumber];
            model.fileName = fileName;
            model.mimeType = @"image/jpg";
            [self.AllAnnexDataArray addObject:model];
        }
    }
}

- (void)setupGroup {
    if (!self.assetsLibrary)
        self.assetsLibrary = [self.class defaultAssetsLibrary];
    
    if (!self.groups)
        self.groups = [[NSMutableArray alloc] init];
    else
        [self.groups removeAllObjects];
    
    ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        if (group) {
            if (group.numberOfAssets > 0)
                [self.groups addObject:group];
            [self setupAssets];
        }
    };
    
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        
    };
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
}

- (void)setupAssets {
    if (!self.assets)
        self.assets = [[NSMutableArray alloc] init];
    else
        [self.assets removeAllObjects];
    
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        if (asset) {
            [self.assets addObject:asset];
        } else {
            if (self.selectedAssetArray.count >= 9) {
                TTAlert(@"图片数已经到达9张");
                return;
            }
            // 相册对象回调
            //if ([self.delegate respondsToSelector:@selector(getCameraAlasset:)]) {
            //    [self.delegate getCameraAlasset:[self.assets lastObject]];
            //}
            [self.selectedAssetArray addObject:[self.assets lastObject]];
            if (self.albumImageArray.count) {
                [self.btnArray[1] setImage:[UIImage imageNamed:@"OldAnnex_image_y"] forState:UIControlStateNormal];
            }
        }
    };
    
    ALAssetsGroup *assetsGroup = [self.groups firstObject];
    [assetsGroup enumerateAssetsUsingBlock:resultsBlock];
}

+ (ALAssetsLibrary *)defaultAssetsLibrary {
    // ALAssetsLibrary ALAssetsLibrary类可以实现查看相册列表，增加相册，保存图片到相册等功能
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    // 点击退出相机
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 录音处理

// 录音控制器
- (SDRecordViewController *)recordVc {
    if (!_recordVc) {
        _recordVc = [[SDRecordViewController alloc] init];
    }
    return _recordVc;
}

#pragma mark - SDRecordViewController的代理方法 录音

- (void)setUpVideo:(NSString *)videoPath withduration:(float)duration {
    for (NSInteger i = self.AllAnnexDataArray.count - 1; i >= 0; i--) {
        SDUploadFileModel *model = self.AllAnnexDataArray[i];
        if ([model.mimeType isEqualToString:@"sound/amr"]) {
            [self.AllAnnexDataArray removeObjectAtIndex:i];
        }
    }
    // 保证只有一个录音
    [self.selectVoiceArr removeAllObjects];
    
    if (videoPath.length) {
        NSData *voiceData = [[NSData alloc] initWithContentsOfFile:videoPath];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *soundName = [dateFormatter stringFromDate:[NSDate date]];
        
        //[self.voiceDict setValue:voiceData forKey:@"voicePath"];
        //[self.voiceDict setValue:[NSString stringWithFormat:@"%@.spx", soundName] forKey:@"srcName"];
        
        SDUploadFileModel *model = [[SDUploadFileModel alloc] init];
        model.fileName = [NSString stringWithFormat:@"%@.spx", soundName];
        model.fileData = voiceData;
        model.mimeType = @"sound/amr";
        model.duration = [NSString stringWithFormat:@"%f", duration];
        
        [self.selectVoiceArr addObject:model];
    }
    
    if ([self.selectVoiceArr count]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.btnArray[2] setImage:[UIImage imageNamed:@"OldAnnex_voice_y"] forState:UIControlStateNormal];
        });
        //声音附件
        SDUploadFileModel *model = [self.selectVoiceArr firstObject];
        [self.AllAnnexDataArray addObject:model];
    }
    [self.annexDataDict setValue:_selectVoiceArr forKey:@"VoiceArray"];
}

#pragma mark - 声音播放

- (void)voicePlay {
    if (self.isPlaySound) {
        NSLog(@"点击声音");
        self.isPlaySound = NO;
        NSString *voicePath = [NSString stringWithFormat:@"%@", self.voiceDict[@"voicePath"]];
        NSString *voiceSrcName = self.voiceDict[@"srcName"];
        
        //来自添加界面，直接播放录音
        if (![voicePath hasPrefix:@"http"]) {
            [self playNetWorkAudioByPath:voicePath];
        } else {
            
            //如果本地文件有录音，直接读取
            NSString *directoryVoicePath = [NSString stringWithFormat:@"%@/%@", kAudioNetWorkPath, voiceSrcName];
            if ([[NSFileManager defaultManager] fileExistsAtPath:directoryVoicePath]) {
                [self playNetWorkAudioByPath:directoryVoicePath];
            } else {
                [self downloadNetWorkAudioByPath:voicePath withSrcName:voiceSrcName];
            }
        }
    } else {
        //暂停录音播放
        self.isPlaySound = YES;
        [self playingStoped];
    }
}

// 播放录音文件
- (void)playNetWorkAudioByPath:(NSString *)audioPath {
    PlayerManager *playManager = [PlayerManager sharedManager];
    [playManager playAudioWithFileName:audioPath delegate:self];
}

// 网络下载录音文件
- (void)downloadNetWorkAudioByPath:(NSString *)netWorkPath withSrcName:(NSString *)voiceSrcName {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:netWorkPath]];
    [request setTimeoutInterval:60.f];
    [request addValue:[NSString stringWithFormat:@"%@", VAL_token] forHTTPHeaderField:@"token"];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
                               if (![[NSFileManager defaultManager] fileExistsAtPath:kAudioNetWorkPath]) {
                                   [[NSFileManager defaultManager] createDirectoryAtPath:kAudioNetWorkPath withIntermediateDirectories:YES attributes:nil error:nil];
                               }
                               
                               if (data) {
                                   
                                   NSString *filePath = [NSString stringWithFormat:@"%@/%@", kAudioNetWorkPath, voiceSrcName];
                                   [data writeToFile:filePath atomically:NO];
                                   [self playNetWorkAudioByPath:filePath];
                               }
                           }];
}

//停止播放录音
- (void)playingStoped {
    self.isPlaySound = YES;
    PlayerManager *playManager = [PlayerManager sharedManager];
    [playManager stopPlaying];
}

- (void)dealloc {
    //暂停录音播放
    [self playingStoped];
}

@end
