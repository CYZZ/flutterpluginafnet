#import "FlutterpluginafnetPlugin.h"
#if __has_include(<flutterpluginafnet/flutterpluginafnet-Swift.h>)
#import <flutterpluginafnet/flutterpluginafnet-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutterpluginafnet-Swift.h"
#endif

@implementation FlutterpluginafnetPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterpluginafnetPlugin registerWithRegistrar:registrar];
}
@end
