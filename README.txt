<h1>Implementation notes for configuring AdMediator</h1>

<ol>
<li><p>Include the source files into your xcode project, the following files are required.</p>

<ul><li>AdMediator.h</li>
<li>AdMediator.m</li>
<li>AdMediatorConfig.h</li>
<li>AdMediatorConfig.m</li></ul></li>
<li><p>Include the AdMob SDK source files from the AdMob website</p></li>
<li><p>Include following Frameworks required for AdMob</p>

<ul><li>SystemConfiguration</li>
<li>MessageUI</li>
<li>AudiToolbox</li></ul></li>
<li><p>Include following Frameworks required for iAds</p>

<ul><li>iAd (Set as weak reference (optional))</li></ul></li>
<li><p>Create a GCC<em>PREPROCESSOR</em>DEFINITIONS called FREE_VERSION in your xcode target, this will indicate that your app is a free version and ads will be enabled.</p></li>
<li><p>Configure constant values in AdMediatorConfig.m to configure the AdMediator behavior specific to your needs</p></li>
<li><p>Logging can be turned on or off in AdMediatorConfig.h to enable debug logging</p></li>
<li><p>Modify your UIViewController class to extend AdMediator</p></li>
<li><p>Create a new view in your ViewController's XIB file (or programatically) where the rest of your user interface objects would be placed in, link this view to "contentView" that is defined in AdMediator class.  The contentView size will be adjusted when the Ad Banners need to be displayed.</p></li>
<li><p>That should be it, run the app.</p></li>
</ol>


