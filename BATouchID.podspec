Pod::Spec.new do |s|
    s.name         = 'BATouchID'
    s.version      = '1.0.0'
s.summary      = 'git 最全面的指纹解锁封装和支付宝指纹登录逻辑处理！'
    s.homepage     = 'https://github.com/BAHome/BATouchID'
    s.license      = 'MIT'
    s.authors      = { 'boai' => 'sunboyan@outlook.com' }
    s.platform     = :ios, '7.0'
    s.source       = { :git => 'https://github.com/BAHome/BATouchID.git', :tag => s.version.to_s }
    s.source_files = 'BATouchID/BATouchID/*.{h,m}'
    s.requires_arc = true
end
