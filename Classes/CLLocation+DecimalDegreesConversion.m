//
//  CLLocation+DecimalDegreesConversion.m
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

/*
All of the following are valid and acceptable ways to write geographic coordinates:
Coordinates on Wikipedia are generally written as 40°26′21″N 79°58′36″W.
Escape all backslashes and double quotes

Allowed geocoordinate characters:

[^NEWS\s\d:º°d\.'"\-]+
[^NEWS\\s\\d:º°d\\.'\"\\-]+

^(N|S|E|W)?\s?(\d+)(d|:|°|º)?\s?(\d+)(:|')?\s?(\d+\.?\d+)'{2}?"?\s?(N|S|E|W)?$ /i
^(N|S|E|W)?\\s?(\\d+)(d|:|°|º|\s)?\\s?(\\d+)(:|'|\s)?\\s?(\\d+\.?\\d+)'{2}?\"?\\s?(N|S|E|W)?$

    40:26:46N,79:56:55W
    
    40:26:46.302N 79:56:55.903W
    
    40°26'47"N 79°58'36"W
    
    40d 26' 47" N 79d 58' 36" W

^(N|S|E|W)?\s?(\d+)(d|:|°|º)?\s?(\d+\.?\d+)'{2}?"?\s?(N|S|E|W)?$ /i
^(N|S|E|W)?\\s?(-?\\d+)(d|:|°|º)?\\s?(\\d+\\.?\\d+)'{2}?"?\\s?(N|S|E|W)?$

    40° 26.7717, -79° 56.93172

^(-?\d+.?\d+)\s?(N|S|E|W|°|º)?$ /i
^(-?\\d+.?\\d+)\\s?(N|S|E|W|°|º)?$
    
    40.446195N 79.948862W
    
    40.446195, -79.948862
*/

#import "CLLocation+DecimalDegreesConversion.h"

@interface NSString (Cardinal)

- (BOOL) isCompassCardinal;

@end

#pragma mark -

@implementation CLLocation (DecimalDegreesConversion)

static NSString * const kAllowedCharacters = @"[^NEWS\\s\\d:º°d\\.'\"\\-]+";

// 1. simple decimal: 79.948862W
static NSString * const kDecimalExpression = @"^(-?\\d+\\.?\\d+)\\s?(N|S|E|W|°|º)?$"; // 2

// 2. mindec: 0° 26.7717
static NSString * const kMinDecimalExpression = @"^(N|S|E|W)?\\s?(-?\\d+)(d|:|°|º)?\\s?(\\d+\\.?\\d+)\"?\\s?(N|S|E|W)?$"; // 3

// 3. angular: 40:26:46N,79:56:55W
static NSString * const kDegreeExpression = @"^(N|S|E|W)?\\s?(\\d+)(d|:|°|º|\\s)?\\s?(\\d+)(:|'|\\s)?\\s?(\\d+\\.?\\d+)\"?\\s?(N|S|E|W)?$";

+ (BOOL) isValidGeoocordinate:(NSString*)string
{
    NSRange stringRange = NSMakeRange(0, [string length]);
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kAllowedCharacters options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:string options:0 range:stringRange];
    
    return ( [match numberOfRanges] == 0 );
}

+ (CLLocationDegrees) coordinateForString:(NSString*)string
{
    CLLocationDegrees coordinate = NSNotFound;
    
    // 1. simple decimal: 79.948862W
    coordinate = [CLLocation decimalCoordinateForString:string];
    if ( coordinate != NSNotFound ) return coordinate;
            
    // 2. mindec: 0° 26.7717
    coordinate = [CLLocation decimalCoordinateForMinDecimalString:string];
    if ( coordinate != NSNotFound ) return coordinate;

    // 3. angular: 40:26:46N,79:56:55W
    LLAngularLocationCoordinate angular = [CLLocation angularCoordinatesForString:string];
    if ( !LLAngularCoordinatesEqual(angular, LLUnkownAngularCoordinate()) ) {
        coordinate = [CLLocation decimalCoordinateForDegrees:angular];
        return coordinate;
    }
    
    // failure
    return coordinate;
}

