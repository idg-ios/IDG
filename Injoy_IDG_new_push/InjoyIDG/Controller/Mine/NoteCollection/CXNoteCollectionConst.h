//
//  CXNoteCollectionConst.h
//  InjoyDDXWBG
//
//  Created by cheng on 2017/10/25.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#ifndef CXNoteCollectionConst_h
#define CXNoteCollectionConst_h

/** 列表类型 */
typedef NS_ENUM(NSInteger, CXNoteCollectionListType) {
    /** 公司账号 */
    CXNoteCollectionListTypeCompanyAccount,
    /** 开票信息 */
    CXNoteCollectionListTypeBilling,
    /** 公司地址 */
    CXNoteCollectionListTypeCompanyAddress,
    /** 个人卡号 */
    CXNoteCollectionListTypeCardNumber,
    /** 证件号码 */
    CXNoteCollectionListTypeIdNumber,
    /** 物流地址 */
    CXNoteCollectionListTypeLogisticsAddress,
    /** 其他 */
    CXNoteCollectionListTypeOther
};


#endif /* CXNoteCollectionConst_h */
