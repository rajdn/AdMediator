//
//  AdMediator.m
//
//  Created by iKim Beveridge on 29/04/11.
//  Copyright 2011 Simply iApps. All rights reserved.
//

#import "AdMediator.h"
#import "AdMediatorConfig.h"
#import "GADRequest.h"

@implementation AdMediator

@synthesize contentView = _contentView;

//================================================
#pragma mark -
#pragma mark UIViewController Methods
//================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initiAds];
    
    [self initAdMob];
    
    AdMediatorLog(@"SimplyAdMediator - viewDidLoad complete"); 
}

- (void)didReceiveMemoryWarning {
    AdMediatorLog(@"SimplyAdMediator - didReceiveMemoryWarning start"); 
    
    [super didReceiveMemoryWarning];
    
    // Releases the view if it doesn't have a superview.
    
    // Release any cached data, images, etc that aren't in use.
    
    AdMediatorLog(@"SimplyAdMediator - didReceiveMemoryWarning complete"); 
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
    
}

- (void)dealloc {
    AdMediatorLog(@"SimplyAdMediator - dealloc start"); 
    
    [super dealloc];
    
    [_adMobBannerView setDelegate:nil]; [_adMobBannerView release]; _adMobBannerView = nil;
    [_iAdBannerView release]; _iAdBannerView = nil;
    [_admobTimer release]; _admobTimer = nil;
    AdMediatorLog(@"SimplyAdMediator - dealloc complete"); 
}


//================================================
#pragma mark -
#pragma mark Class Methods
//================================================
+(BOOL)isIOS4Installed {
	NSString *version = [[UIDevice currentDevice] systemVersion];
	if ( [version floatValue ] >= 4.0) {
		return YES;
	} else {
		return NO;
	}
}

+(BOOL)isIOS32Installed {
	NSString *version = [[UIDevice currentDevice] systemVersion];
	if ( [version floatValue ] >= 3.2) {
		return YES;
	} else {
		return NO;
	}
}
//================================================
//================================================


//================================================
#pragma mark -
#pragma mark IAD Methods and delegate
//================================================
- (void)initiAds {
    AdMediatorLog(@"SimplyAdMediator - initiAds (iAd) start enabled=%i appIsFreeVersion=%i",kiAdEnabled,kIsFreeVersion); 
    
    // Create a view of the standard size at the bottom of the screen.
    if (kIsFreeVersion && kiAdEnabled) {
        if (_iAdBannerView == nil) {
            if ([AdMediator isIOS4Installed]) {
                AdMediatorLog(@"SimplyAdMediator - initiAds (iAd) initialising..."); 
                
                Class classAdBannerView = NSClassFromString(@"ADBannerView");
                if (classAdBannerView != nil) {
                    
                    _iAdBannerView = [[[classAdBannerView alloc] initWithFrame:CGRectZero] autorelease];
                    
                    //Check for old or new constants for backwards compatibility
                    if (&ADBannerContentSizeIdentifierPortrait != nil) {
                        kTabnavADBannerContentSizeIdentifierPortrait = ADBannerContentSizeIdentifierPortrait;
                    } else {
                        kTabnavADBannerContentSizeIdentifierPortrait = ADBannerContentSizeIdentifier320x50;
                    }
                    
                    if (&ADBannerContentSizeIdentifierLandscape != nil) {
                        kTabnavADBannerContentSizeIdentifierLandscape = ADBannerContentSizeIdentifierLandscape;
                    } else {
                        kTabnavADBannerContentSizeIdentifierLandscape = ADBannerContentSizeIdentifier480x32;
                    }        
                    
                    [_iAdBannerView setRequiredContentSizeIdentifiers:[NSSet setWithObjects:
                                                                      kTabnavADBannerContentSizeIdentifierPortrait,
                                                                      kTabnavADBannerContentSizeIdentifierLandscape, 
                                                                      nil]];
                    
                    if (UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
                        [_iAdBannerView setCurrentContentSizeIdentifier:kTabnavADBannerContentSizeIdentifierLandscape];
                    } else {
                        [_iAdBannerView setCurrentContentSizeIdentifier:kTabnavADBannerContentSizeIdentifierPortrait];            
                    }
                    
                    int yPosition = self.view.frame.size.height;
                    if (kAdDisplayTop) yPosition = -[self getiAdBannerHeight];
                    [_iAdBannerView setFrame:CGRectOffset([_iAdBannerView frame], 0 , yPosition)];
                    
                    [_iAdBannerView setDelegate:self];
                    
                    [self.view addSubview:_iAdBannerView];        
                }
            } else {
                AdMediatorLog(@"SimplyAdMediator - initiAds (iAd) IOS version is < 4.0, can not use iAds"); 
            }
        }
    }
}

