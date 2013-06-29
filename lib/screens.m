#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>


int main(int argc, const char * argv[]) {


  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  //NSArray *screens = [NSScreen screens];

  NSScreen *mainScreen = [NSScreen mainScreen];

  NSRect rect = mainScreen.frame;
  NSString *out = [NSString stringWithFormat:@"%1.0f,%1.0f,%1.0f,%1.0f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height];

  const char *str = [out UTF8String];
  printf(str);

  // insert code here...
  //NSLog(@"%@", [screens objectAtIndex:0]);

  //for (NSScreen *screen in screens) {
    //NSLog(@"%@", NSStringFromRect(screen.frame));
    //NSString *str = NSStringFromRect(screen.frame);
    //printf([str UTF8String]);
  //}

  //NSRunningApplication *activeApplication = nil;
  //for (NSRunningApplication *app in [[NSWorkspace sharedWorkspace] runningApplications]) {
    //if (app.active) {
      //activeApplication = app;
      //break;
    //}
  //}

  [pool drain];
  return 0;
}

