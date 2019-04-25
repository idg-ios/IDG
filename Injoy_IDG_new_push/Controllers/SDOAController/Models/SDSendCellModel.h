//
//  SDSendCellModel.h
//  SDMarketingManagement
//
//  Created by 郭航 on 15/6/12.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum SendCellModelType{
    SendCellModelTypeImage = 1,
    SendCellModelTypeVoice,
    SendCellModelTypeEmail,
    SendCellModelTypeLocation,
    SendCellModelTypeTopic,
    SendCellModelTypeReceipt,
    SendCellModelTypeCotacts,
    SendCellModelTypeCustoms,
    SendCellModelTypeFinishTime,
    SendCellModelTypePurseMoney,
    SendCellModelTypePurseLeave,
    SendCellModelTypePurseVoice,
    SendCellModelTypeTopicContact
    
}SendCellModelType;

@interface SDSendCellModel : NSObject<NSCopying>

@property (nonatomic, copy) NSString *imageString;

@property (nonatomic, copy) NSString *introduce;

@property SendCellModelType modelType;
@end