- (void)fixupAdView:(UIInterfaceOrientation)toInterfaceOrientation {
    AdMediatorLog(@"SimplyAdMediator - fixupAdView (iAd) start"); 
    if (_iAdBannerView != nil) {        
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            [_iAdBannerView setCurrentContentSizeIdentifier:
             kTabnavADBannerContentSizeIdentifierLandscape];
        } else {
            [_iAdBannerView setCurrentContentSizeIdentifier:
             kTabnavADBannerContentSizeIdentifierPortrait];
        }          
        [UIView beginAnimations:@"fixupViews" context:nil];
        if (_iAdBannerViewIsVisible) {
            CGRect adBannerViewFrame = [_iAdBannerView frame];
            adBannerViewFrame.origin.x = 0;
            
            int yPosition = self.view.frame.size.height - [self getiAdBannerHeight];
            if (kAdDisplayTop) yPosition = 0;
			adBannerViewFrame.origin.y = yPosition;
            [_iAdBannerView setFrame:adBannerViewFrame];

            [self adjustContentView:YES adHeight:[self getiAdBannerHeight:toInterfaceOrientation]];
        } else {
            CGRect adBannerViewFrame = [_iAdBannerView frame];
            adBannerViewFrame.origin.x = 0;
            
            int yPosition = self.view.frame.size.height;
            if (kAdDisplayTop) yPosition = -[self getiAdBannerHeight:toInterfaceOrientation];
            adBannerViewFrame.origin.y = yPosition;
            [_iAdBannerView setFrame:adBannerViewFrame];

            [self adjustContentView:NO adHeight:0];
        }
        [UIView commitAnimations];
    }
}

- (void)adjustContentView:(BOOL)isAdVisible adHeight:(int)adHeight {
    if (isAdVisible) {
        CGRect contentViewFrame = _contentView.frame;
        if (kAdDisplayTop) contentViewFrame.origin.y = adHeight;
        contentViewFrame.size.height = self.view.frame.size.height - adHeight;
        _contentView.frame = contentViewFrame;
    } else {
        CGRect contentViewFrame = _contentView.frame;
        contentViewFrame.origin.y = 0;
        contentViewFrame.size.height = self.view.frame.size.height;
        _contentView.frame = contentViewFrame;            
    }
}

- (int)getiAdBannerHeight:(UIDeviceOrientation)orientation {
	if (UIInterfaceOrientationIsLandscape(orientation)) {
		return 32;
	} else {
		return 50;
	}
}

- (int)getiAdBannerHeight {
	return [self getiAdBannerHeight:[UIDevice currentDevice].orientation];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    AdMediatorLog(@"SimplyAdMediator - bannerViewDidLoadAd (iAd) start"); 

    if (!_iAdBannerViewIsVisible) {                

        _iAdBannerViewIsVisible = YES;

        if (_iMobBannerViewIsVisible) {
            [self moveAdMobOut:@"bannerViewDidLoadAdContinue"];
        } else {
            [self bannerViewDidLoadAdContinue];
        }
    }
}

