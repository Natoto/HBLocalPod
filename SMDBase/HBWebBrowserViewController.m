//
//  HBWebbrowser.m
//  hjb
//
//  Created by zeno on 16/3/14.
//  Copyright © 2016年 YY.COM All rights reserved.
//

#import "HBWebBrowserViewController.h"

#import "UINavigationController+FDFullscreenPopGesture.h"
static void *KINWebBrowserContext = &KINWebBrowserContext;

@interface HBWebBrowserViewController ()<WKNavigationDelegate, UIWebViewDelegate>
@property (nonatomic, strong) NSTimer *fakeProgressTimer;

@property (nonatomic, assign) BOOL uiWebViewIsLoading;
@property (nonatomic, strong) NSURL *uiWebViewCurrentURL;
@property (nonatomic, strong) NSURL *URLToLaunchWithPermission;
@property (nonatomic, strong) UIAlertView *externalAppPermissionAlertView;
@property (nonatomic, strong) UIButton * btn_close;
@property (nonatomic, assign) BOOL islocalhtml;
@end

@implementation HBWebBrowserViewController


+ (HBWebBrowserViewController *)webBrowser {
    HBWebBrowserViewController *webBrowserViewController = [HBWebBrowserViewController webBrowserWithConfiguration:nil];
    return webBrowserViewController;
}

+ (HBWebBrowserViewController *)locoalwebBrowser {
    HBWebBrowserViewController *webBrowserViewController = [[HBWebBrowserViewController alloc] initLocoalWebBrowser];
    return webBrowserViewController;
}

+ (HBWebBrowserViewController *)webBrowserWithConfiguration:(WKWebViewConfiguration *)configuration {
    HBWebBrowserViewController *webBrowserViewController = [[self alloc] initWithConfiguration:configuration];
    return webBrowserViewController;
}

- (id)initLocoalWebBrowser {
    self = [super init];
    if(self) {
        self.uiWebView = [[UIWebView alloc] init];
        self.islocalhtml = YES;
    }
    return self;
}

- (id)initWithConfiguration:(WKWebViewConfiguration *)configuration {
    self = [super init];
    if(self) {
        if([WKWebView class]) {
            if(configuration) {
                self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
            }
            else {
                self.wkWebView = [[WKWebView alloc] init];
            }
        }
        else {
            self.uiWebView = [[UIWebView alloc] init];
        }
        
//        self.actionButtonHidden = NO;
//        self.showsURLInNavigationBar = NO;
//        self.showsPageTitleInNavigationBar = YES;
//        
//        self.externalAppPermissionAlertView = [[UIAlertView alloc] initWithTitle:@"Leave this app?" message:@"This web page is trying to open an outside app. Are you sure you want to open it?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Open App", nil];
        
    }
    return self;
}

