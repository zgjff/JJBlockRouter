@version = "0.0.6"
Pod::Spec.new do |spec|
  spec.name         = "JJBlockRouter"
  spec.version      = @version
  spec.summary      = "Swift的简单好用、支持block回调、转发、拦截功能的路由框架"
  spec.description  = "适用于Swift的简单好用、支持block回调、转发、拦截功能的路由框架."
  spec.homepage     = "https://github.com/zgjff/JJBlockRouter"
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { "zgjff" => "zguijie1005@163.com" }
  spec.source       = { :git => "https://github.com/zgjff/JJBlockRouter.git", :tag => "#{spec.version}" }

  spec.subspec 'AlertPresentation' do |alert|
    alert.source_files = "Sources/AlertPresentation/*.{swift}"
  end

  spec.subspec 'Router' do |router|
    router.source_files = "Sources/Router/*.{swift}"
  end

  spec.subspec 'Extension' do |extension|
    extension.source_files = "Sources/Extension/*.{swift}"
  end

  spec.platform     = :ios, "9.0"
  spec.swift_version = '5.0'
end