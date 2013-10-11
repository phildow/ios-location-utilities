//
//  CLLocation+Degrees.m
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

//  Source
//  http://stackoverflow.com/questions/8851816/convert-decimal-coordinate-into-degrees-minutes-seconds-direction

#import "CLLocation+Degrees.h"

@implementation CLLocation (Degrees)


-(NSString *)positionFormattedInDegrees
{
    double latitude = self.coordinate.latitude;
    double longitude = self.coordinate.longitude;

    int latSeconds = (int)round(abs(latitude * 3600));
    int latDegrees = latSeconds / 3600;
    latSeconds = latSeconds % 3600;
    int latMinutes = latSeconds / 60;
    latSeconds %= 60;

    int longSeconds = (int)round(abs(longitude * 3600));
    int longDegrees = longSeconds / 3600;
    longSeconds = longSeconds % 3600;
    int longMinutes = longSeconds / 60;
    longSeconds %= 60;

    char latDirection = (latitude >= 0) ? 'N' : 'S';
    char longDirection = (longitude >= 0) ? 'E' : 'W';

    return [NSString stringWithFormat:@"%iº %i' %i\" %c, %iº %i' %i\" %c", latDegrees, latMinutes, latSeconds, latDirection, longDegrees, longMinutes, longSeconds, longDirection];
}

@end
