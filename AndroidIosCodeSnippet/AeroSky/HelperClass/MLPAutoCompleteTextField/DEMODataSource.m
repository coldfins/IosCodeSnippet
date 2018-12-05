//
//  DEMODataSource.m
//  MLPAutoCompleteDemo
//
//  Created by Eddy Borja on 5/28/14.
//  Copyright (c) 2014 Mainloop. All rights reserved.
//

#import "DEMODataSource.h"
#import "DEMOCustomAutoCompleteObject.h"
#import "AFNetworking.h"
#import "HouseCheap-swift.h"

@interface DEMODataSource ()

@property (strong, nonatomic) NSArray *customerObjects;

@end


@implementation DEMODataSource


#pragma mark - MLPAutoCompleteTextField DataSource


//example of asynchronous fetch:
- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
            completionHandler:(void (^)(NSArray *))handler
{
    
   
  //  DEMOAppDelegate *app = (DEMOAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        if(self.simulateLatency){
            CGFloat seconds = arc4random_uniform(4)+arc4random_uniform(4); //normal distribution
            NSLog(@"sleeping fetch of completions for %f", seconds);
            sleep(seconds);
        }
        
        NSArray *completions;
        if(self.testWithAutoCompleteObjectsInsteadOfStrings){
            completions = [self allCustomerObjects];
        } else {
            completions = [self allCustomers];
        }
        
        handler(completions);
    });
}


- (NSArray *)allCustomerObjects
{
    if(!self.customerObjects){
        NSMutableArray *customerNames = [self allCustomers];
        NSMutableArray *mutableCustomer = [NSMutableArray new];
        for(NSString *custName in customerNames){
            DEMOCustomAutoCompleteObject *cust = [[DEMOCustomAutoCompleteObject alloc] initWithCountry:custName];
            [mutableCustomer addObject:cust];
        }
        
        [self setCustomerObjects:[NSArray arrayWithArray:mutableCustomer]];
    }
    
    return self.customerObjects;
}



- (NSMutableArray *)allCustomers
{
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableArray *customers = app.arrAllCity;
    NSLog(@"Customers Name: %@",customers.description);
    return customers;
}





@end
