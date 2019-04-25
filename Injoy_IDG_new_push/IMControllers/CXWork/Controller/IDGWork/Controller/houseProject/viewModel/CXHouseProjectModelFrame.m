//
//  CXHouseProjectModelFrame.m
//  InjoyIDG
//
//  Created by ^ on 2018/5/28.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXHouseProjectModelFrame.h"
#import "Masonry.h"

#define fontName @"PingFangSC_Regular"
#define uinitpx (Screen_Width/375.0)
#define viewmargin (15 * uinitpx)
#define margin (5 * uinitpx)
#define labelmargin (3 * uinitpx)
#define scale (16/46.0)
#define topmargin (10*uinitpx) //工程名顶部距离contentView的距离
#define nameTopMargin (topmargin) //name距离contentView顶部的距离
#define projectNameHeight (25*uinitpx) //工程名的高度
#define nameHeight (17*uinitpx) //name的高度
#define industryHeight (20*uinitpx) //行业高度
#define CellHeight (84*uinitpx) //cell高度
@implementation CXHouseProjectModelFrame

#define imageViewSize (46*uinitpx)
- (void)setModel:(CXHouseProjectModel *)model{
    CGFloat x = imageViewSize + 2*viewmargin;
    CGFloat width = Screen_Width - 5*viewmargin - imageViewSize;
    UILabel *testLabel = [[UILabel alloc]init];
    
    testLabel.text = model.projManagerNames;
    testLabel.font = [UIFont systemFontOfSize:12.f];
    [testLabel sizeToFit];
    CGFloat nameWidth = testLabel.frame.size.width;
    
    self.projectNameLabelFrame = CGRectMake(x, topmargin, width - nameWidth, projectNameHeight);
    self.nameLabelFrame = CGRectMake(CGRectGetMaxX(self.projectNameLabelFrame), nameTopMargin, nameWidth, nameHeight);
    
    self.groupNameLabelFrame = CGRectMake(x, CGRectGetMaxY(self.projectNameLabelFrame), width, industryHeight);
    
    self.remarkLabelFrame = CGRectMake(x, CGRectGetMaxY(self.groupNameLabelFrame), width, industryHeight);
    
    self.cellHeight = CellHeight;
    _model = model;
}
- (void)setManagerModel:(CXIDGProjectManagementListModel *)managerModel{
    NSString *groupDtr;
    UIColor *fontColor;
    switch ([managerModel.projGroup integerValue]) {
        case -1:
        case 8:{
            groupDtr = @"其他";
            fontColor = kColorWithRGB(99,141,208);
        }
            break;
        case 1:{
            groupDtr = @"VC";
            fontColor = kColorWithRGB(174,17,41);
        }
            break;
        case 2:{
            groupDtr = @"工业";
            fontColor = kColorWithRGB(210,135,62);
        }
            break;
        case 3:{
            groupDtr = @"PE";
            fontColor = kColorWithRGB(174,17,41);
        }
            break;
        case 4:{
            groupDtr = @"地产";
            fontColor = kColorWithRGB(99,141,208);
        }
            break;
        case 5:{
            groupDtr = @"保险";
            fontColor = kColorWithRGB(70,158,133);
        }
            break;
        case 6:{
            groupDtr = @"娱乐";
            fontColor = kColorWithRGB(99,141,208);
        }
            break;
        case 7:{
            groupDtr = @"体育";
            fontColor = kColorWithRGB(70,158,133);
        }
            break;
        case 9:{
            groupDtr = @"并购";
            fontColor = kColorWithRGB(174,17,41);
        }
            break;
        case 10:{
            groupDtr = @"医疗";
            fontColor = kColorWithRGB(70,158,133);
        }
            break;
        case 87619:{
            groupDtr = @"能源";
            fontColor = kColorWithRGB(70,158,133);
        }
            break;
        case 144144:{
            groupDtr = @"金融";
            fontColor = kColorWithRGB(210,135,62);
        }
            break;
        case 5354:{
            groupDtr = @"PE";
            fontColor = kColorWithRGB(210,135,62);
        }
            break;
        default:{
            groupDtr = @"其他";
            fontColor = kColorWithRGB(99,141,208);
        }
            break;
    }
    UILabel *label = [[UILabel alloc]init];
    label.text = groupDtr;
    label.font = [UIFont systemFontOfSize:800 *scale];
    [label sizeToFit];
    
    UIGraphicsBeginImageContext(CGSizeMake(800, 800));
    
    NSString *str = @" ";
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:800 *scale], NSForegroundColorAttributeName : fontColor};
    [str drawInRect:CGRectMake((800 - label.frame.size.width)/2.0, (800 - label.frame.size.height)/2.0, label.frame.size.width, label.frame.size.height) withAttributes:dic];
    UIImage *ima = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.image = [self imageCompressForSize:ima targetSize:CGSizeMake(imageViewSize, imageViewSize)];
    
    CGFloat x = imageViewSize + 2*viewmargin;
    CGFloat width = Screen_Width - 5*viewmargin - imageViewSize;
    UILabel *testLabel = [[UILabel alloc]init];
    
    testLabel.text = managerModel.projManagerName?:@"   ";
    testLabel.font = [UIFont systemFontOfSize:12.f];
    [testLabel sizeToFit];
    CGFloat nameWidth = testLabel.frame.size.width;
    
    self.projectNameLabelFrame = CGRectMake(x, topmargin, width - nameWidth, projectNameHeight);
    self.nameLabelFrame = CGRectMake(CGRectGetMaxX(self.projectNameLabelFrame), nameTopMargin, nameWidth, nameHeight);
    self.groupNameLabelFrame = CGRectMake(x, CGRectGetMaxY(self.projectNameLabelFrame), width, industryHeight);
    self.remarkLabelFrame = CGRectMake(x, CGRectGetMaxY(self.groupNameLabelFrame), width, industryHeight);
    
    self.cellHeight = CellHeight;
    _managerModel = managerModel;
}
- (void)setMetModel:(CXMetProjectListModel *)metModel{
    NSString *groupDtr;
    UIColor *fontColor;
    switch ([metModel.projGroup integerValue]) {
        case -1:
        case 8:{
            groupDtr = @"其他";
            fontColor = kColorWithRGB(99,141,208);
        }
            break;
        case 1:{
            groupDtr = @"VC";
            fontColor = kColorWithRGB(174,17,41);
        }
            break;
        case 2:{
            groupDtr = @"工业";
            fontColor = kColorWithRGB(210,135,62);
        }
            break;
        case 3:{
            groupDtr = @"PE";
            fontColor = kColorWithRGB(174,17,41);
        }
            break;
        case 4:{
            groupDtr = @"地产";
            fontColor = kColorWithRGB(99,141,208);
        }
            break;
        case 5:{
            groupDtr = @"保险";
            fontColor = kColorWithRGB(70,158,133);
        }
            break;
        case 6:{
            groupDtr = @"娱乐";
            fontColor = kColorWithRGB(99,141,208);
        }
            break;
        case 7:{
            groupDtr = @"体育";
            fontColor = kColorWithRGB(70,158,133);
        }
            break;
        case 9:{
            groupDtr = @"并购";
            fontColor = kColorWithRGB(174,17,41);
        }
            break;
        case 10:{
            groupDtr = @"医疗";
            fontColor = kColorWithRGB(70,158,133);
        }
            break;
        case 87619:{
            groupDtr = @"能源";
            fontColor = kColorWithRGB(70,158,133);
        }
            break;
        case 144144:{
            groupDtr = @"金融";
            fontColor = kColorWithRGB(210,135,62);
        }
            break;
        case 5354:{
            groupDtr = @"PE";
            fontColor = kColorWithRGB(210,135,62);
        }
            break;
        default:{
            groupDtr = @"其他";
            fontColor = kColorWithRGB(99,141,208);
        }
            break;
    }
    UILabel *label = [[UILabel alloc]init];
    label.text = groupDtr;
    label.font = [UIFont systemFontOfSize:800 *scale];
    [label sizeToFit];
    
    UIGraphicsBeginImageContext(CGSizeMake(800, 800));
    
    NSString *str = @" ";
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:800 *scale], NSForegroundColorAttributeName : fontColor};
    [str drawInRect:CGRectMake((800 - label.frame.size.width)/2.0, (800 - label.frame.size.height)/2.0, label.frame.size.width, label.frame.size.height) withAttributes:dic];
    UIImage *ima = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.image = [self imageCompressForSize:ima targetSize:CGSizeMake(imageViewSize, imageViewSize)];
    
    CGFloat x = imageViewSize + 2*viewmargin;
    CGFloat width = Screen_Width - 5*viewmargin - imageViewSize;
    UILabel *testLabel = [[UILabel alloc]init];
    
    testLabel.text = metModel.userName?:@"   ";
    testLabel.font = [UIFont systemFontOfSize:12.f];
    [testLabel sizeToFit];
    CGFloat nameWidth = testLabel.frame.size.width;
    
    self.projectNameLabelFrame = CGRectMake(x, topmargin, width - nameWidth, projectNameHeight);
    self.nameLabelFrame = CGRectMake(CGRectGetMaxX(self.projectNameLabelFrame), nameTopMargin, nameWidth, nameHeight);
    self.groupNameLabelFrame = CGRectMake(x, CGRectGetMaxY(self.projectNameLabelFrame) , width, industryHeight);
    self.remarkLabelFrame = CGRectMake(x, CGRectGetMaxY(self.groupNameLabelFrame), width, industryHeight);
    
    self.cellHeight = CellHeight;
    _metModel = metModel;
}
- (void)setZJYXLGSModel:(CXZJYXLGSListModel *)ZJYXLGSModel{
    NSString *groupDtr;
    UIColor *fontColor;
    switch ([ZJYXLGSModel.projGroup integerValue]) {
        case -1:
        case 8:{
            groupDtr = @"其他";
            fontColor = kColorWithRGB(99,141,208);
        }
            break;
        case 1:{
            groupDtr = @"VC";
            fontColor = kColorWithRGB(174,17,41);
        }
            break;
        case 2:{
            groupDtr = @"工业";
            fontColor = kColorWithRGB(210,135,62);
        }
            break;
        case 3:{
            groupDtr = @"PE";
            fontColor = kColorWithRGB(174,17,41);
        }
            break;
        case 4:{
            groupDtr = @"地产";
            fontColor = kColorWithRGB(99,141,208);
        }
            break;
        case 5:{
            groupDtr = @"保险";
            fontColor = kColorWithRGB(70,158,133);
        }
            break;
        case 6:{
            groupDtr = @"娱乐";
            fontColor = kColorWithRGB(99,141,208);
        }
            break;
        case 7:{
            groupDtr = @"体育";
            fontColor = kColorWithRGB(70,158,133);
        }
            break;
        case 9:{
            groupDtr = @"并购";
            fontColor = kColorWithRGB(174,17,41);
        }
            break;
        case 10:{
            groupDtr = @"医疗";
            fontColor = kColorWithRGB(70,158,133);
        }
            break;
        case 87619:{
            groupDtr = @"能源";
            fontColor = kColorWithRGB(70,158,133);
        }
            break;
        case 144144:{
            groupDtr = @"金融";
            fontColor = kColorWithRGB(210,135,62);
        }
            break;
        case 5354:{
            groupDtr = @"PE";
            fontColor = kColorWithRGB(210,135,62);
        }
            break;
        default:{
            groupDtr = @"其他";
            fontColor = kColorWithRGB(99,141,208);
        }
            break;
    }
    UILabel *label = [[UILabel alloc]init];
    label.text = groupDtr;
    label.font = [UIFont systemFontOfSize:800 *scale];
    [label sizeToFit];
    
    UIGraphicsBeginImageContext(CGSizeMake(800, 800));
    
    NSString *str = @" ";
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:800 *scale], NSForegroundColorAttributeName : fontColor};
    [str drawInRect:CGRectMake((800 - label.frame.size.width)/2.0, (800 - label.frame.size.height)/2.0, label.frame.size.width, label.frame.size.height) withAttributes:dic];
    UIImage *ima = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.image = [self imageCompressForSize:ima targetSize:CGSizeMake(imageViewSize, imageViewSize)];
    
    CGFloat x = imageViewSize + 2*viewmargin;
    CGFloat width = Screen_Width - 5*viewmargin - imageViewSize;
    UILabel *testLabel = [[UILabel alloc]init];
    
    testLabel.text = ZJYXLGSModel.projManagerName?:@"   ";
    testLabel.font = [UIFont systemFontOfSize:12.f];
    [testLabel sizeToFit];
    CGFloat nameWidth = testLabel.frame.size.width;
    
    self.projectNameLabelFrame = CGRectMake(x, topmargin, width - nameWidth, projectNameHeight);
    self.nameLabelFrame = CGRectMake(CGRectGetMaxX(self.projectNameLabelFrame), nameTopMargin, nameWidth, nameHeight);
    
    //---------------2018_6_15宋万里备份-----------------