- (void)bannerViewDidLoadAdContinue {
    AdMediatorLog(@"SimplyAdMediator - bannerViewDidLoadAdContinue (iAd) start"); 

    [self adMobRelease];
    
    [self fixupAdView:[UIDevice currentDevice].orientation];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    AdMediatorLog(@"SimplyAdMediator - didFailToReceiveAdWithError (iAd) start %@", [error localizedDescription]);
    if (_iAdBannerViewIsVisible) {        
        _iAdBannerViewIsVisible = NO;
        [self fixupAdView:[UIDevice currentDevice].orientation];

        [self createAdMob];
    }
    
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
    AdMediatorLog(@"SimplyAdMediator - bannerViewActionDidFinish (iAd) start"); 
    if (_iAdBannerViewIsVisible) {                
        _iAdBannerViewIsVisible = NO;
        [self fixupAdView:[UIDevice currentDevice].orientation];
    }
}
//================================================
//================================================



//================================================
#pragma mark -
#pragma mark AdMob methods and delegate
//================================================
- (void)initAdMob {
    AdMediatorLog(@"SimplyAdMediator - initAdMob (AdMob) start publishId=%@ enabled=%i appIsFreeVersion=%i",kAdMobPubliserId,kAdMobEnabled,kIsFreeVersion); 
    
    // Create a view of the standard size
    if (kIsFreeVersion && kAdMobEnabled) {
        Class gadBannerView = NSClassFromString(@"GADBannerView");
        if (gadBannerView != nil) {
            
            AdMediatorLog(@"SimplyAdMediator - initAdMob (AdMob) initialising..."); 

            [self createAdMob];

            _admobTimer = [NSTimer scheduledTimerWithTimeInterval:(kAdMobRefreshSeconds) target:self selector:@selector(createAdMob) userInfo:nil repeats:YES];	
        }
    }
}

- (void)createAdMob {
    AdMediatorLog(@"SimplyAdMediator - createAdMob (AdMob) start");

    // Create a view of the standard size at the bottom of the screen.
    if (kIsFreeVersion && kAdMobEnabled) {

        if (!_iAdBannerViewIsVisible) {
            //Hide the add if it is alreadt visable
            if (_iMobBannerViewIsVisible) {
                [self moveAdMobOut:@"createAdMobContinue"];
            } else {
                [self createAdMobContinue]; 
            }
        }
    }
}

- (void)createAdMobContinue {
    AdMediatorLog(@"SimplyAdMediator - createAdMobContinue (AdMob) start");

    [self adMobRelease];

    int yPosition = self.view.frame.size.height;
    if (kAdDisplayTop) yPosition = 0-GAD_SIZE_320x50.height;
    _adMobBannerView = [[GADBannerView alloc]
                        initWithFrame:CGRectMake(0.0,
                                                 yPosition,
                                                 GAD_SIZE_320x50.width,
                                                 GAD_SIZE_320x50.height)];
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    [_adMobBannerView setAdUnitID:[NSString stringWithFormat:@"%@",kAdMobPubliserId]];
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    [_adMobBannerView setRootViewController:self];
    
    // Let the runtime know the delegate
    [_adMobBannerView setDelegate:self];
    
    [self.view addSubview:_adMobBannerView];
    
    // Initiate a generic request to load it with an ad.
    GADRequest *gRequest = [GADRequest request];
    
    //Turn on TEST mode to get TEST ads
    if (kAdMobTestMode) { 
        [gRequest setTesting:YES];
    }
    
    [_adMobBannerView loadRequest:gRequest];
    
}

-(void)moveAdMobOut:(NSString *)redirect {
    AdMediatorLog(@"SimplyAdMediator - moveAdMobOut (AdMob) start redirect=%@", redirect);

    NSString *animId = [NSString stringWithString:@"AdMobOut"];
	[UIView beginAnimations:animId context: redirect];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDuration: 0.5];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseOut];

    //Redirect to ultimate method
    if ([redirect isEqualToString:@"createAdMobContinue"]) {
        [UIView setAnimationDidStopSelector:@selector(createAdMobContinue)];
    } else if ([redirect isEqualToString:@"bannerViewDidLoadAdContinue"]) {
        [UIView setAnimationDidStopSelector:@selector(bannerViewDidLoadAdContinue)];
    } else if ([redirect isEqualToString:@"adMobRelease"]) {
        [UIView setAnimationDidStopSelector:@selector(adMobRelease)];
    }
	
	_iMobBannerViewIsVisible = NO;
	
	CGRect frame = _adMobBannerView.frame;
	int yPosition = frame.origin.y + GAD_SIZE_320x50.height;
    if (kAdDisplayTop) yPosition = 0 - GAD_SIZE_320x50.height;
	_adMobBannerView.frame = CGRectMake(0, yPosition, frame.size.width, frame.size.height);

	// other objects reposition codes goes here
    [self adjustContentView:NO adHeight:0];
	
	[UIView commitAnimations];
}

