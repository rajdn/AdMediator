Implementation notes for configuring AdMediator
==============================================

1. Include the source files into your xcode project, the following files are required.
	- AdMediator.h
	- AdMediator.m
	- AdMediatorConfig.h
	- AdMediatorConfig.m

2. Include the AdMob SDK source files from the AdMob website

3. Include following Frameworks required for AdMob
	- SystemConfiguration
	- MessageUI
	- AudiToolbox
	
4. Include following Frameworks required for iAds
	- iAd (Set as weak reference (optional))
	
5. Create a GCC_PREPROCESSOR_DEFINITIONS called FREE_VERSION in your xcode target, this will indicate that your app is a free version and ads will be enabled.

6. Configure constant values in AdMediatorConfig.m to configure the AdMediator behavior specific to your needs

7. Logging can be turned on or off in AdMediatorConfig.h to enable debug logging

7. Modify your UIViewController class to extend AdMediator

8. Create a new view in your ViewController's XIB file (or programatically) where the rest of your user interface objects would be placed in, link this view to "contentView" that is defined in AdMediator class.  The contentView size will be adjusted when the Ad Banners need to be displayed.

9. That should be it, run the app.

