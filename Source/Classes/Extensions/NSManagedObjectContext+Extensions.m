//
//  NSManagedObjectContext+Extensions.m
//  GitHubNotificationCenter
//
//  Created by Lars Schneider on 11/7/11.
//  Copyright (c) 2011 6Wunderkinder. All rights reserved.
//

#import "NSManagedObjectContext+Extensions.h"


@implementation NSManagedObjectContext (Extensions)


- (void)saveChanges
{
    if ([self hasChanges])
    {
        NSError *error = nil;
        if (![self save:&error])
        {
            NSString *firstErrorString;
            NSMutableDictionary *errorDict = [[NSMutableDictionary alloc] init];
            NSUInteger i = 1000;

            // Formatted error output.
            // c.f. http://stackoverflow.com/questions/1283960/iphone-core-data-unresolved-error-while-saving/
            if ([[error domain] isEqualToString:@"NSCocoaErrorDomain"])
            {
                // ...check whether there's an NSDetailedErrors array
                NSDictionary *userInfo = [error userInfo];
                if ([userInfo valueForKey:NSDetailedErrorsKey] != nil)
                {
                    // ...and loop through the array, if so.
                    NSArray *errors = [userInfo valueForKey:NSDetailedErrorsKey];
                    for (NSError *anError in errors)
                    {
                        NSDictionary *subUserInfo = [anError userInfo];
                        subUserInfo = [anError userInfo];
                        // Granted, this indents the NSValidation keys rather a lot
                        // ...but it's a small loss to keep the code more readable.
                        NSLog(@"Core Data Save Error\n\n"
                               "NSValidationErrorKey\n%@\n\n"
                               "NSValidationErrorPredicate\n%@\n\n"
                               "NSValidationErrorObject\n%@\n\n"
                               "NSLocalizedDescription\n%@",
                             [subUserInfo valueForKey:@"NSValidationErrorKey"],
                             [subUserInfo valueForKey:@"NSValidationErrorPredicate"],
                             [subUserInfo valueForKey:@"NSValidationErrorObject"],
                             [subUserInfo valueForKey:@"NSLocalizedDescription"]);

                        [errorDict setValue:[subUserInfo valueForKey:@"NSValidationErrorKey"]
                                     forKey:[NSString stringWithFormat:@"Error #%i validation", i]];
                        [errorDict setValue:[subUserInfo valueForKey:@"NSValidationErrorPredicate"]
                                     forKey:[NSString stringWithFormat:@"Error #%i predicate", i]];
                        [errorDict setValue:[[subUserInfo valueForKey:@"NSValidationErrorObject"] description]
                                     forKey:[NSString stringWithFormat:@"Error #%i object", i]];
                        [errorDict setValue:[subUserInfo valueForKey:@"NSLocalizedDescription"]
                                     forKey:[NSString stringWithFormat:@"Error #%i description", i]];
                        i++;

                        if (firstErrorString == nil) firstErrorString = [NSString stringWithFormat:@"invalid %@", [subUserInfo valueForKey:@"NSValidationErrorKey"]];
                    }
                }
                // If there was no NSDetailedErrors array, print values directly
                // from the top-level userInfo object. (Hint: all of these keys
                // will have null values when you've got multiple errors sitting
                // behind the NSDetailedErrors key.
                else {
                    NSLog(@"Core Data Save Error\n\n"
                           "NSValidationErrorKey\n%@\n\n"
                           "NSValidationErrorPredicate\n%@\n\n"
                           "NSValidationErrorObject\n%@\n\n"
                           "NSLocalizedDescription\n%@",
                         [userInfo valueForKey:@"NSValidationErrorKey"],
                         [userInfo valueForKey:@"NSValidationErrorPredicate"],
                         [userInfo valueForKey:@"NSValidationErrorObject"],
                         [userInfo valueForKey:@"NSLocalizedDescription"]);

                    [errorDict setValue:[userInfo valueForKey:@"NSValidationErrorKey"]
                                 forKey:@"Error validation"];
                    [errorDict setValue:[userInfo valueForKey:@"NSValidationErrorPredicate"]
                                 forKey:@"Error  predicate"];
                    [errorDict setValue:[[userInfo valueForKey:@"NSValidationErrorObject"] description]
                                 forKey:@"Error %i object"];
                    [errorDict setValue:[userInfo valueForKey:@"NSLocalizedDescription"]
                                 forKey:@"Error %i description"];

                    firstErrorString = [NSString stringWithFormat:@"invalid %@", [userInfo valueForKey:@"NSValidationErrorKey"]];

                }
            }
            // Handle mine--or 3rd party-generated--errors
            else
            {
                NSLog(@"Custom Error: %@", [error localizedDescription]);
                firstErrorString = [error localizedDescription];
            }
        }
    }
}


- (void)discardChanges
{
    if ([self hasChanges]) [self rollback];
}


@end
