//
//  CXERPAnnexView.m
//  InjoyERP
//
//  Created by fanzhong on 16/11/16.
//  Copyright © 2016年 slovelys. All rights reserved.
//

const CGFloat CXERPAnnexView_height = kLineHeight;

#import "CXERPAnnexView.h"
#import "SDDockImageModel.h"
#import "SDRecordViewController.h"
#import "SDUploadFileModel.h"
#import "SDDetailInfoViewController.h"
#import "PlayerManager.h"
#import "CXAnnexViewController.h"
#import "UIView+YYAdd.h"
#import "HttpTool.h"
#import "CXEditLabel.h"

#define kAudioNetWorkPath [NSString stringWithFormat:@"%@/Documents/NetWorkAudio", NSHomeDirectory()]

@interface CXERPAnnexView () <setUpVideo, SDShowPicControllerDegate, PlayingDelegate>

/** <#comment#> */
@property (nonatomic, strong) CXEditLabel *titleLabel;

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
@property(nonatomic, strong) NSMutableArray *annexFileArr;

//图片流数据
@property(nonatomic, strong) NSMutableArray *assets;
//拍照之后的流数据
@property(nonatomic, strong) NSMutableArray *groups;

@property(nonatomic, strong) ALAssetsLibrary *assetsLibrary;

//录音功能
@property(nonatomic, strong) SDRecordViewController *recordVc;

@property(nonatomic, strong) NSMutableDictionary *detailVoiceDict;
/*录音按钮，实现暂停播放的功能**/
@property(nonatomic, assign) BOOL isPlaySound;

@property(nonatomic, assign) CXERPAnnexViewType type;

@property(nonatomic, assign) BOOL isDetail;

@property(nonatomic, strong) NSMutableArray *addCostArray;

@end

@implementation CXERPAnnexView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.type = CXERPAnnexViewTypePictureAndVoice;
        [self creatViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame type:(CXERPAnnexViewType)type {
    if ([super initWithFrame:frame]) {
        self.type = type;
        [self creatViews];
    }
    return self;
}

#pragma mark -- 清空所有附件的数据

- (void)cleanData {
    [_addAnnexDataArray removeAllObjects];
    [_albumImageArray removeAllObjects];
    [_selectedAssetArray removeAllObjects];
    [_selectVoiceArr removeAllObjects];
    [_voiceDict removeAllObjects];
    self.voiceDict = nil;
    _detailVoiceDict = nil;

    NSArray *imageNameArr = @[@"annex_image.png", @"annex_voice.png", @"annex_file.png", @"annex_cost_n.png"];
    for (NSInteger i = 0; i < self.btnArray.count; i++) {
        UIButton *button = self.btnArray[i];
        [button setImage:[UIImage imageNamed:imageNameArr[i]] forState:UIControlStateNormal];
    }
}

#pragma mark - get*set

- (UIViewController *)vc {
    if (!_vc) {
        AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        _vc = delegate.window.rootViewController;
    }
    return _vc;
}

- (NSMutableArray *)addAnnexDataArray {
    if (nil == _addAnnexDataArray) {
        _addAnnexDataArray = [[NSMutableArray alloc] init];
    }
    return _addAnnexDataArray;
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

- (NSMutableArray *)annexFileArr {
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

- (NSString *)title {
    return self.titleLabel.title;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.title = title;
}

#pragma mark - UI

- (void)creatViews {

    self.backgroundColor = [UIColor whiteColor];//kColorWithRGB(240, 240, 240);
    //按钮
    NSArray *imageNameArr = @[@"annex_image.png", @"annex_voice.png", @"annex_file.png", @"annex_cost_n.png"];
    CXEditLabel *title = [[CXEditLabel alloc] initWithFrame:CGRectMake(kFormViewMargin, 0, Screen_Width / 3.0, kLineHeight)];
    title.title = @"附件：";
    title.allowEditing = NO;
    [self addSubview:title];
    self.titleLabel = title;

    int total = self.type - 10;

    if (self.type == CXERPAnnexViewTypePictureVoiceAndCost) {
        imageNameArr = @[@"annex_image.png", @"annex_voice.png", @"annex_cost_n.png"];
        total = 3;
    }

    for (int i = 0; i < total; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];

        [btn setFrame:CGRectMake(Screen_Width / 3.0 + 55 * i, (kLineHeight - 30) / 2.0, 30, 30)];
        if (i==2) {
            [btn setFrame:CGRectMake(Screen_Width / 3.0 + 55 * i, (kLineHeight - 30) / 2.0, 30, 30)];
        }
        if (i==3) {
            [btn setFrame:CGRectMake(Screen_Width / 3.0 + 55 * i, (kLineHeight - 30) / 2.0, 30, 30)];
        }
        [btn setImage:[UIImage imageNamed:imageNameArr[i]] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13.f]];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:i + 10];
        btn.accessibilityIdentifier = [NSString stringWithFormat:@"%ld", (long)self.type];

        [self addSubview:btn];
        [self.btnArray addObject:btn];
    }

    //加上下的分割线
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.frame = CGRectMake(0, 0, Screen_Width, kFormLineViewHeight);
    lineView1.backgroundColor = [UIColor lightGrayColor];
    //[self addSubview:lineView1];

    UIView *lineView2 = [[UIView alloc] init];
    lineView2.frame = CGRectMake(0, kLineHeight - kFormViewDividingLine, Screen_Width, kFormViewDividingLine);
    lineView2.backgroundColor = [UIColor lightGrayColor];
    //[self addSubview:lineView2];
}

