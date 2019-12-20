

Pod::Spec.new do |s|

  s.name         = "SwiftShellFramework"
  s.version      = "0.0.5"
  s.summary      = "A short description of SwiftShellFramework."

  s.description  = <<-DESC
  SwiftShellFramework
                   DESC

  s.homepage     = "ssh://git@appgit.yealink.com:10022/zenglm/SwiftShellFramework"


  s.license      = "MIT"


  s.author             = { "zlm" => "zenglm@yealink.com" }


   s.platform     = :osx, "10.13"
  # s.platform     = :ios, "5.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  #s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"


  s.source       = { :git => "ssh://git@appgit.yealink.com:10022/zenglm/SwiftShellFramework.git", :tag => "#{s.version}" }
  s.frameworks = "Cocoa", "Foundation"

  s.source_files  = "SwiftShellFramework", "SwiftShellFramework/**/*.{swift,h,m}"
  s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"



end