- (void)adMobRelease {
    AdMediatorLog(@"SimplyAdMediator - adMobRelease (AdMob) start");

    //Nullify adMob banner
    [_adMobBannerView removeFromSuperview];
    [_adMobBannerView release];
    _adMobBannerView = nil;

}

- (UIColor *)adBackgroundColorForAd:(GADBannerView *)adView {
    AdMediatorLog(@"SimplyAdMediator - adBackgroundColorForAd (AdMob) start"); 
	return [UIColor colorWithRed:0 green:0 blue:0 alpha:1]; // this should be prefilled; if not, provide a UIColor
}

- (UIColor *)primaryTextColorForAd:(GADBannerView *)adView {
    AdMediatorLog(@"SimplyAdMediator - primaryTextColorForAd (AdMob) start"); 
	return [UIColor colorWithRed:1 green:1 blue:1 alpha:1]; // this should be prefilled; if not, provide a UIColor
}

- (UIColor *)secondaryTextColorForAd:(GADBannerView *)adView {
    AdMediatorLog(@"SimplyAdMediator - secondaryTextColorForAd (AdMob) start"); 
	return [UIColor colorWithRed:1 green:1 blue:1 alpha:1]; // this should be prefilled; if not, provide a UIColor
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    AdMediatorLog(@"SimplyAdMediator - adViewDidReceiveAd (AdMob) start"); 

    if (!_iAdBannerViewIsVisible && !_iMobBannerViewIsVisible) {
        [self moveAdMobIn: bannerView];
    }
}

- (void) moveAdMobIn: (GADBannerView *) bannerView  {
    AdMediatorLog(@"SimplyAdMediator - moveAdMobIn (AdMob) start"); 
    
    _iMobBannerViewIsVisible = YES;

    [UIView beginAnimations:@"BannerSlide" context:nil];
    [UIView setAnimationDuration: 0.5];

    int yPosition = self.view.frame.size.height - GAD_SIZE_320x50.height;
    if (kAdDisplayTop) yPosition = 0;
    bannerView.frame = CGRectMake(0.0,
                                  yPosition,
                                  bannerView.frame.size.width,
                                  bannerView.frame.size.height);

    [self adjustContentView:YES adHeight:GAD_SIZE_320x50.height];

    [UIView commitAnimations];

}

- (void)adView:(GADBannerView *)bannerViewdidFailToReceiveAdWithError:(GADRequestError *)error {
    AdMediatorLog(@"SimplyAdMediator - bannerViewdidFailToReceiveAdWithError (AdMob) start %@", [error localizedDescription]);
}

- (void)adViewWillPresentScreen:(GADBannerView *)bannerView {
    AdMediatorLog(@"SimplyAdMediator - adViewWillPresentScreen (AdMob) start ");
}

- (void)adViewDidDismissScreen:(GADBannerView *)bannerView {
    AdMediatorLog(@"SimplyAdMediator - adViewDidDismissScreen (AdMob) start ");
    if (_iMobBannerViewIsVisible) {
        [self moveAdMobOut:@"adMobRelease"];
    }
}

- (void)adViewWillDismissScreen:(GADBannerView *)bannerView {
    AdMediatorLog(@"SimplyAdMediator - adViewWillDismissScreen (AdMob) start ");    
}

- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView {
    AdMediatorLog(@"SimplyAdMediator - adViewWillLeaveApplication (AdMob) start "); 
    if (_iMobBannerViewIsVisible) {
        [self moveAdMobOut:@"adMobRelease"];
    }
}

@end
