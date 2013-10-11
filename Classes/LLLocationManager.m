//
//  LLLocationManager.m
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

#import "LLLocationManager.h"

NSString * const LLLocationManagerDidUpdateHeadingNotification = @"LLLocationManagerDidUpdateHeadingNotification";
NSString * const LLLocationManagerDidUpdateToLocationNotification = @"LLLocationManagerDidUpdateToLocationNotification";
NSString * const LLLocationManagerAuthorizationStatusDidChange = 
    @"LLLocationManagerAuthorizationStatusDidChange";
NSString * const LLLocationManagerDidRequestHeadingEvents = 
    @"LLLocationManagerDidRequestHeadingEvents";

@interface LLLocationManager ()

@property (readwrite) BOOL availabilityOfLocationServicesDidChange;
@property (readwrite) CLAuthorizationStatus authorizationStatus;

@end

#pragma mark -

@implementation LLLocationManager

@synthesize locationManager = _locationManager;
@synthesize currentLocation = _currentLocation;
@synthesize currentHeading = _currentHeading;

@synthesize availabilityOfLocationServicesDidChange = _availabilityOfLocationServicesDidChange;
@synthesize authorizationStatus = _authorizationStatus;

#pragma mark -

+ (id) sharedManager
{
    static LLLocationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LLLocationManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

+ (BOOL) locationServicesAvailable
{
    return ( [CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized );
}

+ (CLAuthorizationStatus) authorizationStatus
{
  return [CLLocationManager authorizationStatus];
}

#pragma mark -

- (void)initializeLocationManager
{
    self.authorizationStatus = [CLLocationManager authorizationStatus];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
}

- (void) noteAvailabilityOfLocationServices
{
    CLAuthorizationStatus newStatus = [CLLocationManager authorizationStatus];
    self.availabilityOfLocationServicesDidChange = ( newStatus != self.authorizationStatus );
    self.authorizationStatus = newStatus;
}

- (BOOL)startGeolocationEvents:(BOOL)override
{
    if ( ![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized ) {
        NSLog(@"Location services unavailable");
        if (!override) return NO;
    }
    
    // Start location services to get the true heading.
    self.locationManager.distanceFilter = 5.0; // kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [self.locationManager startUpdatingLocation];
    
    return YES;
}

- (BOOL)startHeadingEvents
{
    if (![CLLocationManager headingAvailable]) {
        NSLog(@"Heading information is unavailable");
        return NO;
    }
    
    // Start heading updates.
    self.locationManager.headingFilter = 1.0; // kCLHeadingFilterNone;
    [self.locationManager startUpdatingHeading];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LLLocationManagerDidRequestHeadingEvents object:nil];
    
    return YES;
}

- (void)stopGeolocationEvents
{
    [self.locationManager stopUpdatingLocation];
}

- (void)stopHeadingEvents
{
    [self.locationManager stopUpdatingHeading];
}

#pragma mark - Status

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    //NSLog(@"locationManager:didChangeAuthorizationStatus");
    [self noteAvailabilityOfLocationServices];
    if ( self.availabilityOfLocationServicesDidChange) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LLLocationManagerAuthorizationStatusDidChange object:self userInfo:nil];
    }
    
    if ( status == kCLAuthorizationStatusNotDetermined ) {
        // first launch
    } else if ( status == kCLAuthorizationStatusRestricted ) {
    
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //NSLog(@"locationManager:didFailWithError: %@",error);
    
    if ( error.code == kCLErrorDenied ) {
        // stop the location service
        [self stopGeolocationEvents];
    } else if ( error.code == kCLErrorHeadingFailure ) {
        ; // not response
    } else if ( error.code == kCLErrorLocationUnknown ) {
        ; // just wait
    }
}

#pragma mark - Heading Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    if (newHeading.headingAccuracy < 0)
      return;
 
   // Use the true heading if it is valid.
   //CLLocationDirection theHeading = ((newHeading.trueHeading > 0) ?
     //       newHeading.trueHeading : newHeading.magneticHeading);
 
   self.currentHeading = newHeading;
   
   // TODO: post notification
   [[NSNotificationCenter defaultCenter] postNotificationName:LLLocationManagerDidUpdateHeadingNotification object:self userInfo:[NSDictionary dictionaryWithObject:newHeading forKey:@"heading"]];
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    return YES;
}

#pragma mark - Location Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // If it's a relatively recent event, turn off updates to save power
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0)
    {
        //NSLog(@"latitude %+.6f, longitude %+.6f\n",
          //      newLocation.coordinate.latitude,
          //      newLocation.coordinate.longitude);
        
        self.currentLocation = newLocation;
        
        // TODO: post notification
        [[NSNotificationCenter defaultCenter] postNotificationName:LLLocationManagerDidUpdateToLocationNotification object:self userInfo:[NSDictionary dictionaryWithObject:newLocation forKey:@"location"]];
    }
    // else skip the event and process the next one.
}


@end
