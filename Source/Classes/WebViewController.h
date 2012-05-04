#import <WebKit/WebKit.h>

@interface WebViewController : NSViewController

@property (nonatomic, strong, readonly) IBOutlet WebView *webView;

- (void)loadInitialContent;

@end
