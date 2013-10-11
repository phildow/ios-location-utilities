ios-location-utilities
======================

A collection of geolocation utilities for iOS.

#### CLDegreesAndRadians

Convert degrees to radians and radians to degrees.

#### CLHeading+Formatted

Convert heading to cardinal direction and abbreviated cardinal direction.

#### CLLocation+Bearing.h

Haversine and rhumb line bearing from one geolocation to another.

#### CLLocation+DecimalDegreesConversion

A collection of regular expressions for converting textual geolocation descriptions into actual geolcation objects. Unit tests are included. The following formats are supported:

1. 40:26:46N,79:56:55W
2. 40:26:46.302N 79:56:55.903W
3. 40°26'47"N 79°58'36"W
4. 40d 26' 47" N 79d 58' 36" W
5. 40° 26.7717, -79° 56.93172
6. 40.446195N 79.948862W
7. 40.446195, -79.948862 

#### LLLocationConversionTests

Unit tests for the above regular expression conversions.

#### CLLocation+Degrees

Convert geolocation to textual format in degrees.

#### CLLocation+Direction

Get the direction to one location from another.

#### CLLocation+Distance

Get the distance from one location to another.

#### CLLocation+EXIFGPS

Generate the EXIF dictionary for a geotagged photo.

#### CLLocation+UserInfo

Objective-C voodoo to add a few helpful attributes to CLLocation.

#### CLPlacemark+UserInfo.h

More Objective-C voodoo to add a few helpful attributes to CLPlacemark.

#### LLLocationManager

A wrapper for CLLocationManager.