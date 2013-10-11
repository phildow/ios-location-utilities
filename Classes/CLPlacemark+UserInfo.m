//
//  CLPlacemark+UserInfo.m
//  Loqation
//
/*
Copyright (c) 2012 Philip Dow

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

#import "CLPlacemark+UserInfo.h"
#import <objc/runtime.h>

static char kLLNameKey;
static char kLLTimestampKey;

@implementation CLPlacemark (UserInfo)

@dynamic customTimestamp;
@dynamic customName;

- (NSDictionary*)customUserInfo
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    if ( self.customName ) {
        [userInfo setObject:self.customName forKey:@"customName"];
    }
    if ( self.customTimestamp ) {
        [userInfo setObject:self.customTimestamp forKey:@"customTimestamp"];
    }
    return userInfo;
}

- (void)setCustomTimestamp:(NSDate *)customTimestamp
{
    objc_setAssociatedObject(self, &kLLTimestampKey, customTimestamp, OBJC_ASSOCIATION_COPY);
}

- (NSDate*) customTimestamp
{
    return (NSDate*)objc_getAssociatedObject(self, &kLLTimestampKey);
}

- (void)setCustomName:(NSString *)name
{
	objc_setAssociatedObject(self, &kLLNameKey, name, OBJC_ASSOCIATION_COPY);
}

- (NSString*)customName
{
	return (NSString*)objc_getAssociatedObject(self, &kLLNameKey);
}


@end
