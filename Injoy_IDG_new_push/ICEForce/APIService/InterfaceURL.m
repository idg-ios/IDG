//
//  InterfaceURL.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/10.
//  Copyright © 2019 Injoy. All rights reserved.
//

/**
 * 注意事项
 * (POST请求下)/api/app/ 替换成 /iceForce/json
 * (GET请求下)/api/app/ 替换成 /iceForce/get
 * /api/app/xxx/xxx, xxx表示后续字段 层级为2层才会加入 2层以上不需要加holder
    li：/api/app/xxx/xxx/holder
 */


#pragma mark -- 消息协同
/** 消息协同-跟踪项目进展 POST */
NSString * const POST_SNS_Follow = @"/iceforce/post/sns/follow/holder";
/** 消息协同-待办事项 POST */
NSString * const POST_MSG_List = @"/iceforce/post/msg/list/holder";
/** 消息协同-@某人推荐项目，跟进项目,打分项目 POST */
NSString * const POST_SNS_At = @"/iceforce/post/sns/at/holder";
/** 消息协同-获取参与项目打分的详情接口 POST */
NSString * const POST_SNS_Score_Proj = @"/iceforce/post/sns/score/proj";
///** 消息协同-打分提交接口 PUT */
//NSString * const PUT_SNS_Score_Proj = @"/iceforce/put/sns/score/proj";

/** 消息协同-打分提交接口 post 临时 */
NSString * const PUT_SNS_Score_Proj = @"/iceforce/post/sns/score/projadd";


#pragma mark -- 潜在项目
/** 潜在项目-个人 POST */
NSString * const POST_PROJ_Query_Myproj = @"/iceforce/post/proj/query/myproj";
/** 潜在项目-小组 POST */
NSString * const POST_PROJ_Query_Teamproj = @"/iceforce/post/proj/query/teamproj";
/** 潜在项目-新增 POST */
NSString * const POST_PROJ_Add = @"/iceforce/post/proj/add/holder";
/** 潜在项目-项目详情 GET */
NSString * const GET_PROJ_Query_Detail = @"/iceforce/get/proj/query/detail";
/** 潜在项目-变更项目状态 POST */
NSString * const POST_PROJ_ChangeStatus = @"/iceforce/post/proj/changeStatus/holder";

#pragma mark - 项目管理
/** 项目管理-项目列表SELECT POST */
NSString * const POST_PROJ_Query_SelectList = @"/iceforce/post/proj/query/selectList";
///** 项目管理-新增项目跟踪进展 PUT */
//NSString * const PUT_PROJ_Note = @"/iceforce/put/proj/note/holder";

/** 项目管理-新增项目跟踪进展 PUT */
NSString * const PUT_PROJ_Note = @"/iceforce/post/proj/noteadd/holder";

/** 项目管理-根据项目查询跟踪进展 POST */
NSString * const POST_PROJ_Notes = @"/iceforce/post/proj/notes/holder";
/** 项目管理-编辑潜在项目 POST */
NSString * const POST_PROJ_Update = @"/iceforce/post/proj/update/holder";
/** 项目管理-查询项目打分整体详情信息 POST */
NSString * const POST_PROJ_Score_List = @"/iceforce/post/proj/score/list";
/** 项目管理-查询项目具体某次打分详情信息 POST */
NSString * const POST_PROJ_Score_Detail = @"/iceforce/post/proj/score/detail";
/** 项目管理-查询项目库 POST */
NSString * const POST_PROJ_Query_AllProj = @"/iceforce/post/proj/query/allproj";



#pragma mark - 基础数据
/** 基础数据-项目状态 GET */
NSString * const GET_SYSCODE_QueryByType = @"/iceforce/get/syscode/queryByType/holder";
/** 基础数据-行业小组 GET */
NSString * const GET_DEPT_QueryIndusDept = @"/iceforce/get/dept/queryIndusDept/holder";
/** 基础数据-用户搜索及查找 OPOST */
NSString * const POST_USER_QueryByUserName = @"/iceforce/post/user/queryByUserName/holder";
