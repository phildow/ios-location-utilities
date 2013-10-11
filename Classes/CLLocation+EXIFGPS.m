//
//  CLLocation+EXIFGPS.m
//  Field Photo
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

#import "CLLocation+EXIFGPS.h"

NSString * const ISODateFormat = @"yyyy-MM-dd";
NSString * const ISOTimeFormat = @"HH:mm:ss.SSSSSS";

@implementation CLLocation (EXIFGPS)

- (NSDictionary*) EXIFMetadataWithHeading:(CLHeading*)heading
{
  NSMutableDictionary *GPSMetadata = [NSMutableDictionary dictionary];
  
  NSNumber *altitudeRef = [NSNumber numberWithInteger: self.altitude < 0.0 ? 1 : 0];
  NSString *latitudeRef = self.coordinate.latitude < 0.0 ? @"S" : @"N";
  NSString *longitudeRef = self.coordinate.longitude < 0.0 ? @"W" : @"E";
  NSString *headingRef = @"T"; // T: true direction, M: magnetic
  
  // GPS metadata
  
  [GPSMetadata setValue:[NSNumber numberWithDouble:ABS(self.coordinate.latitude)] forKey:(NSString*)kCGImagePropertyGPSLatitude];
  [GPSMetadata setValue:[NSNumber numberWithDouble:ABS(self.coordinate.longitude)] forKey:(NSString*)kCGImagePropertyGPSLongitude];
  
  [GPSMetadata setValue:latitudeRef forKey:(NSString*)kCGImagePropertyGPSLatitudeRef];
  [GPSMetadata setValue:longitudeRef forKey:(NSString*)kCGImagePropertyGPSLongitudeRef];
  
  [GPSMetadata setValue:[NSNumber numberWithDouble:ABS(self.altitude)] forKey:(NSString*)kCGImagePropertyGPSAltitude];
  [GPSMetadata setValue:altitudeRef forKey:(NSString*)kCGImagePropertyGPSAltitudeRef];
  
  [GPSMetadata setValue:[self.timestamp ISOTime] forKey:(NSString*)kCGImagePropertyGPSTimeStamp];
  [GPSMetadata setValue:[self.timestamp ISODate] forKey:(NSString*)kCGImagePropertyGPSDateStamp];
  
  if (heading) {
    [GPSMetadata setValue:[NSNumber numberWithDouble:heading.trueHeading] forKey:(NSString*)kCGImagePropertyGPSImgDirection];
    [GPSMetadata setValue:headingRef forKey:(NSString*)kCGImagePropertyGPSImgDirectionRef];
  }
  
  return [GPSMetadata copy];
}

@end

#pragma mark -

@implementation NSDate (EXIFGPS)

- (NSString*) ISODate
{
  NSDateFormatter *f = [[NSDateFormatter alloc] init];
  [f setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
  [f setDateFormat:ISODateFormat];
  return [f stringFromDate:self];
}

- (NSString*) ISOTime
{
  NSDateFormatter *f = [[NSDateFormatter alloc] init];
  [f setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
  [f setDateFormat:ISOTimeFormat];
  return [f stringFromDate:self];
}

@end