//
//  AdMediatorConfig.h
//
//  Created by Kim Beveridge on 29/04/11.
//  Copyright 2011 Simply iApps. All rights reserved.
//

#import <Foundation/Foundation.h>

//Logging variable
//================
//enable  logging - define AdMediatorLogDEBUG
//disable logging - define AdMediatorLogDEBUG_off
#define AdMediatorLogDEBUG

//Constants
//================
extern BOOL const kIsFreeVersion;
extern BOOL const kAdDisplayTop;
extern BOOL const kiAdEnabled;
extern BOOL const kAdMobEnabled;
extern int  const kAdMobRefreshSeconds;
extern BOOL const kAdMobTestMode;
extern NSString * const kAdMobPubliserId;

@interface AdMediatorConfig : NSObject {}

#ifdef AdMediatorLogDEBUG  
#   define AdMediatorLog NSLog
#else
#   define AdMediatorLog
#endif

@end

