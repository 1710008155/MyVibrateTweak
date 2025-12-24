#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface UIImpactFeedbackGenerator : NSObject
- (instancetype)initWithStyle:(NSInteger)style;
- (void)impactOccurred;
@end

%hook WKWebView

- (void)loadRequest:(NSURLRequest *)request {
    NSURL *url = request.URL;
    NSString *scheme = url.scheme;

    if ([scheme isEqualToString:@"godmode"]) {
        NSString *action = url.host;
        NSString *query = url.query;

        if ([action isEqualToString:@"vibrate"]) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
        else if ([action isEqualToString:@"taptic"]) {
            UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:2];
            [gen impactOccurred];
        }
        else if ([action isEqualToString:@"alert"]) {
            NSString *content = [query stringByReplacingOccurrencesOfString:@"msg=" withString:@""];
            content = [content stringByRemovingPercentEncoding];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"GodMode" message:content preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        }
        else if ([action isEqualToString:@"safari"]) {
            NSString *targetUrlStr = [query stringByReplacingOccurrencesOfString:@"url=" withString:@""];
            targetUrlStr = [targetUrlStr stringByRemovingPercentEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:targetUrlStr] options:@{} completionHandler:nil];
        }
        else if ([action isEqualToString:@"copy"]) {
            NSString *text = [query stringByReplacingOccurrencesOfString:@"text=" withString:@""];
            [UIPasteboard generalPasteboard].string = [text stringByRemovingPercentEncoding];
        }
        return;
    }
    %orig;
}
%end