- (void)dealloc {
    [self.uiWebView setDelegate:nil];
    
    [self.wkWebView setNavigationDelegate:nil];
    [self.wkWebView setUIDelegate:nil];
    if ([self isViewLoaded]) {
        [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.previousNavigationControllerToolbarHidden = self.navigationController.toolbarHidden;
//    self.previousNavigationControllerNavigationBarHidden = self.navigationController.navigationBarHidden;
    
    if(self.wkWebView) {
        [self.wkWebView setFrame:self.view.bounds];
        [self.wkWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self.wkWebView setNavigationDelegate:self];
        [self.wkWebView setMultipleTouchEnabled:YES];
        [self.wkWebView setAutoresizesSubviews:YES];
        [self.wkWebView.scrollView setAlwaysBounceVertical:YES];
        [self.view addSubview:self.wkWebView];
        
        [self.wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:KINWebBrowserContext];
    }
    else if(self.uiWebView) {
        [self.uiWebView setFrame:self.view.bounds];
        [self.uiWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self.uiWebView setDelegate:self];
//        [self.uiWebView setMultipleTouchEnabled:YES];
//        [self.uiWebView setAutoresizesSubviews:YES];
//        [self.uiWebView setScalesPageToFit:YES];
        [self.uiWebView.scrollView setAlwaysBounceVertical:YES];
        [self.view addSubview:self.uiWebView];
    }
    self.fd_interactivePopDisabled = YES;
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self.progressView setTrackTintColor:[UIColor colorWithWhite:1.0f alpha:0.0f]];
    [self.progressView setFrame:CGRectMake(0, self.navigationbar.frame.size.height-self.progressView.frame.size.height, self.view.frame.size.width, self.progressView.frame.size.height)];
    [self.progressView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];

    [self btn_close];
    if (self.showMoreItem) {
        [self.navigationbar setrightBarButtonItemWithTitle:@"更多" target:self selector:@selector(morebtntap:)];
    }
}

-(IBAction)morebtntap:(id)sender
{
    NSString * url ;
    if(self.wkWebView) {
        url = self.wkWebView.URL.absoluteString;
    }
    else {
        url = self.uiWebView.request.URL.absoluteString;
    }
    if (url) {
        UIActivityViewController *activityViewController =
        [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
        UIViewController *toVC = self;
        [toVC presentViewController:activityViewController animated:YES completion:nil];
 
    }
}
-(UIButton *)btn_close
{
    if (!_btn_close) {
        _btn_close = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn_close setTitle:@"关闭" forState:UIControlStateNormal];
        [_btn_close setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_btn_close addTarget:self action:@selector(backtoparent:) forControlEvents:UIControlEventTouchUpInside];
        _btn_close.frame = CGRectMake(self.navigationbar.leftItem.right - 20, 20, 50, 44.);
        _btn_close.bottom = self.navigationbar.bottom;
        _btn_close.showsTouchWhenHighlighted = YES;
        [self.navigationbar addSubview:_btn_close];
        _btn_close.hidden = YES;
    }
    return _btn_close;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationbar clearBottomLayer];
    [self.navigationbar addSubview:self.progressView];
    [self updateToolbarState];
    
    if (self.navigationController.childViewControllers.count > 1 && self.navigationController.topViewController == self) {
        [self.navigationbar setleftBarButtonItemWithImage:[UIImage imageNamed:@"white_back_btn"] target:self selector:@selector(backtoparent:)];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.uiWebView setDelegate:nil];
    [self.progressView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Public Interface

- (void)loadURL:(NSURL *)URL {
    if(self.wkWebView) {
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:URL]];
    }
    else if(self.uiWebView) {
        //解决TXT中文乱码问题
        
        NSString * filePath = URL.relativePath;
        
        if ([filePath.lastPathComponent containsString:@".txt"]) {
            
//            self.uiWebView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
            NSString *body =[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
            //如果不是 则进行GBK编码再解码一次
            if (!body) {
                body =[NSString stringWithContentsOfFile:filePath encoding:0x80000632 error:nil];
            }
            //不行用GB18030编码再解码一次
            if (!body) {
                body =[NSString stringWithContentsOfFile:filePath encoding:0x80000631 error:nil];
            }
            if (body) {
                body =[body stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                //替换换行符为HTML换行符
                [self.uiWebView loadHTMLString:body baseURL:nil];
            }
            else{
                [self.uiWebView loadRequest:[NSURLRequest requestWithURL:URL]];
            }
        }
        else{
            [self.uiWebView loadRequest:[NSURLRequest requestWithURL:URL]];
        }
        
    }
}

- (void)loadURLString:(NSString *)URLString {
    NSURL *URL = [NSURL URLWithString:URLString];
    [self loadURL:URL];
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.wkWebView) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.wkWebView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:animated];
        
        // Once complete, fade out UIProgressView
        if(self.wkWebView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}



#pragma mark - Fake Progress Bar Control (UIWebView)

- (void)fakeProgressViewStartLoading {
    [self.progressView setProgress:0.0f animated:NO];
    [self.progressView setAlpha:1.0f];
    
    if(!self.fakeProgressTimer) {
        self.fakeProgressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/60.0f target:self selector:@selector(fakeProgressTimerDidFire:) userInfo:nil repeats:YES];
    }
}

- (void)fakeProgressBarStopLoading {
    if(self.fakeProgressTimer) {
        [self.fakeProgressTimer invalidate];
    }
    
    if(self.progressView) {
        [self.progressView setProgress:1.0f animated:YES];
        [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.progressView setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [self.progressView setProgress:0.0f animated:NO];
        }];
    }
}

- (void)fakeProgressTimerDidFire:(id)sender {
    CGFloat increment = 0.005/(self.progressView.progress + 0.2);
    if([self.uiWebView isLoading]) {
        CGFloat progress = (self.progressView.progress < 0.75f) ? self.progressView.progress + increment : self.progressView.progress + 0.0005;
        if(self.progressView.progress < 0.95) {
            [self.progressView setProgress:progress animated:YES];
        }
    }
}

#pragma mark - External App Support

- (BOOL)externalAppRequiredToOpenURL:(NSURL *)URL {
    if (self.islocalhtml) {
        return NO;
    }
    NSSet *validSchemes = [NSSet setWithArray:@[@"http", @"https"]];
    return ![validSchemes containsObject:URL.scheme];
}

- (void)launchExternalAppWithURL:(NSURL *)URL {
    self.URLToLaunchWithPermission = URL;
    [self.externalAppPermissionAlertView show];
}

#pragma mark - UIBarButtonItem Target Action Methods

- (void)backButtonPressed:(id)sender {
    
    if(self.wkWebView) {
        [self.wkWebView goBack];
    }
    else if(self.uiWebView) {
        [self.uiWebView goBack];
    }
//    [self updateToolbarState];
}

