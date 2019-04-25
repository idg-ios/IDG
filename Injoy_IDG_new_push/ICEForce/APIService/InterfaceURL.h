//
//  InterfaceURL.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/10.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -- 消息协同
/** 跟踪项目进展 POST */
UIKIT_EXTERN NSString * const POST_SNS_Follow;
/** 待办事项 POST */
UIKIT_EXTERN NSString * const POST_MSG_List;
/** 消息协同-@某人推荐项目，跟进项目,打分项目 POST */
UIKIT_EXTERN NSString * const POST_SNS_At;
/** 消息协同-获取参与项目打分的详情接口 POST */
UIKIT_EXTERN NSString * const POST_SNS_Score_Proj;
/** 消息协同-打分提交接口 PUT */
UIKIT_EXTERN NSString * const PUT_SNS_Score_Proj;

#pragma mark -- 潜在项目
/** 潜在项目-个人 POST */
UIKIT_EXTERN NSString * const POST_PROJ_Query_Myproj;
/** 潜在项目-小组 POST */
UIKIT_EXTERN NSString * const POST_PROJ_Query_Teamproj;
/** 潜在项目-小组 POST */
UIKIT_EXTERN NSString * const POST_PROJ_Add;
/** 潜在项目-项目详情 GET */
UIKIT_EXTERN NSString * const GET_PROJ_Query_Detail;
/** 潜在项目-变更项目状态 POST */
UIKIT_EXTERN NSString * const POST_PROJ_ChangeStatus;

#pragma mark - 项目管理
/** 项目管理-项目列表SELECT POST */
UIKIT_EXTERN NSString * const POST_PROJ_Query_SelectList;
/** 项目管理-新增项目跟踪进展 PUT */
UIKIT_EXTERN NSString * const PUT_PROJ_Note;
/** 项目管理-根据项目查询跟踪进展 POST */
UIKIT_EXTERN NSString * const POST_PROJ_Notes;
/** 项目管理-编辑潜在项目 POST */
UIKIT_EXTERN NSString * const POST_PROJ_Update;
/** 项目管理-查询项目打分整体详情信息 POST */
UIKIT_EXTERN NSString * const POST_PROJ_Score_List;
/** 项目管理-查询项目具体某次打分详情信息 POST */
UIKIT_EXTERN NSString * const POST_PROJ_Score_Detail;
/** 项目管理-查询项目库 POST */
UIKIT_EXTERN NSString * const POST_PROJ_Query_AllProj;
#pragma mark - 基础数据
/** 基础数据-项目状态(potentialStatus) GET */
UIKIT_EXTERN NSString * const GET_SYSCODE_QueryByType;
/** 基础数据-行业小组 GET */
UIKIT_EXTERN NSString * const GET_DEPT_QueryIndusDept;
/** 基础数据-用户搜索及查找 OPOST */
UIKIT_EXTERN NSString * const POST_USER_QueryByUserName;
 