+ (CLLocationDegrees) decimalCoordinateForMinDecimalString:(NSString*)string
{
    /*  79°56.93172W
        The integer number of degrees is the same (79)
        The decimal degrees is the decimal minutes divided by 60 (56.93172/60 = 0.948862)
        Add the two together (79 + 0.948862 = 79.948862)
        Negate the value if it is South or West (in this case, West, so -79.948862)
        */
        
    CLLocationDegrees coordinate = NSNotFound;
    
    NSRange stringRange = NSMakeRange(0, [string length]);
    string = [string uppercaseString];
        
    @try {
        
        // if the regular expression does not match, try decimal notation
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kMinDecimalExpression options:NSRegularExpressionCaseInsensitive error:nil];
        NSTextCheckingResult *match = [regex firstMatchInString:string options:0 range:stringRange];
        
        if ( !match || !NSEqualRanges([match range],stringRange) ) {
            // genuine error / no matches for degree or decimal notation
            return coordinate;
        }
        
        if ( ![match numberOfRanges] == 6 ) {
            // did not get the correct number of groupings
            return coordinate;
        }
        
        NSMutableArray *groups = [NSMutableArray array];
        for ( NSUInteger i = 0; i < [match numberOfRanges]; i++ ) {
            NSRange range = [match rangeAtIndex:i];
            if ( range.location == NSNotFound ) {
                [groups addObject:@""]; // keep empty placeholder
            } else { 
                [groups addObject:[string substringWithRange:range]];
            }
        }
        
        NSString *direction = nil;
        
        // some expressions may begin ith N|E|W|S
        if ( [[groups objectAtIndex:1] isCompassCardinal] ) {
            direction = [groups objectAtIndex:1];
        } else if ( [[groups objectAtIndex:5] isCompassCardinal] ) {
            direction = [groups objectAtIndex:5];
        }

        CLLocationDegrees degrees = [[groups objectAtIndex:2] doubleValue];
        CLLocationDegrees minutes = [[groups objectAtIndex:4] doubleValue] / 60.f;
        
        if ( degrees < 0 ) coordinate = degrees - minutes;
        else coordinate = degrees + minutes;
        
        if ( [direction isEqualToString:@"S"] || [direction isEqualToString:@"W"] ) 
                coordinate *= -1;
        
    } @catch (NSException *exception) {
        NSLog(@"Caught exception trying to convert mindecimal string to geocoordinates: %@", exception);
    } @finally {
        return coordinate;
    }
}

+ (CLLocationDegrees) decimalCoordinateForString:(NSString*)string
{
    CLLocationDegrees coordinate = NSNotFound;
    
    NSRange stringRange = NSMakeRange(0, [string length]);
    string = [string uppercaseString];
    
    @try {
        // if the regular expression does not match, try decimal notation
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kDecimalExpression options:NSRegularExpressionCaseInsensitive error:nil];
        NSTextCheckingResult *match = [regex firstMatchInString:string options:0 range:stringRange];
        
        if ( !match || !NSEqualRanges([match range],stringRange) ) {
            // genuine error / no matches for degree or decimal notation
            return coordinate;
        }
        
        if ( ![match numberOfRanges] == 3 ) {
            // did not receive expected number of groups
            return coordinate;
        }
        
        NSMutableArray *groups = [NSMutableArray array];
        for ( NSUInteger i = 0; i < [match numberOfRanges]; i++ ) {
            NSRange range = [match rangeAtIndex:i];
            if ( range.location == NSNotFound ) {
                [groups addObject:@""]; // keep empty placeholder
            } else { 
                [groups addObject:[string substringWithRange:range]];
            }
        }
        
        coordinate = [[groups objectAtIndex:1] doubleValue];
        
        NSString *direction = [groups objectAtIndex:2];
        if ( [direction isEqualToString:@"S"] || [direction isEqualToString:@"W"] ) 
            coordinate *= -1;
    
    } @catch (NSException *exception) {
        NSLog(@"Caught exception trying to convert decimal string to geocoordinates: %@", exception);
    } @finally {
        return coordinate;
    }
}

