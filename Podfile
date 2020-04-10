# 最低版本
platform :ios, '9.0'

# 禁止警告
inhibit_all_warnings!

# 公有仓库
source 'https://github.com/CocoaPods/Specs.git'

target 'GomokuPlay' do

    # 自动布局框架
    pod 'Masonry', '~> 1.1.0'
    # 离散网络请求框架
    pod 'YTKNetwork', '~>2.0.4', :inhibit_warnings => true
    # 集约网络请求框架
    pod 'AFNetworking', '~>3.2.1', :inhibit_warnings => true
    # 即时通讯网络框架
    pod 'CocoaAsyncSocket', '~> 7.6.3'
    # 图片加载框架
    pod 'SDWebImage', '~> 4.2.2'
    # 字典和模型转换框架
    pod 'MJExtension', '~> 3.0.13'
    # 弹出进度提示框
    pod 'MBProgressHUD', '~> 1.0.0'
    pod 'SVProgressHUD', '~> 2.2.5'
    # 弹出提示信息框
    pod 'Toast', '~> 4.0.0'
    # 公有仓库 - 导航栏按钮位置偏移的解决方案
    pod 'UINavigation-SXFixSpace', '~> 1.2.4'

end

# 删除警告
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 8.0
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
            end
        end
    end
end




