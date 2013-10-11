//
//  CLLocation+Bearing.m
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

//  Source:
//  http://stackoverflow.com/questions/5092845/point-to-location-using-compass

#import "CLLocation+Bearing.h"
#import "CLDegreesAndRadians.h"

@implementation CLLocation (Bearing)

- (CLLocationDirection) constantBearingForLocation:(CLLocation*)location
{
    // Source: Rhumb lines / loxodrome
    // http://www.movable-type.co.uk/scripts/latlong.html
    
    //double R = 6371; // km
    
    double lat1 = DEG_TO_RAD(self.coordinate.latitude);
    double lon1 = DEG_TO_RAD(self.coordinate.longitude);
    
    double lat2 = DEG_TO_RAD(location.coordinate.latitude);
    double lon2 = DEG_TO_RAD(location.coordinate.longitude);
    
    //double dLat = (lat2-lat1);
    double dLon = (lon2-lon1);
        
    double dPhi = log( tan( lat2/2 + M_PI_4) / tan( lat1/2 + M_PI_4));
    //double q = ( !isnan( dLat/dPhi) ) ? dLat/dPhi : cos(lat1);  // E-W line gives dPhi=0

    // if dLon over 180° take shorter rhumb across 180° meridian:
    if (abs(dLon) > M_PI) {
        dLon = dLon > 0 ? -(2*M_PI-dLon) : (2*M_PI+dLon);
    }

    //double d = sqrt( dLat*dLat + q*q*dLon*dLon) * R;
    double brng = atan2(dLon, dPhi);
    
    if(brng < 0.0) {
        brng += 2*M_PI;
    }
    
    return RAD_TO_DEG(brng);
}

- (CLLocationDirection) bearingForLocation:(CLLocation*)location
{
    // Source: haversine
    // http://stackoverflow.com/questions/3925942/cllocation-category-for-calculating-bearing-w-haversine-function
    
    double lat1 = DEG_TO_RAD(self.coordinate.latitude);
    double lon1 = DEG_TO_RAD(self.coordinate.longitude);

    double lat2 = DEG_TO_RAD(location.coordinate.latitude);
    double lon2 = DEG_TO_RAD(location.coordinate.longitude);

    double dLon = lon2 - lon1;

    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    double radiansBearing = atan2(y, x);
    
    if(radiansBearing < 0.0) {
        radiansBearing += 2*M_PI;
    }
    
    return RAD_TO_DEG(radiansBearing);
}

@end
