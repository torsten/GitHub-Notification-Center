//
//  NSDateFormatter+Extensions.h
//  GitHubNotificationCenter
//
//  Created by Lars Schneider on 5/4/12.
//  Copyright (c) 2012 6Wunderkinder. All rights reserved.
//


@interface NSDateFormatter (Extensions)

+ (NSDate *)dateFromRFC3339String:(NSString *)dateString;

@end

