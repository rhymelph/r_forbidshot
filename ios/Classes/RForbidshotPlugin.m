#import "RForbidshotPlugin.h"
#if __has_include(<r_forbidshot/r_forbidshot-Swift.h>)
#import <r_forbidshot/r_forbidshot-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "r_forbidshot-Swift.h"
#endif

@implementation RForbidshotPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftRForbidshotPlugin registerWithRegistrar:registrar];
}
@end