-(void)updateToolbarState
{
    BOOL canGoBack = self.wkWebView.canGoBack || self.uiWebView.canGoBack;
//    BOOL canGoForward = self.wkWebView.canGoForward || self.uiWebView.canGoForward;
    self.btn_close.hidden = !canGoBack;
    if (canGoBack) {
        [self.navigationbar setleftBarButtonItemWithImage:[UIImage imageNamed:@"white_back_btn"] target:self selector:@selector(backButtonPressed:)];
    }
    else
    {
        [self.navigationbar.leftItem addTarget:self action:@selector(backtoparent:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if(self.wkWebView.loading || self.uiWebViewIsLoading) {
//        if(self.showsURLInNavigationBar) {
            NSString *URLString;
            if(self.wkWebView) {
                URLString = [self.wkWebView.URL absoluteString];
            }
            else if(self.uiWebView) {
                URLString = [self.uiWebViewCurrentURL absoluteString];
            }
            URLString = [URLString stringByReplacingOccurrencesOfString:@"http://" withString:@""];
            URLString = [URLString stringByReplacingOccurrencesOfString:@"https://" withString:@""];
            URLString = [URLString substringToIndex:[URLString length]-1];
            [self configBrowserTitle:URLString];
//        }
    }
    else {
//        if(self.showsPageTitleInNavigationBar) {
            if(self.wkWebView) {
                [self configBrowserTitle:self.wkWebView.title];
            }
            else if(self.uiWebView) {
                 NSString * title = [self.uiWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
                [self configBrowserTitle:title];
            }
        }
//    }
}
-(void)configBrowserTitle:(NSString *)htmltitle{

    if (self.browserTitle) {
        self.navigationbar.title = self.browserTitle;
    }else{
        self.navigationbar.title = htmltitle;
    }
}
#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if(webView == self.uiWebView) {
        
        if(![self externalAppRequiredToOpenURL:request.URL]) {
            self.uiWebViewCurrentURL = request.URL;
            self.uiWebViewIsLoading = YES;
            [self updateToolbarState];
            [self fakeProgressViewStartLoading];
            if([self.delegate respondsToSelector:@selector(webBrowser:didStartLoadingURL:)]) {
              return [self.delegate webBrowser:self didStartLoadingURL:request.URL];
            }
            return YES;
        }
        else {
            [self launchExternalAppWithURL:request.URL];
            return NO;
        }
    }
    return NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if(webView == self.uiWebView) {
        if(!self.uiWebView.isLoading) {
            self.uiWebViewIsLoading = NO;
            [self updateToolbarState];
            
            [self fakeProgressBarStopLoading];
        }
        
        if([self.delegate respondsToSelector:@selector(webBrowser:didFinishLoadingURL:)]) {
            [self.delegate webBrowser:self didFinishLoadingURL:self.uiWebView.request.URL];
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if(webView == self.uiWebView) {
        if(!self.uiWebView.isLoading) {
            self.uiWebViewIsLoading = NO;
            [self updateToolbarState];
            
            [self fakeProgressBarStopLoading];
        }
        if([self.delegate respondsToSelector:@selector(webBrowser:didFailToLoadURL:error:)]) {
            [self.delegate webBrowser:self didFailToLoadURL:self.uiWebView.request.URL error:error];
        }
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if(webView == self.wkWebView) {
        [self updateToolbarState];
        if([self.delegate respondsToSelector:@selector(webBrowser:didStartLoadingURL:)]) {
            [self.delegate webBrowser:self didStartLoadingURL:self.wkWebView.URL];
        }
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if(webView == self.wkWebView) {
        [self updateToolbarState];
        if([self.delegate respondsToSelector:@selector(webBrowser:didFinishLoadingURL:)]) {
            [self.delegate webBrowser:self didFinishLoadingURL:self.wkWebView.URL];
        }
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    if(webView == self.wkWebView) {
        [self updateToolbarState];
        if([self.delegate respondsToSelector:@selector(webBrowser:didFailToLoadURL:error:)]) {
            [self.delegate webBrowser:self didFailToLoadURL:self.wkWebView.URL error:error];
        }
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    if(webView == self.wkWebView) {
        [self updateToolbarState];
        if([self.delegate respondsToSelector:@selector(webBrowser:didFailToLoadURL:error:)]) {
            [self.delegate webBrowser:self didFailToLoadURL:self.wkWebView.URL error:error];
        }
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if(webView == self.wkWebView) {
        
        NSURL *URL = navigationAction.request.URL;
        if(![self externalAppRequiredToOpenURL:URL]) {
            if(!navigationAction.targetFrame) {
                [self loadURL:URL];
                decisionHandler(WKNavigationActionPolicyCancel);
                return;
            }
        }
        else if([[UIApplication sharedApplication] canOpenURL:URL]) {
            [self launchExternalAppWithURL:URL];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}



@end
