#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The resource bundle ID.
static NSString * const ACBundleID AC_SWIFT_PRIVATE = @"com.tolmetti.PeopleApp";

/// The "background" asset catalog color resource.
static NSString * const ACColorNameBackground AC_SWIFT_PRIVATE = @"background";

/// The "detail_background" asset catalog color resource.
static NSString * const ACColorNameDetailBackground AC_SWIFT_PRIVATE = @"detail_background";

/// The "launch_screen_background" asset catalog color resource.
static NSString * const ACColorNameLaunchScreenBackground AC_SWIFT_PRIVATE = @"launch_screen_background";

/// The "pill" asset catalog color resource.
static NSString * const ACColorNamePill AC_SWIFT_PRIVATE = @"pill";

/// The "text" asset catalog color resource.
static NSString * const ACColorNameText AC_SWIFT_PRIVATE = @"text";

/// The "logo" asset catalog image resource.
static NSString * const ACImageNameLogo AC_SWIFT_PRIVATE = @"logo";

#undef AC_SWIFT_PRIVATE
