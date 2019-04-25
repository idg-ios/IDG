//
//  UIImage+CXCategory.m
//  SDMarketingManagement
//
//  Created by lancely on 5/12/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import "UIImage+CXCategory.h"

@implementation UIImage (CXCategory)

- (SDUploadFileModel *)uploadFileModel {
    SDUploadFileModel *model = [[SDUploadFileModel alloc] init];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *fileName = [dateFormatter stringFromDate:[NSDate date]];
    model.fileName = [NSString stringWithFormat:@"%@_%zd.jpg", fileName, arc4random_uniform(999)];
    model.fileData = UIImageJPEGRepresentation(self, 1.0);
    model.mimeType = @"image/jpg";
    return model;
}

//+ (instancetype)imageForApprovalStatus:(CXApprovalStatus)status {
//    NSString *imgName;
//    //    不同意
//    if (status == CXApprovalStatusDisagree) {
//        imgName = @"approvalNotPass";
//    }
//    //    同意
//    else if (status == CXApprovalStatusAgree) {
//        imgName = @"approvalHadPass";
//    }
//    //    审批中
//    else if (status == CXApprovalStatusOnApproval) {
//        imgName = @"approvaling";
//    }
//    return [UIImage imageNamed:imgName];
//}

+ (instancetype)imageForSelect:(NSInteger)status {
//    NSString *imgName;
//    //    没有选中
//    if (status == 0) {
//        imgName = @"CXPayUnselect";
//    }
//    //    选中
//    else if (status == CXApprovalStatusAgree) {
//        imgName = @"CXPaySelect";
//    }
//    return [UIImage imageNamed:imgName];
    
    return nil;
}

- (UIImage *)imageByResize {
    CGSize size = self.size;
    if (size.width <= 0 || size.height <= 0) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, kImageCompressRate);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
