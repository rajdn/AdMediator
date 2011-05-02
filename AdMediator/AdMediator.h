//
//  AdMediator.h
//
//  Created by iKim Beveridge on 29/04/11.
//  Copyright 2011 Simply iApps. All rights reserved..
//

#import <Foundation/Foundation.h>
#import "GADBannerView.h"
#import "iAd/ADBannerView.h"

@interface AdMediator : UIViewController <GADBannerViewDelegate> {
    
    UIView *_contentView;

    GADBannerView *_adMobBannerView;
	BOOL _iMobBannerViewIsVisible;
	NSTimer *_admobTimer;

    id   _iAdBannerView;
	BOOL _iAdBannerViewIsVisible;

    NSString *kTabnavADBannerContentSizeIdentifierPortrait;
    NSString *kTabnavADBannerContentSizeIdentifierLandscape;
}

@property (nonatomic, retain) IBOutlet UIView *contentView;

- (void)initAdMob;
- (void)createAdMob;
- (void)createAdMobContinue;
- (void)moveAdMobOut:(NSString *)redirect;
- (void)adMobRelease;
- (void)moveAdMobIn:(GADBannerView *) bannerView;

- (void)initiAds;
- (int)getiAdBannerHeight:(UIDeviceOrientation)orientation;
- (int)getiAdBannerHeight;
- (void)bannerViewDidLoadAdContinue;

- (void)adjustContentView:(BOOL)isAdVisible adHeight:(int)adHeight;

+(BOOL)isIOS4Installed ;
+(BOOL)isIOS32Installed ;

@end
