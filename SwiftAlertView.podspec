Pod::Spec.new do |s|

  s.name         = "SwiftAlertView"
  s.version      = "2.2.1"
  s.summary      = "A powerful customizable Alert View written in Swift."
  s.description  = <<-DESC
                   SwiftAlertView is a powerful customizable Alert View written in Swift. With SwiftAlertView, you can easily make your desired Alert View in some lines of code.
                   DESC

  s.homepage     = "https://github.com/dinhquan/SwiftAlertView"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'Dinh Quan' => 'dinhquan191@gmail.com' }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/dinhquan/SwiftAlertView.git", :tag => s.version }
  s.source_files = 'Source/*.swift'
  s.ios.deployment_target = "10.0"
  s.swift_version = "5.0"

end
