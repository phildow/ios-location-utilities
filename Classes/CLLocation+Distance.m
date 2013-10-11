//
//  CLLocation+Distance.m
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

#import "CLLocation+Distance.h"

// Abbreviations
// Kilometers = km
// Meters = m
// Miles = mi.
// Yards = yd.

@implementation CLLocation (Distance)

- (NSString*) distanceFromLocation:(CLLocation*)location format:(NSString*)format options:(NSUInteger)options
{
    // we're always given meters to work with
    // if metric, round off to kilometers if have more than one kilometer
    // if english, use yards if we're less than a mile
    
    BOOL miles = ( (options & LLDistanceFormatMiles) == LLDistanceFormatMiles );
    BOOL abbr = ( (options & LLDistanceFormatAbbreviated) == LLDistanceFormatAbbreviated );
    
    CLLocationDistance distance = [self distanceFromLocation:location];
    NSString *modifier;
    
    if ( miles ) {
        if (miles) distance *= 0.000621371; // meters to miles
        if ( abbr ) { modifier = NSLocalizedString(@"mi.", @"Miles Abbr");
        } else { modifier = NSLocalizedString(@"Miles", @"Miles");
        }
        
        if ( distance < 1 ) {
            // reduce it to yards
            if ( abbr ) { modifier = NSLocalizedString(@"yd.", @"Yards Abbr");
            } else { modifier = NSLocalizedString(@"Yards", @"Yards");
            }
            
            CLLocationDistance yards = distance * 1760;
            return [NSString stringWithFormat:@"%.0f %@", yards, modifier];
            
        } else {
            // miles
            return [NSString stringWithFormat:@"%.1f %@", distance, modifier];
        }
        
    } else {
        if ( abbr ) { modifier = NSLocalizedString(@"m", @"Meters Abbr");
        } else { modifier = NSLocalizedString(@"Meters", @"Meters");
        }
        
        if ( distance > 1000 ) {
            if ( abbr) { modifier = NSLocalizedString(@"km", @"Kilometers Abbr");
            } else { modifier = NSLocalizedString(@"Kilometers", @"Kilometers");
            }
            
            // round it off to kilometers
            NSInteger hundreds = (NSInteger)distance % 1000;
            hundreds = hundreds - hundreds % 100;
            NSInteger point = hundreds / 100;
            distance = distance - (NSInteger)distance % 1000;
            distance /= 1000;
            
            return [NSString stringWithFormat:@"%.0f.%d %@", distance, point, modifier];
        } else {
            // meteres
            return [NSString stringWithFormat:@"%.0f %@", distance, modifier];
        }
    }
}

- (NSString*) distanceFromLocation:(CLLocation*)location format:(NSString*)format
{
    CLLocationDistance distance = [self distanceFromLocation:location];
    NSString *modifier = NSLocalizedString(@"Meters", @"Meters");
    
    if ( distance > 1000 ) {
        // round it off
        NSInteger hundreds = (NSInteger)distance % 1000;
        hundreds = hundreds - hundreds % 100;
        NSInteger point = hundreds / 100;
        distance = distance - (NSInteger)distance % 1000;
        distance /= 1000;
        modifier = NSLocalizedString(@"Kilometers", @"Kilometers");
        
        return [NSString stringWithFormat:@"%.0f.%d %@", distance, point, modifier];
    }
    
    return [NSString stringWithFormat:@"%.0f %@", distance, modifier];
}

@end
