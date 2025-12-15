//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<integration_test/IntegrationTestPlugin.h>)
#import <integration_test/IntegrationTestPlugin.h>
#else
@import integration_test;
#endif

#if __has_include(<orbit_task_ios/OrbitTaskIosPlugin.h>)
#import <orbit_task_ios/OrbitTaskIosPlugin.h>
#else
@import orbit_task_ios;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [IntegrationTestPlugin registerWithRegistrar:[registry registrarForPlugin:@"IntegrationTestPlugin"]];
  [OrbitTaskIosPlugin registerWithRegistrar:[registry registrarForPlugin:@"OrbitTaskIosPlugin"]];
}

@end
