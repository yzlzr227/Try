//
//  MapViewController.m
//  Try
//
//  Created by Zhuoran Li on 12/12/14.
//  Copyright (c) 2014 NYU. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()<MKMapViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate, MKOverlay>
@property (strong, nonatomic) IBOutlet UITextField *latitudeText;
@property (strong, nonatomic) IBOutlet UITextField *longitudeText;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D currentLocationCoordinate;
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;
@property (strong, nonatomic) MKRoute *currentRoute;
@property (strong, nonatomic) MKPolyline *routeOverlay;
//@property (strong, nonatomic) NSMutableArray *cameras;
//@property (nonatomic) BOOL startToMoveCamera;
@property (strong, nonatomic) NSMutableArray *locationsAlongTheRoute;
//@property (strong, nonatomic) NSMutableArray *distances;
@property (strong, nonatomic) MKPointAnnotation *movingAnnotation;
@end

@implementation MapViewController

//-(void)moveCameraFrom:(CLLocationCoordinate2D)fromLocation To:(CLLocationCoordinate2D)toLocation{
////    CLLocation *locationFrom = [[CLLocation alloc] initWithLatitude:fromLocation.latitude
////                                                         longitude:fromLocation.longitude];
////    CLLocation *locationTo = [[CLLocation alloc] initWithLatitude:toLocation.latitude
////                                                       longitude:toLocation.longitude];
//    //CLLocationDistance distance = [locationTo distanceFromLocation:locationFrom];
//    MKMapCamera *camera0 = [MKMapCamera cameraLookingAtCenterCoordinate:fromLocation
//                                                      fromEyeCoordinate:[self calculateEyeCoordinateFrom:fromLocation
//                                                                                                      To:toLocation
//                                                                                                    Base:fromLocation]
//                                                            eyeAltitude:50];
//    MKMapCamera *camera00 = [MKMapCamera cameraLookingAtCenterCoordinate:toLocation
//                                                       fromEyeCoordinate:[self calculateEyeCoordinateFrom:fromLocation
//                                                                                                       To:toLocation
//                                                                                                     Base:toLocation]
//                                                             eyeAltitude:50];
////    MKMapCamera *camera1 = [MKMapCamera cameraLookingAtCenterCoordinate:fromLocation
////                                                      fromEyeCoordinate:fromLocation
////                                                            eyeAltitude:300.0];
////    MKMapCamera *camera2 = [MKMapCamera cameraLookingAtCenterCoordinate:fromLocation
////                                                      fromEyeCoordinate:fromLocation
////                                                            eyeAltitude:distance];
////    MKMapCamera *camera3 = [MKMapCamera cameraLookingAtCenterCoordinate:toLocation
////                                                      fromEyeCoordinate:toLocation
////                                                            eyeAltitude:distance];
////    MKMapCamera *camera4 = [MKMapCamera cameraLookingAtCenterCoordinate:toLocation
////                                                      fromEyeCoordinate:toLocation
////                                                            eyeAltitude:300];
////    [self.mapView setCamera:camera1];
////    self.cameras = [@[camera2, camera3, camera4] mutableCopy];
//    [self.mapView setCamera:camera0];
//    self.cameras = [@[camera00] mutableCopy];
//}
//
//-(CLLocationCoordinate2D)calculateEyeCoordinateFrom:(CLLocationCoordinate2D) fromLocation To:(CLLocationCoordinate2D)toLocation Base:(CLLocationCoordinate2D)baseLocation{
//    CLLocationCoordinate2D eyeCoordinate;
//    double ratio = (fromLocation.longitude - toLocation.longitude) / (fromLocation.latitude - toLocation.latitude);
//    if (fromLocation.latitude - toLocation.latitude < 0) {
//        eyeCoordinate.latitude = baseLocation.latitude - 0.002;
//        eyeCoordinate.longitude = baseLocation.longitude - 0.002 * ratio;
//    }else{
//        eyeCoordinate.latitude = baseLocation.latitude + 0.002;
//        eyeCoordinate.longitude = baseLocation.longitude + 0.002 * ratio;
//    }
//    return eyeCoordinate;
//}

