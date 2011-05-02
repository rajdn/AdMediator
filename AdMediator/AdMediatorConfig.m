//
//  SimplyAdMediatorConfig.m
//
//  Created by Kim Beveridge on 30/04/11.
//  Copyright 2011 Simply iApps. All rights reserved.
//

#import "AdMediatorConfig.h"

//Ad Banner Location
//==================
BOOL const kAdDisplayTop = NO;									//Display Ad Banner at TOP or BOTTOM


//iAd Config
//==================
BOOL const kiAdEnabled = YES;    								//Enable iAds


//AdMob Config
//==================
BOOL const kAdMobEnabled = YES;								   	//Enable AdMob
int  const kAdMobRefreshSeconds = 60;							//Number of seconds that AdMob banner will be recreated and refreshed
BOOL const kAdMobTestMode = YES;								//Activate TEST mode for AdMob
NSString * const kAdMobPubliserId = @"a14db97c6a8c793";			//Set your Publisher ID from your Site configured on AdMob site


//Free Version ???
//================
// Often, your app may have multiple targets defined in xcode.
// set a GCC_PREPROCESSOR_DEFINITIONS called "FREE_VERSION", so that ads will only be activated in the FREE Version of your app
#ifdef FREE_VERSION
    BOOL const kIsFreeVersion = YES;
#else
    BOOL const kIsFreeVersion = NO;
#endif

@implementation AdMediatorConfig

@end