+ (LLAngularLocationCoordinate) angularCoordinatesForString:(NSString*)string
{
    LLAngularLocationCoordinate coordinate = LLUnkownAngularCoordinate();
    
    NSRange stringRange = NSMakeRange(0, [string length]);
    string = [string uppercaseString];
    
    // the regular expression should have exactly one match and it should match
    // the entire string
    
    // for some regular expressions (though not the example pattern) some capture groups may or may not participate in a given match. If a given capture group does not participate in a given match, then [result rangeAtIndex:idx] will return {NSNotFound, 0}.
    
    @try {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kDegreeExpression options:NSRegularExpressionCaseInsensitive error:nil];
        NSTextCheckingResult *match = [regex firstMatchInString:string options:0 range:stringRange];
        
        if ( !match || !NSEqualRanges([match range],stringRange) ) {
            // genuine error / no matches for degree or decimal notation
            return coordinate;
        }
        
        if ( ![match numberOfRanges] == 8 ) {
            // did not receive expected number of groups
            return coordinate;
        }
        
        NSMutableArray *groups = [NSMutableArray array];
        for ( NSUInteger i = 0; i < [match numberOfRanges]; i++ ) {
            NSRange range = [match rangeAtIndex:i];
            if ( range.location == NSNotFound ) {
                [groups addObject:@""]; // keep empty placeholder
            } else { 
                [groups addObject:[string substringWithRange:range]];
            }
        }
        
        // ignore the first match, it's the whole group
        
        NSString *direction = nil;
        
        // some expressions may begin ith N|E|W|S
        if ( [[groups objectAtIndex:1] isCompassCardinal] ) {
            direction = [groups objectAtIndex:1];
        } else if ( [[groups objectAtIndex:7] isCompassCardinal] ) {
            direction = [groups objectAtIndex:7];
        } else {
            // bad string. we must have cardinal for angular coordinates
            return coordinate;
        }
        
        coordinate.degrees = [[groups objectAtIndex:2] doubleValue];
        coordinate.minutes = [[groups objectAtIndex:4] doubleValue];
        coordinate.seconds = [[groups objectAtIndex:6] doubleValue];
        
        if ( [direction isEqualToString:@"N"] || [direction isEqualToString:@"E"] ) 
            coordinate.direction = 1;
        else if ( [direction isEqualToString:@"S"] || [direction isEqualToString:@"W"] ) 
            coordinate.direction = -1;
        
    } @catch (NSException *exception) {
        NSLog(@"Caught exception trying to convert angular string to geocoordinates: %@", exception);
    } @finally {
        return coordinate;
    }
}

+ (CLLocationDegrees) decimalCoordinateForDegrees:(LLAngularLocationCoordinate)degrees
{
    CLLocationDegrees coordinate = NSNotFound;
    
    // degrees + ( ( minutes * 60 + seconds ) / 3600 )
    // invert west and south values
    
    coordinate = degrees.degrees + ( ( degrees.minutes * 60 + degrees.seconds ) / 3600 );
    coordinate *= degrees.direction;
    return coordinate;
}

+ (CLLocationCoordinate2D) coordinatesForAngularCoordinates:(LLAngularLocationCoordinate2D)angularCoordinates
{
    CLLocationCoordinate2D coordinates;
    coordinates.latitude = [CLLocation decimalCoordinateForDegrees:angularCoordinates.latitude];
    coordinates.longitude = [CLLocation decimalCoordinateForDegrees:angularCoordinates.longitude];
    return coordinates;
}

@end

#pragma mark -

@implementation NSString (Cardinal)

- (BOOL) isCompassCardinal
{
    if ( [self length] != 1)
        return NO;
    
    return ( [[self uppercaseString] isEqualToString:@"N"]
        || [[self uppercaseString] isEqualToString:@"S"]
        || [[self uppercaseString] isEqualToString:@"E"]
        || [[self uppercaseString] isEqualToString:@"W"] );
}

@end