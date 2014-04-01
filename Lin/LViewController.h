//
//  LViewController.h
//  Lin
//
//  Created by Ilya Elovikov on 28/03/14.
//  Copyright (c) 2014 4taps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLinkedIn.h"

@interface LViewController : UIViewController<LInMethodDelegate>

@property (weak, nonatomic) IBOutlet UITextField *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;
- (IBAction)loginTouch:(id)sender;
- (IBAction)sendTouch:(id)sender;
@end
