//
//  UIImage+Category.h
//  SDIMApp
//
//  Created by lancely on 1/29/16.
//  Copyright © 2016 Rao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)
- (UIImage*)transformImageToSize:(CGSize)Newsize;
/// 处理图片的压缩
- (UIImage*)compressedImage;
@end
