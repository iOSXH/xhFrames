# Uncomment this line to define a global platform for your project
# platform :ios, '8.0'
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

inhibit_all_warnings!

def common_pods
    
    pod 'AFNetworking'
    pod 'YTKNetwork'

    pod 'PureLayout'

    pod 'SDWebImage', '~> 3.7’
    pod 'lottie-ios'
    pod 'DZNEmptyDataSet'
    pod 'MBProgressHUD', '~> 1.1.0'
    
    pod 'YYKit'
    pod 'BlocksKit'

    pod 'CocoaLumberjack'

    pod 'WebViewJavascriptBridge', '~> 6.0'
    pod 'MJRefresh'
    pod 'KMNavigationBarTransition'

    pod 'SakuraKit'
    
end

def xh_pods
    
    pod 'UICKeyChainStore'
    
    pod 'UMCCommon'
    pod 'UMCSecurityPlugins'

    pod 'UMCAnalytics'
    pod 'UMCPush'
    pod 'UMCShare/Social/WeChat'
	
    pod 'Bugly'
  
#  pod 'MLeaksFinder'
end

target 'xhFrames' do
    common_pods
    xh_pods
end
