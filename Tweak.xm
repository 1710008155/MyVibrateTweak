#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <AudioToolbox/AudioToolbox.h>

// 声明私有 API 防止报错
@interface UIImpactFeedbackGenerator : NSObject
- (instancetype)initWithStyle:(NSInteger)style;
- (void)impactOccurred;
@end

%hook WKWebView

- (void)loadRequest:(NSURLRequest *)request {
    // 判空处理，防止闪退
    if (!request || !request.URL) {
        %orig;
        return;
    }

    NSString *scheme = request.URL.scheme;
    
    // 只拦截 godmode 协议
    if ([scheme isEqualToString:@"godmode"]) {
        NSString *action = request.URL.host;
        
        // 震动逻辑
        if ([action isEqualToString:@"taptic"] || [action isEqualToString:@"vibrate"]) {
            // 使用重度触感反馈 (iPhone 7 以上)
            UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:2];
            [gen impactOccurred];
            
            // 同时调用老式震动作为备选
            AudioServicesPlaySystemSound(1519);
        }
        // 弹窗逻辑
        else if ([action isEqualToString:@"alert"]) {
            // 简单的弹窗测试
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"GodMode" message:@"注入成功！" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        }
        
        return; // 拦截，不跳转
    }

    %orig; // 其他链接正常跳转
}

%end
