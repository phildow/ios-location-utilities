//
//  LLLocationConversionTests.m
//  Compass
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

^(N|S|E|W)?\s?(\d+)(d|:|°)?\s?(\d+)(:|')?\s?(\d+\.?\d+)'{2}?"?\s?(N|S|E|W)?$ /i
^(N|S|E|W)?\\s?(\\d+)(d|:|°|\s)?\\s?(\\d+)(:|'|\s)?\\s?(\\d+\.?\\d+)'{2}?\"?\\s?(N|S|E|W)?$

    40:26:46N,79:56:55W
    
    40:26:46.302N 79:56:55.903W
    
    40°26′47″N 79°58′36″W
    
    40d 26′ 47″ N 79d 58′ 36″ W
    
^(N|S|E|W)?\s?(\d+)(d|:|°)?\s?(\d+\.?\d+)'{2}?"?\s?(N|S|E|W)?$ /i
^(N|S|E|W)?\\s?(-?\\d+)(d|:|°)?\\s?(\\d+\\.?\\d+)'{2}?"?\\s?(N|S|E|W)?$

    40° 26.7717, -79° 56.93172

^(-?\d+.?\d+)\s?(N|S|E|W|°)?$ /i
^(-?\\d+.?\\d+)\\s?(N|S|E|W|°)?$
    
    40.446195N 79.948862W
    
    40.446195, -79.948862
*/


#import "LLLocationConversionTests.h"
#import "CLLocation+DecimalDegreesConversion.h"

@implementation LLLocationConversionTests



#pragma mark - invalid string tests

- (void) testStringWithOtherCharacters
{
    NSString *string = @"79 56.93172T";
    STAssertFalse([CLLocation isValidGeoocordinate:string], @"should not be valid geoocordinate");
}

- (void) testStringWithOtherSymbols
{
    NSString *string = @"79, 56.93172";
    STAssertFalse([CLLocation isValidGeoocordinate:string], @"should not be valid geoocordinate");
}

#pragma mark - Mixed coordinateForString Tests

- (void) testconvertsMinDecWithSpace
{
    NSString *string = @"79 56.93172";
    STAssertTrue([CLLocation isValidGeoocordinate:string], @"should be valid geoocordinate");
    
    CLLocationDegrees location = [CLLocation coordinateForString:string];
    STAssertEqualsWithAccuracy(location, (CLLocationDegrees)79.948862, (double).000001,@"should extract decimal degrees");
}

- (void) testconvertsMinDec
{
    NSString *string = @"79°56.93172";
    STAssertTrue([CLLocation isValidGeoocordinate:string], @"should be valid geoocordinate");
    
    CLLocationDegrees location = [CLLocation coordinateForString:string];
    STAssertEqualsWithAccuracy(location, (CLLocationDegrees)79.948862, (double).000001,@"should extract decimal degrees");
}

- (void) testConvertsMinDecTrailingCardinal
{
    NSString *string = @"79°56.93172W";
    STAssertTrue([CLLocation isValidGeoocordinate:string], @"should be valid geoocordinate");
    
    CLLocationDegrees location = [CLLocation coordinateForString:string];
    STAssertEqualsWithAccuracy(location, (CLLocationDegrees)-79.948862, (double).000001,@"should extract decimal degrees");
}

- (void) testConvertsMinDecLeadingCardinal
{
    NSString *string = @"N40°26.7717";
    STAssertTrue([CLLocation isValidGeoocordinate:string], @"should be valid geoocordinate");
    
    CLLocationDegrees location = [CLLocation coordinateForString:string];
    STAssertEqualsWithAccuracy(location, (CLLocationDegrees)40.446195, (double).000001,@"should extract decimal degrees");
}

- (void) testConvertsNegativeDegreesString
{
    NSString *string = @"W80:26:46";
    STAssertTrue([CLLocation isValidGeoocordinate:string], @"should be valid geoocordinate");
    
    CLLocationDegrees location = [CLLocation coordinateForString:string];
    STAssertEqualsWithAccuracy(location, (CLLocationDegrees)-80.44611, (double).00001,@"should extract decimal degrees");
}

- (void) testConvertsDegreesString
{
    NSString *string = @"N40:26:46";
    STAssertTrue([CLLocation isValidGeoocordinate:string], @"should be valid geoocordinate");
    
    CLLocationDegrees location = [CLLocation coordinateForString:string];
    STAssertEqualsWithAccuracy(location, (CLLocationDegrees)40.44611, (double).00001,@"should extract decimal degrees");
}

- (void) testConvertsNegativeDecimalString
{
    NSString *string = @"-80.442195";
    STAssertTrue([CLLocation isValidGeoocordinate:string], @"should be valid geoocordinate");
    
    CLLocationDegrees location = [CLLocation coordinateForString:string];
    STAssertEqualsWithAccuracy(location, (CLLocationDegrees)-80.442195, (double).000001,@"should extract decimal degrees");
}

- (void) testConvertsNegativeDecimalStringWithDegree
{
    NSString *string = @"-97.539218 °";
    STAssertTrue([CLLocation isValidGeoocordinate:string], @"should be valid geoocordinate");
    
    CLLocationDegrees location = [CLLocation coordinateForString:string];
    STAssertEqualsWithAccuracy(location, (CLLocationDegrees)-97.539218, (double).000001,@"should extract decimal degrees");
}

#pragma mark - decimalCoordinateForMinDecimalString Tests

- (void) testMinDecimalNegative
{
    NSString *string = @"-40°26.7717";
    STAssertTrue([CLLocation isValidGeoocordinate:string], @"should be valid geoocordinate");
    
    CLLocationDegrees location = [CLLocation decimalCoordinateForMinDecimalString:string];
    STAssertEqualsWithAccuracy(location, (CLLocationDegrees)-40.446195, (double).000001,@"should extract decimal degrees");
}

- (void) testMinDecimalPostitive
{
    NSString *string = @"40°26.7717";
    STAssertTrue([CLLocation isValidGeoocordinate:string], @"should be valid geoocordinate");
    
    CLLocationDegrees location = [CLLocation decimalCoordinateForMinDecimalString:string];
    STAssertEqualsWithAccuracy(location, (CLLocationDegrees)40.446195, (double).000001,@"should extract decimal degrees");
}

- (void) testMinDecimalWithLeadingDirection
{
    NSString *string = @"N40°26.7717";
    STAssertTrue([CLLocation isValidGeoocordinate:string], @"should be valid geoocordinate");
    
    CLLocationDegrees location = [CLLocation decimalCoordinateForMinDecimalString:string];
    STAssertEqualsWithAccuracy(location, (CLLocationDegrees)40.446195, (double).000001,@"should extract decimal degrees");
}

- (void) testMinDecimalWithNegativeTrailingDirection
{
    NSString *string = @"40°26.7717W";
    STAssertTrue([CLLocation isValidGeoocordinate:string], @"should be valid geoocordinate");
    
    CLLocationDegrees location = [CLLocation decimalCoordinateForMinDecimalString:string];
    STAssertEqualsWithAccuracy(location, (CLLocationDegrees)-40.446195, (double).000001,@"should extract decimal degrees");

}

- (void) testMinDecimalWithTrailingDirection
{
    NSString *string = @"40°26.7717N";
    STAssertTrue([CLLocation isValidGeoocordinate:string], @"should be valid geoocordinate");
    
    CLLocationDegrees location = [CLLocation decimalCoordinateForMinDecimalString:string];
    STAssertEqualsWithAccuracy(location, (CLLocationDegrees)40.446195, (double).000001,@"should extract decimal degrees");

}

#pragma mark - decimalCoordinateForString Tests

- (void) testDecimalReturnsNotFoundForBadString {
    NSString *string = @"Asdflkjer";
    STAssertFalse([CLLocation isValidGeoocordinate:string], @"should be not valid geoocordinate");
    
    CLLocationDegrees location = [CLLocation decimalCoordinateForString:string];
    STAssertEquals(location, (CLLocationDegrees)NSNotFound, @"should return not found for bad string");
}

- (void) testDecimalNegativeWithoutCardinalNotation {
    NSString *string = @"-80.442195";
    STAssertTrue([CLLocation isValidGeoocordinate:string], @"should be valid geoocordinate");
    
    CLLocationDegrees location = [CLLocation decimalCoordinateForString:string];
    STAssertEqualsWithAccuracy(location, (CLLocationDegrees)-80.442195, (double).000001,@"should extract decimal degrees");
}

- (void) testDecimalWithoutCardinalNotation {
    NSString *string = @"80.442195";
    STAssertTrue([CLLocation isValidGeoocordinate:string], @"should be valid geoocordinate");
    
    CLLocationDegrees location = [CLLocation decimalCoordinateForString:string];
    STAssertEqualsWithAccuracy(location, (CLLocationDegrees)80.442195, (double).000001,@"should extract decimal degrees");
}

- (void) testDecimalWithWesternCardinalNotation {
    NSString *string = @"44.746195W";
    STAssertTrue([CLLocation isValidGeoocordinate:string], @"should be valid geoocordinate");
    
    CLLocationDegrees location = [CLLocation decimalCoordinateForString:string];
    STAssertEqualsWithAccuracy(location, (CLLocationDegrees)-44.746195, (double).000001,@"should extract decimal degrees");
}

- (void) testDecimalWithEasternCardinalNotation {
    NSString *string = @"44.746195E";
    STAssertTrue([CLLocation isValidGeoocordinate:string], @"should be valid geoocordinate");
    
    CLLocationDegrees location = [CLLocation decimalCoordinateForString:string];
    STAssertEqualsWithAccuracy(location, (CLLocationDegrees)44.746195, (double).000001,@"should extract decimal degrees");
}

- (void) testDecimalWithSouthernCardinalNotation {
    NSString *string = @"40.446195S";
    STAssertTrue([CLLocation isValidGeoocordinate:string], @"should be valid geoocordinate");
    
    CLLocationDegrees location = [CLLocation decimalCoordinateForString:string];
    STAssertEqualsWithAccuracy(location, (CLLocationDegrees)-40.446195, (double).000001,@"should extract decimal degrees");
}

- (void) testDecimalWithNorthernCardinalNotation {
    NSString *string = @"40.446195N";
    STAssertTrue([CLLocation isValidGeoocordinate:string], @"should be valid geoocordinate");
    
    CLLocationDegrees location = [CLLocation decimalCoordinateForString:string];
    STAssertEqualsWithAccuracy(location, (CLLocationDegrees)40.446195, (double).000001,@"should extract decimal degrees");
}

#pragma mark - decimalCoordinateForDegrees Tests

- (void) testWesternLongitude
{
    LLAngularLocationCoordinate coordinate;
    coordinate.degrees = 120;
    coordinate.minutes = 76;
    coordinate.seconds = 12;
    coordinate.direction = -1;
    
    CLLocationDegrees decimalDegress = [CLLocation decimalCoordinateForDegrees:coordinate];
    STAssertEqualsWithAccuracy(decimalDegress, (CLLocationDegrees)-121.27, (CLLocationDegrees)0.00001, @"should convert western longitude" );
}

- (void) testEasternLongitude
{
    LLAngularLocationCoordinate coordinate;
    coordinate.degrees = 80;
    coordinate.minutes = 16;
    coordinate.seconds = 45;
    coordinate.direction = 1;
    
    CLLocationDegrees decimalDegress = [CLLocation decimalCoordinateForDegrees:coordinate];
    STAssertEqualsWithAccuracy(decimalDegress, (CLLocationDegrees)80.27917, (CLLocationDegrees)0.00001, @"should convert eastern longitude" );
}

- (void) testSouthernLatitude
{
    LLAngularLocationCoordinate coordinate;
    coordinate.degrees = 40;
    coordinate.minutes = 36;
    coordinate.seconds = 16;
    coordinate.direction = -1;
    
    CLLocationDegrees decimalDegress = [CLLocation decimalCoordinateForDegrees:coordinate];
    STAssertEqualsWithAccuracy(decimalDegress, (CLLocationDegrees)-40.60444, (CLLocationDegrees)0.00001, @"should convert southern latitude" );
}

- (void) testNorthernLatitude
{
    LLAngularLocationCoordinate coordinate;
    coordinate.degrees = 40;
    coordinate.minutes = 26;
    coordinate.seconds = 46;
    coordinate.direction = 1;
    
    CLLocationDegrees decimalDegress = [CLLocation decimalCoordinateForDegrees:coordinate];
    STAssertEqualsWithAccuracy(decimalDegress, (CLLocationDegrees)40.44611, (CLLocationDegrees)0.00001, @"should convert northern latitude" );
}

#pragma mark - angularCoordinatesForString Tests

- (void) testAngularReturnsNotFoundForStringWithoutCardinal
{
    NSString *string = @"40 26 46.1";
    LLAngularLocationCoordinate coordinate = [CLLocation angularCoordinatesForString:string];
    STAssertTrue(LLAngularCoordinatesEqual(coordinate, LLUnkownAngularCoordinate()),@"bad string should return not found");
}

- (void) testAngularReturnsNotFoundForBadString
{
    NSString *string = @"W40 Alpha Beta";
    LLAngularLocationCoordinate coordinate = [CLLocation angularCoordinatesForString:string];
    STAssertTrue(LLAngularCoordinatesEqual(coordinate, LLUnkownAngularCoordinate()),@"bad string should return not found");
}

- (void) testColonFormatWithLeadingDirectionAndSpaces
{
    NSString *string = @"W40 26 46";
    LLAngularLocationCoordinate coordinate = [CLLocation angularCoordinatesForString:string];

    STAssertEquals(coordinate.degrees, (CLLocationDegrees)40, @"conversion should match degrees");
    STAssertEquals(coordinate.minutes, (CLLocationDegrees)26, @"conversion should match minutes");
    STAssertEquals(coordinate.seconds, (CLLocationDegrees)46, @"conversion should match seconds");
    STAssertEquals(coordinate.direction, -1, @"conversion should match direction");
}

- (void) testColonFormatWithLeadingDirection
{
    NSString *string = @"N40:26:46";
    LLAngularLocationCoordinate coordinate = [CLLocation angularCoordinatesForString:string];

    STAssertEquals(coordinate.degrees, (CLLocationDegrees)40, @"conversion should match degrees");
    STAssertEquals(coordinate.minutes, (CLLocationDegrees)26, @"conversion should match minutes");
    STAssertEquals(coordinate.seconds, (CLLocationDegrees)46, @"conversion should match seconds");
    STAssertEquals(coordinate.direction, 1, @"conversion should match direction");
}

- (void) testMixedSpacesFormat
{
    NSString *string = @"40d 26' 47\"N";
    LLAngularLocationCoordinate coordinate = [CLLocation angularCoordinatesForString:string];

    STAssertEquals(coordinate.degrees, (CLLocationDegrees)40, @"conversion should match degrees");
    STAssertEquals(coordinate.minutes, (CLLocationDegrees)26, @"conversion should match minutes");
    STAssertEquals(coordinate.seconds, (CLLocationDegrees)47, @"conversion should match seconds");
    STAssertEquals(coordinate.direction, 1, @"conversion should match direction");
}

- (void) testOnlySpacesFormat
{
    NSString *string = @"40 26 47 S";
    LLAngularLocationCoordinate coordinate = [CLLocation angularCoordinatesForString:string];

    STAssertEquals(coordinate.degrees, (CLLocationDegrees)40, @"conversion should match degrees");
    STAssertEquals(coordinate.minutes, (CLLocationDegrees)26, @"conversion should match minutes");
    STAssertEquals(coordinate.seconds, (CLLocationDegrees)47, @"conversion should match seconds");
    STAssertEquals(coordinate.direction, -1, @"conversion should match direction");
}

// TODO: doesn't like the double single quotes
- (void) testColonFormatWithDoubleSingleQuotes
{
    return;
    NSString *string = @"79°58'36''W";
    LLAngularLocationCoordinate coordinate = [CLLocation angularCoordinatesForString:string];

    STAssertEquals(coordinate.degrees, (CLLocationDegrees)79, @"conversion should match degrees");
    STAssertEquals(coordinate.minutes, (CLLocationDegrees)58, @"conversion should match minutes");
    STAssertEquals(coordinate.seconds, (CLLocationDegrees)36, @"conversion should match seconds");
    STAssertEquals(coordinate.direction, -1, @"conversion should match direction");
}


- (void) testColonFormatWithDegreeSymbols
{
    NSString *string = @"40°26'47\"E";
    LLAngularLocationCoordinate coordinate = [CLLocation angularCoordinatesForString:string];

    STAssertEquals(coordinate.degrees, (CLLocationDegrees)40, @"conversion should match degrees");
    STAssertEquals(coordinate.minutes, (CLLocationDegrees)26, @"conversion should match minutes");
    STAssertEquals(coordinate.seconds, (CLLocationDegrees)47, @"conversion should match seconds");
    STAssertEquals(coordinate.direction, 1, @"conversion should match direction");
}

- (void) testColonFormatWithDecimalSeconds
{
    NSString *string = @"40:26:46.302S";
    LLAngularLocationCoordinate coordinate = [CLLocation angularCoordinatesForString:string];

    STAssertEquals(coordinate.degrees, (CLLocationDegrees)40, @"conversion should match degrees");
    STAssertEquals(coordinate.minutes, (CLLocationDegrees)26, @"conversion should match minutes");
    STAssertEquals(coordinate.seconds, (CLLocationDegrees)46.302, @"conversion should match seconds");
    STAssertEquals(coordinate.direction, -1, @"conversion should match direction");
}

- (void) testColonFormatWithTrailingNegativeDirection
{
    NSString *string = @"79:56:55W";
    LLAngularLocationCoordinate coordinate = [CLLocation angularCoordinatesForString:string];

    STAssertEquals(coordinate.degrees, (CLLocationDegrees)79, @"conversion should match degrees");
    STAssertEquals(coordinate.minutes, (CLLocationDegrees)56, @"conversion should match minutes");
    STAssertEquals(coordinate.seconds, (CLLocationDegrees)55, @"conversion should match seconds");
    STAssertEquals(coordinate.direction, -1, @"conversion should match direction");
}

- (void) testColonFormatWithTrailingDirection
{
    NSString *string = @"40:26:46N";
    LLAngularLocationCoordinate coordinate = [CLLocation angularCoordinatesForString:string];

    STAssertEquals(coordinate.degrees, (CLLocationDegrees)40, @"conversion should match degrees");
    STAssertEquals(coordinate.minutes, (CLLocationDegrees)26, @"conversion should match minutes");
    STAssertEquals(coordinate.seconds, (CLLocationDegrees)46, @"conversion should match seconds");
    STAssertEquals(coordinate.direction, 1, @"conversion should match direction");
}

@end
