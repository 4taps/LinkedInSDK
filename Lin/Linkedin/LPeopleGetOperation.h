//
//  LPeopleGetOperation.h
//  Lin
//
//  Created by Ilya Elovikov on 31/03/14.
//  Copyright (c) 2014 4taps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LInBaseOperation.h"

#define kLinFirstNameParam   @"firstName"
#define kLinLastNameParam    @"lastName"
#define kLinHeadlineParam    @"headline"

#define kLinFollowingParam   @"following"
#define kLinSuggestionsParam @"suggestions"
#define kLinSkillsParam      @"skills"
#define kLinConnectionsParam @"connections"

#define kLinThreeCurrentPositionsParam @"three-current-positions"
#define kLinThreePastPositionsParam    @"three-past-positions"

@interface LPeopleGetOperation : LInBaseOperation

@end
