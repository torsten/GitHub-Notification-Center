//
//  NSDateFormatter+Extensions.m
//  GitHubNotificationCenter
//
//  Created by Lars Schneider on 5/4/12.
//  Copyright (c) 2012 6Wunderkinder. All rights reserved.
//


#import "NSDateFormatter+Extensions.h"


@implementation NSDateFormatter (Extensions)


// ------------------------------------------------------------------------------------------
#pragma mark - Private shared date formatter instances
// ------------------------------------------------------------------------------------------
// NSDateFormatter as singelton since its creation is expensive
// c.f. http://developer.apple.com/iphone/library/qa/qa2010/qa1480.html
// NSDateFormatter are not thread-safe, hence use the NSDateFormatter in a synchronized block
// c.f. http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Multithreading/ThreadSafetySummary/ThreadSafetySummary.html#//apple_ref/doc/uid/10000057i-CH12-122647-BBCCEGFF
+ (NSDateFormatter *)sharedDateTimeFormatter
{
    static dispatch_once_t pred;
    static NSDateFormatter *shared = nil;

    dispatch_once(&pred, ^{
        NSLocale *en_US_POSIX = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        shared = [[NSDateFormatter alloc] init];
        [shared setFormatterBehavior:NSDateFormatterBehavior10_4];
        [shared setLocale:en_US_POSIX];
        [shared setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    });

    return shared;
}


// ------------------------------------------------------------------------------------------
#pragma mark - Date parsing
// ------------------------------------------------------------------------------------------
// c.f. https://github.com/mwaterfall/MWFeedParser/blob/master/Classes/NSDate+InternetDateTime.m
//      http://www.faqs.org/rfcs/rfc3339.html
+ (NSDate *)dateFromRFC3339String:(NSString *)dateString
{
    if (dateString == nil) return nil;

    NSDateFormatter *dateFormatter = [NSDateFormatter sharedDateTimeFormatter];
    NSDate *date = nil;

    @synchronized(dateFormatter)
    {
        // Process date
        NSString *rfc3339String = [[NSString stringWithString:dateString] uppercaseString];
        rfc3339String = [rfc3339String stringByReplacingOccurrencesOfString:@"Z" withString:@"-0000"];

        // Remove colon in timezone as it breaks NSDateFormatter in iOS 4+.
        // - see https://devforums.apple.com/thread/45837
        if (rfc3339String.length > 20)
        {
            rfc3339String = [rfc3339String stringByReplacingOccurrencesOfString:@":"
                                                                     withString:@""
                                                                        options:0
                                                                          range:NSMakeRange(20, rfc3339String.length-20)];
        }

        if (!date)
        {
            // 1996-12-19T16:39:57-0800
            [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"];
            date = [dateFormatter dateFromString:rfc3339String];
        }

        if (!date)
        {
            // 1937-01-01T12:00:27.87+0020
            [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZZZ"];
            date = [dateFormatter dateFromString:rfc3339String];
        }

        if (!date)
        {
            // 1937-01-01T12:00:27
            [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
            date = [dateFormatter dateFromString:rfc3339String];
        }

        if (!date)
            NSLog(@"Could not parse RFC3339 date: \"%@\" Possible invalid format.", dateString);
    }

    return date;
}


@end