//- (void)goToNextCamera{
//    if ([self.cameras count] == 0) {
//        self.startToMoveCamera = NO;
//        return;
//    }
//    MKMapCamera *nextCamera = [self.cameras firstObject];
//    [self.cameras removeObjectAtIndex:0];
//    [UIView animateWithDuration:10
//                          delay:0.5
//                        options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{[self.mapView setCamera:nextCamera];}
//                     completion:NULL];
//}

//-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
//    if (animated && self.startToMoveCamera) {
//        [self goToNextCamera];
//    }
//}

//-(void)getCoordinates{
//    NSUInteger pointsCount = self.routeOverlay.pointCount;
//    CLLocationCoordinate2D *routeCoordinates = malloc(pointsCount * sizeof(CLLocationCoordinate2D));
//    [self.routeOverlay getCoordinates:routeCoordinates range:NSMakeRange(0, pointsCount)];
//    self.locationsAlongTheRoute = [[NSMutableArray alloc] initWithCapacity:pointsCount];
//    for (int c = 0; c < pointsCount; c++) {
//        CLLocation *location = [[CLLocation alloc] initWithLatitude:routeCoordinates[c].latitude longitude:routeCoordinates[c].longitude];
//        [self.locationsAlongTheRoute addObject:location];
//    }
//    [self getStepsCoordinats];
//}

-(void)getStepsCoordinats{
    NSMutableArray *locations = [[NSMutableArray alloc] init];
    for (MKRouteStep *step in self.currentRoute.steps) {
        MKPolyline *line = step.polyline;
        NSUInteger pointsCount = line.pointCount;
        CLLocationCoordinate2D *routeCoordinates = malloc(pointsCount * sizeof(CLLocationCoordinate2D));
        [line getCoordinates:routeCoordinates range:NSMakeRange(0, pointsCount)];
        [locations addObject:[[CLLocation alloc] initWithLatitude:routeCoordinates[0].latitude
                                                        longitude:routeCoordinates[0].longitude]];
        [locations addObject:[[CLLocation alloc] initWithLatitude:routeCoordinates[pointsCount - 1].latitude
                                                        longitude:routeCoordinates[pointsCount - 1].longitude]];
    }
    for (int c = (int)[locations count] - 2; c >= 0; c--) {
        if (c % 2 == 0) {
            [locations removeObjectAtIndex:c];
        }
    }
    self.locationsAlongTheRoute = locations;
}
- (void)showcoods{
    for (int c = 0; c < [self.locationsAlongTheRoute count]; c++) {
        CLLocation *locaiton = (CLLocation *)[self.locationsAlongTheRoute objectAtIndex:c];
        NSLog(@"%f, %f", locaiton.coordinate.latitude, locaiton.coordinate.longitude);
    }
    
}
                
-(void)viewDidLoad{
    [super viewDidLoad];
    //self.startToMoveCamera = NO;
    self.latitudeText.delegate = self;
    self.longitudeText.delegate = self;
    
    //Set a few MKMapView Properties to allow pitch, building view, points of interest, and zooming.
    [self.mapView setDelegate:self];
    [self.mapView setShowsUserLocation:YES];
    self.mapView.pitchEnabled = YES;
    self.mapView.showsBuildings = YES;
    self.mapView.showsPointsOfInterest = YES;
    self.mapView.zoomEnabled = YES;
    self.mapView.scrollEnabled = YES;
    self.mapView.zoomEnabled = YES;
    //[self.mapView setMapType:MKMapTypeHybrid];
    [self setUpLocationManager];
}

@synthesize coordinate,boundingMapRect;

- (void)setUpLocationManager{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    [self setLocationAccuracyBestDistanceFilterNone];
    
}

- (void)setLocationAccuracyBestDistanceFilterNone {
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
}

