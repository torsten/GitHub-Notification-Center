//
//  TLMacros.h
//  GitHubNotificationCenter
//
//  Created by Lars Schneider on 5/4/12.
//  Copyright (c) 2012 6Wunderkinder. All rights reserved.
//

#define ALog(...) [[NSAssertionHandler currentHandler] handleFailureInFunction:[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] file:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lineNumber:__LINE__ description:__VA_ARGS__]

#define ZAssert(condition, ...) \
do \
{ \
if (!(condition)) { \
ALog(@"(%s), %@", #condition, [NSString stringWithFormat:__VA_ARGS__]); \
} \
} while(0)

