#import "FlutterPublitioPlugin.h"
#import <flutter_publitio/flutter_publitio-Swift.h>

@implementation FlutterPublitioPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterPublitioPlugin registerWithRegistrar:registrar];
}
@end
