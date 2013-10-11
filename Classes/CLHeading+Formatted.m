//
//  CLHeading+Formatted.m
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

#import "CLHeading+Formatted.h"

@implementation CLHeading (Formatted)

+ (NSString*) cardinalForHeading:(CLLocationDirection)theHeading
{
    NSString *modifier = [NSString string];
    if ( theHeading >= 0 && theHeading <= 22 )
        modifier = NSLocalizedString(@"North", @"North");
    else if ( theHeading > 22 && theHeading < 68 )
        modifier = NSLocalizedString(@"Northeast", @"Northeast");
    else if ( theHeading >= 68 && theHeading <= 112 )
        modifier = NSLocalizedString(@"East", @"East");
    else if ( theHeading > 112 && theHeading < 158 )
        modifier = NSLocalizedString(@"Southeast", @"Southeast");
    else if ( theHeading >= 158 && theHeading <= 202 )
        modifier = NSLocalizedString(@"South", @"South");
    else if ( theHeading > 202 && theHeading < 248 )
        modifier = NSLocalizedString(@"Southwest", @"Southwest");
    else if ( theHeading >= 248 && theHeading <= 292 )
        modifier = NSLocalizedString(@"West", @"West");
    else if ( theHeading > 292 && theHeading < 238 )
        modifier = NSLocalizedString(@"Northwest", @"Northwest");
    else
        modifier = NSLocalizedString(@"North", @"North");
        
    return modifier;
}

+ (NSString*) cardinalAbbreviationForHeading:(CLLocationDirection)theHeading
{
    NSString *modifier = [NSString string];
    if ( theHeading >= 0 && theHeading <= 22 )
        modifier = NSLocalizedString(@"N", @"North");
    else if ( theHeading > 22 && theHeading < 68 )
        modifier = NSLocalizedString(@"NE", @"Northeast");
    else if ( theHeading >= 68 && theHeading <= 112 )
        modifier = NSLocalizedString(@"E", @"East");
    else if ( theHeading > 112 && theHeading < 158 )
        modifier = NSLocalizedString(@"SE", @"Southeast");
    else if ( theHeading >= 158 && theHeading <= 202 )
        modifier = NSLocalizedString(@"S", @"South");
    else if ( theHeading > 202 && theHeading < 248 )
        modifier = NSLocalizedString(@"SW", @"Southwest");
    else if ( theHeading >= 248 && theHeading <= 292 )
        modifier = NSLocalizedString(@"W", @"West");
    else if ( theHeading > 292 && theHeading < 238 )
        modifier = NSLocalizedString(@"NW", @"Northwest");
    else
        modifier = NSLocalizedString(@"N", @"North");
        
    return modifier;
}

+ (NSString*) formattedStringForHeading:(CLLocationDirection)theHeading format:(NSString*)format abbreviate:(BOOL)abbreviate
{
    NSString *modifier = ( abbreviate ? [CLHeading cardinalAbbreviationForHeading:theHeading]
        : [CLHeading cardinalForHeading:theHeading] );
    
    if ( format ) {
        NSString *numeric = [NSString stringWithFormat:format, theHeading];
        NSString *heading = [NSString stringWithFormat:@"%@º %@", numeric, modifier];
        return heading;
    } else {
        NSString *heading = [NSString stringWithFormat:@"%.0fº %@", theHeading, modifier];
        return heading;
    }
}

- (NSString*) formattedHeading:(BOOL)trueHeading
{
    CLLocationDirection theHeading = ((trueHeading && self.trueHeading > 0) ?
            self.trueHeading : self.magneticHeading);
    
    return [CLHeading formattedStringForHeading:theHeading format:nil abbreviate:YES];
}

@end