// (详情时必须传进来)
- (void)setDetailAnnexDataArray:(NSMutableArray *)detailAnnexDataArray {
    [self.annexFileArr removeAllObjects];
    _detailAnnexDataArray = detailAnnexDataArray;
    _detailVoiceDict = [NSMutableDictionary dictionary];

    //清空之前的附件数据
    [self.albumImageArray removeAllObjects];
    self.voiceDict = nil;

    for (NSMutableDictionary *dict in _detailAnnexDataArray) {
        if ([dict[@"type"] isEqualToString:@"jpg"] || [dict[@"type"] isEqualToString:@"png"]) {
            [self.albumImageArray addObject:dict];
        }
        if ([dict[@"type"] isEqualToString:@"spx"]) {
            [_detailVoiceDict setValue:dict[@"path"] forKey:@"voicePath"];
            [_detailVoiceDict setValue:dict[@"srcName"] forKey:@"srcName"];
            self.voiceDict = _detailVoiceDict;
        }
        if ([[NSString stringWithFormat:@"%@", dict[@"showType"]] isEqualToString:@"1"]) {
            [self.annexFileArr addObject:dict];
        }
    }

    //图片
    if ([self.albumImageArray count]) {
        UIButton *button = self.btnArray[0];
        [self.btnArray[0] setImage:[UIImage imageNamed:@"annex_image_y"] forState:UIControlStateNormal];
        button.userInteractionEnabled = YES;

    } else {
        UIButton *button = self.btnArray[0];
        [self.btnArray[0] setImage:[UIImage imageNamed:@"annex_image"] forState:UIControlStateNormal];
        button.userInteractionEnabled = NO;
    }

    //声音
    if ([self.voiceDict count]) {
        UIButton *button = self.btnArray[1];
        [self.btnArray[1] setImage:[UIImage imageNamed:@"annex_voice_y"] forState:UIControlStateNormal];
        button.userInteractionEnabled = YES;
    } else {
        UIButton *button = self.btnArray[1];
        [button setImage:[UIImage imageNamed:@"annex_voice"] forState:UIControlStateNormal];
        button.userInteractionEnabled = NO;
    }

    //有附件
    if (self.btnArray.count == 3 && self.type == CXERPAnnexViewTypePictureVoiceAndAnnex) {
        if ([self.annexFileArr count]) {
            UIButton *button = self.btnArray[2];
            [self.btnArray[2] setImage:[UIImage imageNamed:@"annex_file_y"] forState:UIControlStateNormal];
            button.userInteractionEnabled = YES;
        } else {
            UIButton *button = self.btnArray[2];
            [self.btnArray[2] setImage:[UIImage imageNamed:@"annex_file"] forState:UIControlStateNormal];
            button.userInteractionEnabled = NO;
        }
    }
}