- (IBAction)setLocation:(UIButton *)sender {
//    NSString *latitude = self.latitudeText.text;
//    NSString *longitude = self.longitudeText.text;
    NSString *latitude = @"40.6";
    NSString *longitude = @"-74";
    self.latitudeLabel.text = latitude;
    self.longitudeLabel.text = longitude;
    self.destinationCoordinate = CLLocationCoordinate2DMake(latitude.doubleValue,longitude.doubleValue);

    self.movingAnnotation = [[MKPointAnnotation alloc] init];
    self.movingAnnotation.coordinate = self.currentLocationCoordinate;
    self.movingAnnotation.title = @"Start";
    
    MKPointAnnotation *endPointAnnotation = [[MKPointAnnotation alloc] init];
    endPointAnnotation.coordinate = self.destinationCoordinate;
    endPointAnnotation.title = @"End";
    
    [self drawRouteFromCurrentLocationToLocation:self.destinationCoordinate];
    [self.mapView showAnnotations:@[endPointAnnotation, self.movingAnnotation] animated:YES];
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (void)drawRouteFromCurrentLocationToLocation:(CLLocationCoordinate2D)coords{
    
    //path
    MKDirectionsRequest *directionRequest = [MKDirectionsRequest new];
    MKMapItem *source = [MKMapItem mapItemForCurrentLocation];
    //make the destination
    MKPlacemark *destinetionPlaceMark = [[MKPlacemark alloc] initWithCoordinate:coords addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinetionPlaceMark];
    [directionRequest setSource:source];
    [directionRequest setDestination:destination];
    directionRequest.transportType = MKDirectionsTransportTypeAutomobile;
    //get directions
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"can not get directions");
            return;
        }
        //MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coords, 1000, 1000);
        //[self.mapView setRegion:region animated:YES];
        self.currentRoute =  [response.routes firstObject];
        [self plotRouteOnMap:self.currentRoute];
    }];
}


- (IBAction)myLocationButton:(UIButton *)sender {
    [self getStepsCoordinats];
    [self moveAnnotation:self.movingAnnotation
            withDistance:[self.locationsAlongTheRoute.firstObject distanceFromLocation:[[CLLocation alloc] initWithLatitude:self.currentLocationCoordinate.latitude
                                                                                                                  longitude:self.currentLocationCoordinate.longitude]]];

}

- (void)moveAnnotation:(MKPointAnnotation *)annotation withDistance:(CLLocationDistance) distance{
    if ([self.locationsAlongTheRoute count] == 0) {
        [self.mapView removeAnnotation:self.movingAnnotation];
        return;
    }
    CLLocation *locaiton = [self.locationsAlongTheRoute firstObject];
    //NSLog(@"%f,%f", locaiton.coordinate.latitude, locaiton.coordinate.longitude);
    [self.locationsAlongTheRoute removeObjectAtIndex:0];
    CLLocationDistance nextDistance;
    if ([self.locationsAlongTheRoute count] != 0) {
        nextDistance = [self.locationsAlongTheRoute.firstObject distanceFromLocation:locaiton];
    }else{
        nextDistance = [locaiton distanceFromLocation:[[CLLocation alloc] initWithLatitude:self.destinationCoordinate.latitude
                                                                             longitude:self.destinationCoordinate.longitude]];
    }
    //NSLog(@"%f", distance);
    [UIView animateWithDuration:2.0f * distance / 300
                     animations:^{
                         [annotation setCoordinate:locaiton.coordinate];
                     }
                     completion:^(BOOL finished) {
                         [self moveAnnotation:annotation withDistance:nextDistance];
                     }];

}

- (void)moveAnnotation{
    
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@", [error localizedFailureReason]);
    [self.locationManager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *cllocation = [locations lastObject];
    self.currentLocationCoordinate = [cllocation coordinate];
    // set the labels
    self.latitudeLabel.text = [NSString stringWithFormat:@"%f", self.currentLocationCoordinate.latitude];
    self.longitudeLabel.text = [NSString stringWithFormat:@"%f", self.currentLocationCoordinate.longitude];
    
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.currentLocationCoordinate, 250, 250);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    [manager stopUpdatingLocation];
}


#pragma mark - overlay methods

- (void)plotRouteOnMap:(MKRoute *)route{
    if (_currentRoute) {
        [self.mapView removeOverlay:self.routeOverlay];
    }
    
    self.routeOverlay = route.polyline;
    [self.mapView addOverlay:self.routeOverlay level:MKOverlayLevelAboveRoads];
}

#pragma mark - MKMapViewDelegate methods
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor redColor];
    renderer.lineWidth = 4.0;
    return renderer;
}

@end
