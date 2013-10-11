//
//  CLLocation+DecimalDegreesConversion.h
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

http://www.geomidpoint.com/latlon.html
Latitudes range from 0 to 90.
Longitudes range from 0 to 180.
Use N, S, E or W as either the first or last character
The last degree, minute, or second of a latitude or longitude may contain a decimal portion.

    40:26:46N,79:56:55W
    
    40:26:46.302N 79:56:55.903W
    
    40°26′47″N 79°58′36″W
    
    40d 26′ 47″ N 79d 58′ 36″ W
    
    40.446195N 79.948862W
    
    40.446195, -79.948862
    
    40° 26.7717, -79° 56.93172
*/

#import <CoreLocation/CoreLocation.h>

typedef struct {
    CLLocationDegrees degrees;
    CLLocationDegrees minutes;
    CLLocationDegrees seconds;
    NSInteger direction;        // 1 = N,E, -1 = S,W
} LLAngularLocationCoordinate;

typedef struct {
    LLAngularLocationCoordinate latitude;
    LLAngularLocationCoordinate longitude;
} LLAngularLocationCoordinate2D;

#define LLUnkownAngularCoordinate() ({ \
    LLAngularLocationCoordinate c; \
    c.degrees = NSNotFound; \
    c.minutes = NSNotFound; \
    c.seconds = NSNotFound; \
    c.direction = 0; \
    c; \
})

#define LLAngularCoordinatesEqual(x,y) \
    (   x.degrees == y.degrees \
    &&  x.minutes == y.minutes \
    &&  x.seconds == y.seconds )
    

@interface CLLocation (DecimalDegreesConversion)

// this should really be the only method you need

+ (BOOL) isValidGeoocordinate:(NSString*)string;
+ (CLLocationDegrees) coordinateForString:(NSString*)string;

#pragma mark -

+ (LLAngularLocationCoordinate) angularCoordinatesForString:(NSString*)string;
+ (CLLocationDegrees) decimalCoordinateForString:(NSString*)string;

+ (CLLocationDegrees) decimalCoordinateForMinDecimalString:(NSString*)string;
+ (CLLocationDegrees) decimalCoordinateForDegrees:(LLAngularLocationCoordinate)degress;
+ (CLLocationCoordinate2D) coordinatesForAngularCoordinates:(LLAngularLocationCoordinate2D)angularCoordinates;

@end