- (void)setDetailCostArray:(NSMutableArray *)detailCostArray {
    _detailCostArray = detailCostArray;
    
    if(self.type >=14){
        if (detailCostArray.count) {
            // 有费用
            UIButton *button = self.btnArray.lastObject;
            [button setImage:[UIImage imageNamed:@"annex_cost_y"] forState:UIControlStateNormal];
            button.userInteractionEnabled = YES;
        } else {
            UIButton *button = self.btnArray.lastObject;
            [button setImage:[UIImage imageNamed:@"annex_cost_n"] forState:UIControlStateNormal];
            button.userInteractionEnabled = NO;
        }
    }
    self.isDetail = YES;
}

- (void)btnClick:(UIButton *)button {
    if (button.tag == 10) {
        /** 图片点击 */
        if (_detailAnnexDataArray.count && self.albumImageArray.count) {
            // 详情
            SDDetailInfoViewController *detailVC = [[SDDetailInfoViewController alloc] init];
            detailVC.annexArray = self.albumImageArray;
            detailVC.index = 0;
            [self.window.rootViewController presentViewController:detailVC animated:YES completion:nil];
        } else if (!_detailAnnexDataArray.count) {
            [self LocalPhoto];
        }
    } else if (button.tag == 11) {
        /** 录音点击 */
        if (_detailAnnexDataArray.count) {
            [self voicePlay];
        } else {
            [self.recordVc.view removeFromSuperview];
            self.recordVc.delegate = self;
            [KEY_WINDOW addSubview:self.recordVc.view];
        }
    } else if (button.tag == 12) {
        if ([button.accessibilityIdentifier isEqualToString:[NSString stringWithFormat:@"%ld", (long)CXERPAnnexViewTypePictureVoiceAndCost]]) {
            
            return;
        }
        /** 附件点击 */
        if ([self.annexFileArr count]) {
            //点击附件，显示附件
            UINavigationController *nav = [self getNavigaTionController];
            CXAnnexViewController *annexViewController = [[CXAnnexViewController alloc] init];
            annexViewController.annexDataArray = self.annexFileArr;
            [nav pushViewController:annexViewController animated:YES];
        }
    } else if (button.tag == 13) {
        // TODO:2种情况下面会出现资金明细
        
    }
}

#pragma mark -- 获取视图控制器

- (UINavigationController *)getNavigaTionController {
    for (UIView *view = self.superview; view; view = view.superview) {
        if ([view.nextResponder isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *) view.nextResponder;
        }
    }

    return nil;
}

- (SDRecordViewController *)recordVc {
    if (!_recordVc) {
        _recordVc = [[SDRecordViewController alloc] init];
    }
    return _recordVc;
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
    for (NSInteger i = self.addAnnexDataArray.count - 1; i >= 0; i--) {
        SDUploadFileModel *model = self.addAnnexDataArray[i];
        if ([model.mimeType isEqualToString:@"image/jpg"]) {
            [self.addAnnexDataArray removeObjectAtIndex:i];
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
        [self.btnArray[0] setImage:[UIImage imageNamed:@"annex_image_y"] forState:UIControlStateNormal];

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
            [self.addAnnexDataArray addObject:model];
        }
    }
//    [self.annexDataDict setValue:_selectedAssetArray forKey:@"ImageAsset"];
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
    return self.selectedAssetArray;
}

