//
//  SPGooglePlacesAutocompleteQuery.m
//  SPGooglePlacesAutocomplete
//
//  Created by Stephen Poletto on 7/17/12.
//  Copyright (c) 2012 Stephen Poletto. All rights reserved.
//

#import "SPGooglePlacesAutocompleteQuery.h"
#import "SPGooglePlacesAutocompletePlace.h"

@interface SPGooglePlacesAutocompleteQuery()
@property (nonatomic, copy) SPGooglePlacesAutocompleteResultBlock resultBlock;
@end

@implementation SPGooglePlacesAutocompleteQuery

- (id)initWithApiKey:(NSString *)apiKey {
    self = [super init];
    if (self) {
        // Setup default property values.
        self.sensor = NO;
        self.key = apiKey;
        self.offset = 2;
        self.location = CLLocationCoordinate2DMake(21.1700, 72.8300);
        self.radius = 800;
        self.types = SPPlaceTypeGeocode;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Query URL: %@", [self googleURLString]];
}


- (NSString *)googleURLString {
    NSMutableString *url = [NSMutableString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&sensor=%@&key=%@",
                            [self.input stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                            SPBooleanStringForBool(false), self.key];
    
    NSLog(@"url%@",url);
    

    if (self.offset != NSNotFound) {
        [url appendFormat:@"&offset=%lu", (unsigned long)self.offset];
    }
    if (self.location.latitude != -1) {
        [url appendFormat:@"&location=%f,%f", self.location.latitude, self.location.longitude];
    }
    if (self.radius != NSNotFound) {
        [url appendFormat:@"&radius=%f", self.radius];
    }
    if (self.language) {
        [url appendFormat:@"&language=en"];
    }
    if (self.types != SPPlaceTypeInvalid) {
        [url appendFormat:@"&types=%@", SPPlaceTypeStringForPlaceType(self.types)];
    }
    if (self.countryCode != nil) {
        [url appendFormat:@"&components=country:%@", self.countryCode];
    }
    //NSLog(@"url: %@", url);
    return url;
}

- (void)cleanup {
    googleConnection = nil;
    responseData = nil;
    self.resultBlock = nil;
}

- (void)cancelOutstandingRequests {
    [googleConnection cancel];
    [self cleanup];
}

- (void)fetchPlaces:(SPGooglePlacesAutocompleteResultBlock)block {
    if (!self.key) {
        return;
    }
    
    if (SPIsEmptyString(self.input)) {
        // Empty input string. Don't even bother hitting Google.
        block(@[], nil);
        return;
    }
    
    [self cancelOutstandingRequests];
    self.resultBlock = block;
    NSMutableString *url = [NSMutableString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&sensor=%@&key=%@",
                            [self.input stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                            SPBooleanStringForBool(false), self.key];
    
    // NSLog(@"url1  %@",url);
    
  //  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self googleURLString]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    googleConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    responseData = [[NSMutableData alloc] init];
}

#pragma mark -
#pragma mark NSURLConnection Delegate

- (void)failWithError:(NSError *)error {
    if (self.resultBlock != nil) {
        self.resultBlock(nil, error);
    }
    [self cleanup];
}

- (void)succeedWithPlaces:(NSArray *)places {
    NSMutableArray *parsedPlaces = [NSMutableArray array];
    for (NSDictionary *place in places) {
        [parsedPlaces addObject:[SPGooglePlacesAutocompletePlace placeFromDictionary:place apiKey:self.key]];
    }
    if (self.resultBlock != nil) {
        self.resultBlock(parsedPlaces, nil);
    }
    [self cleanup];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if (connection == googleConnection) {
        [responseData setLength:0];
    }
}

- (void)connection:(NSURLConnection *)connnection didReceiveData:(NSData *)data {
    if (connnection == googleConnection) {
        [responseData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (connection == googleConnection) {
        [self failWithError:error];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (connection == googleConnection) {
        NSError *error = nil;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        if (error) {
            [self failWithError:error];
            return;
        }
        if ([response[@"status"] isEqualToString:@"ZERO_RESULTS"]) {
            [self succeedWithPlaces:@[]];
            return;
        }
        if ([response[@"status"] isEqualToString:@"OK"]) {
            [self succeedWithPlaces:response[@"predictions"]];
            return;
        }
        
        // Must have received a status of OVER_QUERY_LIMIT, REQUEST_DENIED or INVALID_REQUEST.
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: response[@"status"]};
        [self failWithError:[NSError errorWithDomain:@"com.spoletto.googleplaces" code:kGoogleAPINSErrorCode userInfo:userInfo]];
    }
}

@end