//    self.groupNameLabelFrame = CGRectMake(x, CGRectGetMaxY(self.projectNameLabelFrame), width, industryHeight);
//    self.remarkLabelFrame = CGRectMake(x, CGRectGetMaxY(self.groupNameLabelFrame), width, industryHeight);
    //---------------2018_6_15宋万里备份-----------------
    //---------------2018_6_15宋万里新的-----------------
    self.groupNameLabelFrame = CGRectMake(x, CGRectGetMaxY(self.projectNameLabelFrame) + industryHeight, width, industryHeight);
    self.remarkLabelFrame = CGRectMake(0, 0, 0, 0);//CGRectMake(x, CGRectGetMaxY(self.projectNameLabelFrame), width, industryHeight);
    //---------------2018_6_15宋万里新的-----------------
    
    self.cellHeight = CellHeight;
    _ZJYXLGSModel = ZJYXLGSModel;
}
- (void)setTMTModel:(CXTMTPotentialProjectListModel *)TMTModel{
    NSString *groupDtr;
    UIColor *fontColor;
    switch ([TMTModel.projGroup integerValue]) {
        case -1:
        case 8:{
            groupDtr = @"其他";
            fontColor = kColorWithRGB(99,141,208);
        }
            break;
        case 1:{
            groupDtr = @"VC";
            fontColor = kColorWithRGB(174,17,41);
        }
            break;
        case 2:{
            groupDtr = @"工业";
            fontColor = kColorWithRGB(210,135,62);
        }
            break;
        case 3:{
            groupDtr = @"PE";
            fontColor = kColorWithRGB(174,17,41);
        }
            break;
        case 4:{
            groupDtr = @"地产";
            fontColor = kColorWithRGB(99,141,208);
        }
            break;
        case 5:{
            groupDtr = @"保险";
            fontColor = kColorWithRGB(70,158,133);
        }
            break;
        case 6:{
            groupDtr = @"娱乐";
            fontColor = kColorWithRGB(99,141,208);
        }
            break;
        case 7:{
            groupDtr = @"体育";
            fontColor = kColorWithRGB(70,158,133);
        }
            break;
        case 9:{
            groupDtr = @"并购";
            fontColor = kColorWithRGB(174,17,41);
        }
            break;
        case 10:{
            groupDtr = @"医疗";
            fontColor = kColorWithRGB(70,158,133);
        }
            break;
        case 87619:{
            groupDtr = @"能源";
            fontColor = kColorWithRGB(70,158,133);
        }
            break;
        case 144144:{
            groupDtr = @"金融";
            fontColor = kColorWithRGB(210,135,62);
        }
            break;
        case 5354:{
            groupDtr = @"PE";
            fontColor = kColorWithRGB(210,135,62);
        }
            break;
        default:{
            groupDtr = @"其他";
            fontColor = kColorWithRGB(99,141,208);
        }
            break;
    }
    UILabel *label = [[UILabel alloc]init];
    label.text = groupDtr;
    label.font = [UIFont systemFontOfSize:800 *scale];
    [label sizeToFit];
    
    UIGraphicsBeginImageContext(CGSizeMake(800, 800));
    
    NSString *str = @" ";
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:800 *scale], NSForegroundColorAttributeName : fontColor};
    [str drawInRect:CGRectMake((800 - label.frame.size.width)/2.0, (800 - label.frame.size.height)/2.0, label.frame.size.width, label.frame.size.height) withAttributes:dic];
    UIImage *ima = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.image = [self imageCompressForSize:ima targetSize:CGSizeMake(imageViewSize, imageViewSize)];
    
    CGFloat x = imageViewSize + 2*viewmargin;
    CGFloat width = Screen_Width - 5*viewmargin - imageViewSize;
    UILabel *testLabel = [[UILabel alloc]init];
    
    testLabel.text = TMTModel.followUpPersonName?:@"   ";
    testLabel.font = [UIFont systemFontOfSize:12.f];
    [testLabel sizeToFit];
    CGFloat nameWidth = testLabel.frame.size.width;

    self.projectNameLabelFrame = CGRectMake(x, topmargin, width - nameWidth, projectNameHeight);
    self.nameLabelFrame = CGRectMake(CGRectGetMaxX(self.projectNameLabelFrame), nameTopMargin, nameWidth, nameHeight);
    self.groupNameLabelFrame = CGRectMake(x, CGRectGetMaxY(self.projectNameLabelFrame), width, industryHeight);
    self.remarkLabelFrame = CGRectMake(x, CGRectGetMaxY(self.groupNameLabelFrame) + labelmargin, width, industryHeight);
    
    
    self.cellHeight = CellHeight;
    _TMTModel = TMTModel;
}
- (void)setResearchModel:(CXIDGResearchReportListModel *)researchModel{
    NSString *groupDtr;
    UIColor *fontColor;
    switch ([researchModel.indusGroup integerValue]) {
        case -1:
        case 8:{
            groupDtr = @"其他";
            fontColor = kColorWithRGB(99,141,208);
        }
            break;
        case 1:{
            groupDtr = @"VC";
            fontColor = kColorWithRGB(174,17,41);
        }
            break;
        case 2:{
            groupDtr = @"工业";
            fontColor = kColorWithRGB(210,135,62);
        }
            break;
        case 3:{
            groupDtr = @"PE";
            fontColor = kColorWithRGB(174,17,41);
        }
            break;
        case 4:{
            groupDtr = @"地产";
            fontColor = kColorWithRGB(99,141,208);
        }
            break;
        case 5:{
            groupDtr = @"保险";
            fontColor = kColorWithRGB(70,158,133);
        }
            break;
        case 6:{
            groupDtr = @"娱乐";
            fontColor = kColorWithRGB(99,141,208);
        }
            break;
        case 7:{
            groupDtr = @"体育";
            fontColor = kColorWithRGB(70,158,133);
        }
            break;
        case 9:{
            groupDtr = @"并购";
            fontColor = kColorWithRGB(174,17,41);
        }
            break;
        case 10:{
            groupDtr = @"医疗";
            fontColor = kColorWithRGB(70,158,133);
        }
            break;
        case 87619:{
            groupDtr = @"能源";
            fontColor = kColorWithRGB(70,158,133);
        }
            break;
        case 144144:{
            groupDtr = @"金融";
            fontColor = kColorWithRGB(210,135,62);
        }
            break;
        case 5354:{
            groupDtr = @"PE";
            fontColor = kColorWithRGB(210,135,62);
        }
            break;
        default:{
            groupDtr = @"其他";
            fontColor = kColorWithRGB(99,141,208);
        }
            break;
    }
    UILabel *label = [[UILabel alloc]init];
    label.text = groupDtr;
    label.font = [UIFont systemFontOfSize:800 *scale];
    [label sizeToFit];
    
    UIGraphicsBeginImageContext(CGSizeMake(800, 800));
    
    NSString *str = @" ";
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:800 *scale], NSForegroundColorAttributeName : fontColor};
    [str drawInRect:CGRectMake((800 - label.frame.size.width)/2.0, (800 - label.frame.size.height)/2.0, label.frame.size.width, label.frame.size.height) withAttributes:dic];
    UIImage *ima = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.image = [self imageCompressForSize:ima targetSize:CGSizeMake(imageViewSize, imageViewSize)];
    
    CGFloat x = imageViewSize + 2*viewmargin;
    CGFloat width = Screen_Width - 5*viewmargin - imageViewSize;
    UILabel *testLabel = [[UILabel alloc]init];
    
    testLabel.text = researchModel.authorName?:@"   ";
    testLabel.font = [UIFont systemFontOfSize:12.f];
    [testLabel sizeToFit];
    CGFloat nameWidth = testLabel.frame.size.width;

    self.projectNameLabelFrame = CGRectMake(x, topmargin, width - nameWidth, projectNameHeight);
    self.nameLabelFrame = CGRectMake(CGRectGetMaxX(self.projectNameLabelFrame), nameTopMargin, nameWidth, nameHeight);
    self.groupNameLabelFrame = CGRectMake(x, CGRectGetMaxY(self.projectNameLabelFrame) , width, industryHeight);
    self.remarkLabelFrame = CGRectMake(x, CGRectGetMaxY(self.groupNameLabelFrame), width, industryHeight);
    
    
    self.cellHeight = CellHeight;
    _researchModel = researchModel;
}
- (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)targetSize{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaleWidth = targetWidth;
    CGFloat scaleHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, targetSize) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }else{
        scaleFactor = heightFactor;
    }
        scaleWidth = width * scaleFactor;
        scaleHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaleHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaleWidth) * 0.5;
        }
}
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaleWidth;
    thumbnailRect.size.height = scaleHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}



@end
