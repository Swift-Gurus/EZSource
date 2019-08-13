#
# Be sure to run `pod lib lint EZSource.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EZSource'
  s.version          = '0.2.8'
  s.summary          = 'Declarative Datasource/Delegate for TableView'


  s.description      = <<-DESC
  This library helps to avoid boilerplate code when operating with TableView. Just create Rows add them
  to sections. Append Headers/Footers to sections and use reload or updateWithAnimation
                       DESC

  s.homepage         = 'https://github.com/aldo-dev/EZSource.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ALDO Inc' => 'aldodev@aldogroup.com' }
  s.source           = { :git => 'https://github.com/aldo-dev/EZSource.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.swift_version   = '5.0'

  s.source_files = 'EZSource/Classes/**/*'
  s.dependency 'SwiftyCollection'

end
