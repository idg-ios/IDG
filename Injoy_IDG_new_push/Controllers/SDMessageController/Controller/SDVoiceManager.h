//
//  SDVoiceManager.h
//  SDMarketingManagement
//
//  Created by Rao on 15/12/21.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDVoiceManager : NSObject
+ (instancetype)sharedVoiceManager;
- (void)saveValue:(NSNumber*)value key:(NSString*)key;
- (NSNumber*)getValue:(NSString*)key;
@end
