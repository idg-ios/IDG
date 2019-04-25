//
//  CXWorkCircleDetailCommentModel.h
//  InjoyERP
//
//  Created by wtz on 16/11/24.
//  Copyright © 2016年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXWorkCircleDetailCommentModel : NSObject

//评论ID
@property(nonatomic,copy)NSString *commentId;
//评论者的userId
@property(nonatomic,copy)NSString *commentUserId;
//评论者的userName
@property(nonatomic,copy)NSString *commentUserName;
//评论者的commentUserIcon
@property(nonatomic,copy)NSString *commentUserIcon;
//评论内容
@property(nonatomic,copy)NSString *commentText;
//该条评论的评论者userId
@property(nonatomic,copy)NSString *commentByUserId;
//该条评论的评论者userName
@property(nonatomic,copy)NSString *commentByUserName;
//该条评论的评论者userIcon
@property(nonatomic,copy)NSString *commentByUserIcon;
//创建时间
@property(nonatomic,copy)NSString *createTime;

@end
