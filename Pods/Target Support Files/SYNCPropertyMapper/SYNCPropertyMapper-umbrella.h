#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSDate+SYNCPropertyMapper.h"
#import "NSEntityDescription+SYNCPrimaryKey.h"
#import "NSManagedObject+SYNCPropertyMapperHelpers.h"
#import "SYNCPropertyMapper.h"
#import "NSString+SYNCInflections.h"

FOUNDATION_EXPORT double SYNCPropertyMapperVersionNumber;
FOUNDATION_EXPORT const unsigned char SYNCPropertyMapperVersionString[];

