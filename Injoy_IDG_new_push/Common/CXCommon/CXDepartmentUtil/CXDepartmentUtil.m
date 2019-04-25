//
//  CXDepartmentUtil.m
//  InjoyYJ1
//
//  Created by wtz on 2017/8/10.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXDepartmentUtil.h"
#import "HttpTool.h"

@implementation CXDepartmentUtil

singleton_implementation(CXDepartmentUtil)

- (void)getDepartmentDataFromServer {
    // 保存到本地
    NSString *url = [NSString stringWithFormat:@"%@sysDepartment/getDept", urlPrefix];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [HttpTool postWithPath:url
                   params:nil
                  success:^(id JSON) {
                      NSDictionary *dic = JSON;
                      NSNumber *status = dic[@"status"];
                      if ([status intValue] == 200) {
                          // 保存到本地
                          dispatch_async(dispatch_get_global_queue(0, 0), ^{
                              NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                              [userDefaults setValue:JSON[@"data"] forKey:kStaticDepartmentData];
                              [userDefaults synchronize];
                          });
                      }
          }
          failure:^(NSError *error) {
              TTAlertNoTitle(@"获取部门数据失败");
          }];
    });
}

- (NSArray<CXDepartmentModel *> *)getAllDepartmentStaticData
{
    NSArray *result = [NSArray yy_modelArrayWithClass:CXDepartmentModel.class json:VAL_kStaticDepartmentData];
    return result;
}

- (NSArray<NSNumber *> *)getDepartmentIDArray
{
    NSArray *result = [self getAllDepartmentStaticData];
    NSMutableArray * departmentIDArray = @[].mutableCopy;
    for(CXDepartmentModel * model in result){
        [departmentIDArray addObject:model.eid];
    }
    return departmentIDArray;
}

- (NSArray<NSString *> *)getDepartmentNameArray
{
    NSArray *result = [self getAllDepartmentStaticData];
    NSMutableArray * departmentNameArray = @[].mutableCopy;
    for(CXDepartmentModel * model in result){
        [departmentNameArray addObject:model.name];
    }
    return departmentNameArray;
}

- (CXDepartmentModel *)getDepartmentModelWithName:(NSString *)name
{
    NSArray *result = [self getAllDepartmentStaticData];
    for(CXDepartmentModel * model in result){
        if([name isEqualToString:model.name]){
            return model;
        }
    }
    return nil;
}

- (CXDepartmentModel *)getDepartmentModelWithEID:(NSNumber *)eid
{
    NSArray *result = [self getAllDepartmentStaticData];
    for(CXDepartmentModel * model in result){
        if(eid == model.eid){
            return model;
        }
    }
    return nil;
}

@end