#pragma mark - 拍照后图片后的回调

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);

    [self.albumImageArray addObject:image];

    [picker dismissViewControllerAnimated:YES completion:nil];
    [self performSelector:@selector(setupGroup) withObject:nil afterDelay:0.5f];

    if (self.albumImageArray.count) {
        [self.btnArray[0] setImage:[UIImage imageNamed:@"annex_image_y"] forState:UIControlStateNormal];

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
            [self.addAnnexDataArray addObject:model];
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
                [self.btnArray[0] setImage:[UIImage imageNamed:@"annex_image_y"] forState:UIControlStateNormal];
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
#pragma mark - SDRecordViewController的代理方法 录音

- (void)setUpVideo:(NSString *)videoPath withduration:(float)duration {
    for (NSInteger i = self.addAnnexDataArray.count - 1; i >= 0; i--) {
        SDUploadFileModel *model = self.addAnnexDataArray[i];
        if ([model.mimeType isEqualToString:@"sound/amr"]) {
            [self.addAnnexDataArray removeObjectAtIndex:i];
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
            [self.btnArray[1] setImage:[UIImage imageNamed:@"annex_voice_y"] forState:UIControlStateNormal];
        });
        //声音附件
        SDUploadFileModel *model = [self.selectVoiceArr firstObject];
        [self.addAnnexDataArray addObject:model];
    }
//    [self.annexDataDict setValue:_selectVoiceArr forKey:@"VoiceArray"];
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

- (void)annexUpLoad {
    __weak __typeof(self) weakSelf = self;
    if (self.addAnnexDataArray.count) {
        [self.vc showHudInView:self.vc.view hint:nil];
        [HttpTool multipartPostFileDataWithPath:@"annex/fileUpload.json" params:nil dataAry:self.addAnnexDataArray success:^(id JSON) {
            [weakSelf.vc hideHud];
            if ([JSON[@"status"] integerValue] == 200) {
                NSArray *annexArray = JSON[@"data"];
                NSData *data;
                NSString *annexList;
                if (annexArray.count) {
                    data = [NSJSONSerialization dataWithJSONObject:annexArray options:NSJSONWritingPrettyPrinted error:nil];
                    annexList = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

                }
                if (weakSelf.annexUploadCallBack) {
                    weakSelf.annexUploadCallBack(annexList);
                }
            } else {
                TTAlert(JSON[@"msg"]);
            }
        }                               failure:^(NSError *error) {
            [weakSelf.vc hideHud];
            TTAlert(KNetworkFailRemind);
        }];
    } else {
        if (self.annexUploadCallBack) {
            self.annexUploadCallBack(nil);
        }
    }
}

- (void)setFundDetail:(FundDetail)fundDetail {
    CXWeakSelf(self)
    NSString *url = [NSString stringWithFormat:@"/annex/getCapitalDetail/%d/%ld.json", fundDetail.type, fundDetail.bid];
    HUD_SHOW(nil);
    [HttpTool getWithPath:url params:nil success:^(id JSON) {
        HUD_HIDE;
        if ([JSON[@"status"] intValue] == 200) {
            weakself.detailCostArray = [NSMutableArray arrayWithArray:JSON[@"data"]];
        } else {
            CXAlert(JSON[@"msg"]);
        }
    }             failure:^(NSError *error) {
        HUD_HIDE;
        CXAlert(KNetworkFailRemind);
    }];
}

- (void)setAddCostArray:(NSMutableArray *)addCostArray {
    _addCostArray = addCostArray;

    if (addCostArray.count) {
        NSMutableArray *detailListarray = [[NSMutableArray alloc] init];
//        for (CXFundDetailModel *model in addCostArray) {
//            NSDictionary *dic = @{
//                    @"name": model.name,
//                    @"spec": model.spec,
//                    @"unit": model.unit,
//                    @"price": model.price,
//                    @"quantity": model.quantity,
//                    @"money": model.money
//            };
//            [detailListarray addObject:dic];
//        }
        NSData *costData = [NSJSONSerialization dataWithJSONObject:detailListarray options:0 error:0];
        self.costString = [[NSString alloc] initWithData:costData encoding:NSUTF8StringEncoding];
    } else {
        self.costString = nil;
    }
}

@end
