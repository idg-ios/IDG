//
//  CXSingleton.h
//  SDMarketingManagement
//
//  Created by lancely on 5/14/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#ifndef CXSingleton_h
#define CXSingleton_h

/*
 singleton
 */

// @interface
#define singleton_interface(className) \
+ (className *)sharedInstance;


// @implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)sharedInstance \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}


#endif /* CXSingleton_h */
