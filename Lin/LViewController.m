//
//  LViewController.m
//  Lin
//
//  Created by Ilya Elovikov on 28/03/14.
//  Copyright (c) 2014 4taps. All rights reserved.
//

#import "LViewController.h"
#import "NSStringUrlParams.h"

@interface LViewController ()

@end

@implementation LViewController {
    LinkedInDataProvider *linkedIn;
    LPeopleGetOperation  *getPeopleOp;
    LPeopleNetworkUpdatesOperation *netOperation;
    LPeopleSharesOperation *sharesOperation;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    linkedIn = [LinkedInDataProvider inststance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginTouch:(id)sender {
    
    getPeopleOp = [[LPeopleGetOperation alloc] initWithParams:nil andFields:@[kLinFirstNameParam, kLinLastNameParam, kLinHeadlineParam, kLinConnectionsParam] Delegate:self];
    [getPeopleOp start];
}

- (IBAction)sendTouch:(id)sender {
    const char *s = [[_statusLabel text] UTF8String];
    NSString *status = [[NSString alloc] initWithCString:s encoding:NSUTF8StringEncoding];
 
    NSLog(@"[Status] %@",status);
    
    NSDictionary *update = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [[NSDictionary alloc]
                             initWithObjectsAndKeys:
                             @"anyone",@"code",nil], @"visibility",
                            status, @"comment", nil];
    sharesOperation = [[LPeopleSharesOperation alloc] initWithParams:update Delegate:self];
    [sharesOperation start];
}

#pragma mark -

- (void)inMethodDidFinished: (NSString *)method withResult: (id)result {
    if ([method isEqual:kPeopleGetMethod] && result)
    {
        _peopleLabel.text = [[NSString alloc] initWithFormat:@"%@ %@\n%@",
                             [result objectForKey:@"firstName"],
                             [result objectForKey:@"lastName"],
                             [result objectForKey:@"headline"]];
    }
    else if ([method isEqual:kPeopleSharesMethod] && result) {
        NSDictionary *params = @{kLinScopeParam: @"self", kLinCountParam: @"1", kLinTypeParam: @"STAT"};
        netOperation = [[LPeopleNetworkUpdatesOperation alloc] initWithParams:params Delegate:self];
        [netOperation start];
    }
    else if ([method isEqual:kPeopleNetworkUpdatesMethod] && result) {
        NSString *status = nil;
        
        if ( [result objectForKey:@"currentStatus"] )
        {

            status = [result objectForKey:@"currentStatus"];
        } else {

            status = [[[[result objectForKey:@"personActivities"]
                             objectForKey:@"values"]
                            objectAtIndex:0]
                           objectForKey:@"body"];
            
        }
        _peopleLabel.text = [NSString stringWithFormat:@"%@\n%@", _peopleLabel.text, status];
    }
}
- (void)inMethodDidFinished: (NSString *)method withError: (NSError *)error {
    
}
@end
