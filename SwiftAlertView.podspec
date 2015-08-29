Pod::Spec.new do |s|

  s.name         = "SwiftAlertView"
  s.version      = "1.2.0"
  s.summary      = "A powerful customizable Alert View written in Swift."
  s.description  = <<-DESC
                   SwiftAlertView is a powerful customizable Alert View written in Swift. With SwiftAlertView, you can easily make your desired Alert View in some lines of code.
                   DESC

  s.homepage     = "https://github.com/dinhquan/SwiftAlertView"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'Dinh Quan' => 'dinhquan191@gmail.com' }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/dinhquan/SwiftAlertView.git", :tag => "1.2.0" }
  s.source_files  = 'SwiftAlertView', 'SwiftAlertView/**/*.swift'
  s.ios.deployment_target = "8.0"

end
