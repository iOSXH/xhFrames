//
//  WebViewController.m
//  xianghui
//
//  Created by xianghui on 2018/10/13.
//  Copyright © 2018 xianghui. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>
#import "XHBaseNavView.h"

@interface WebViewController ()<WKNavigationDelegate,WKUIDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, assign) BOOL allowZoom;

@property (nonatomic, assign) BOOL refreshing;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) UIView *emptyView;

@end

@implementation WebViewController

- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress" context:nil];
    [self.webView removeObserver:self forKeyPath:@"title" context:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.allowZoom = YES;
    
    //1.创建配置项
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.selectionGranularity = WKSelectionGranularityDynamic;
    //1.1 设置偏好
    config.preferences = [[WKPreferences alloc] init];
    config.preferences.javaScriptEnabled = YES;
    if (@available(iOS 9.0,*)){
        config.requiresUserActionForMediaPlayback = NO;
    }
    config.allowsInlineMediaPlayback = YES;
    //1.1.1 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    config.processPool = [[WKProcessPool alloc] init];
    config.userContentController = [WKUserContentController new];
    
    //2.添加WKWebView
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    [self.webView configureForAutoLayout];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.navigationDelegate =self;
    self.webView.UIDelegate = self;
    self.webView.opaque = NO;
    self.webView.scrollView.delegate = self;
    self.webView.allowsBackForwardNavigationGestures = YES;
    [self.view addSubview:self.webView];
    [self.webView autoPinEdgesToSuperviewEdges];
    [self.view sendSubviewToBack:self.webView];
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
    
    [self startRefresh];
}


#pragma mark 刷新方法
- (void)startRefresh{
    if (!self.url) {
        self.title = @"地址错误";
        return;
    }
    
    self.refreshing = YES;
    self.error = nil;
//    self.title = @"加载中...";
    [self reloadEmptyView];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url];
    
    [self.webView loadRequest:request];
    
}


#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        
    }else if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView)
        {
            self.title = self.webView.title;
        }
        else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        
    }
    
}


#pragma mark webview 相关代理方法
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    
    [self updateNavItems];
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    self.allowZoom = NO;
    
    self.error = nil;
    self.refreshing = NO;
    [self reloadEmptyView];
    [self updateNavItems];
}



- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.error = nil;
    self.refreshing = NO;
    [self reloadEmptyView];
    [self updateNavItems];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    if (error.code == NSURLErrorCancelled) {
        
    }else{
        self.title = @"加载失败";
        self.error = error;
    }
    self.refreshing = NO;
    [self reloadEmptyView];
}

#pragma mark - - - - UIScrollViewDelegate - - - -

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if(self.allowZoom){
        return nil;
    }else{
        return self.webView.scrollView.subviews.firstObject;
    }
}

#pragma mark - WKWebview UIDelegate Methods
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler { // js 里面的alert实现，如果不实现，网页的alert函数无效
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:frame.request.URL.host message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (completionHandler) {
            completionHandler();
        }
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
    
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
    // js 里面的alert实现，如果不实现，网页的alert函数无效 ,
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:frame.request.URL.host message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (completionHandler) {
            completionHandler(YES);
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        if (completionHandler) {
            completionHandler(NO);
        }
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:frame.request.URL.host message:prompt preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (completionHandler) {
            completionHandler(alertController.textFields[0].text?:nil);
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        if (completionHandler) {
            completionHandler(nil);
        }
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}


#pragma mark updateNavItems
- (void)updateNavItems{
    
    
    
    XHBaseNavView *leftView = [[XHBaseNavView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backBtn setImage:kImageNamed(@"icon_nav_back") forState:UIControlStateNormal];
    
    
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0,-20,0,0);
    [backBtn addTarget:self action:@selector(backItemDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:backBtn];
    
    if (self.webView.canGoBack) {
        leftView.width = 88;
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(44, 0, 44, 44)];
        [closeBtn setImage:kImageNamed(@"icon_nav_close") forState:UIControlStateNormal];
        closeBtn.imageEdgeInsets = UIEdgeInsetsMake(0,-20,0,0);
        [closeBtn addTarget:self action:@selector(closeItemDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [leftView addSubview:closeBtn];
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
}

- (UIBarButtonItem *)createLeftBarButtonItemWithIconImage:(UIImage*)iconImage
                                                itemWidth:(CGFloat)itemWidth
                                                leftSpace:(CGFloat)leftSpace
                                                   action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 44/2 - itemWidth/2, itemWidth, itemWidth);
    //    button.backgroundColor = [UIColor blueColor];
    [button setTitle:nil forState:UIControlStateNormal];
    [button setImage:iconImage forState:UIControlStateNormal];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, leftSpace, 0, -leftSpace)];
    
    if (action) {
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButtonItem;
}


- (void)backItemDidClicked:(id)sender{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        [self closeItemDidClicked:sender];
    }
}

- (void)closeItemDidClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemDidClicked:(id)sender{
    
}


#pragma mark Empty Loading View
- (UIView *)emptyView{
    if (!_emptyView) {
        _emptyView = [UIView newAutoLayoutView];
        _emptyView.backgroundColor = [UIColor clearColor];
        
        UIButton *centerBtn = [UIButton newAutoLayoutView];
        centerBtn.backgroundColor = [UIColor clearColor];
        centerBtn.titleLabel.numberOfLines = 0;
        centerBtn.tag = 10;
        [_emptyView addSubview:centerBtn];
        [centerBtn autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH/2, 100)];
        [centerBtn autoCenterInSuperview];
    }
    return _emptyView;
}

- (void)emptyViewDidClicked:(id)sender{
    if (self.refreshing) {
        return;
    }
    [self startRefresh];
}

- (void)reloadEmptyView{
    
    BOOL isEmpty = YES;
    if (!self.refreshing && !self.error) {
        isEmpty = NO;
    }else{
        isEmpty = YES;
    }
    
    if (isEmpty) {
        
        if (!self.emptyView.superview) {
            [self.view addSubview:self.emptyView];
            [self.emptyView autoPinEdgesToSuperviewEdges];
        }
        
        UIButton *centerBtn = [self.emptyView viewWithTag:10];
        
        NSString *text = self.error?@"加载数据失败，请稍后重试":@"加载成功";
        if (self.refreshing) {
            text = @"加载中...";
        }
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:12.0f], NSForegroundColorAttributeName: [UIColor lightGrayColor]};
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:text attributes:attribute];
        [centerBtn setAttributedTitle:attStr forState:UIControlStateNormal];
        
    }else{
        if (self.emptyView.superview) {
            [self.emptyView removeFromSuperview];
        }
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
