require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name             = 'Rudder-Adobe'
  s.version          = package['version']
  s.summary          = 'Privacy and Security focused Segment-alternative. Adobe Analytics Native SDK integration support.'

  s.description      = <<-DESC
Rudder is a platform for collecting, storing and routing customer event data to dozens of tools. Rudder is open-source, can run in your cloud environment (AWS, GCP, Azure or even your data-centre) and provides a powerful transformation framework to process your event data on the fly.
                       DESC

  s.homepage         = 'https://github.com/rudderlabs/rudder-integration-adobe-ios'
  s.license          = { :type => "ELv2", :file => "LICENSE.md" }
  s.author           = { 'RudderStack' => 'venkat@rudderstack.com' }
  s.source           = { :git => 'https://github.com/rudderlabs/rudder-integration-adobe-ios.git', :tag => "v#{s.version}" }
  s.platform         = :ios, "9.0"

  ## Ref: https://github.com/CocoaPods/CocoaPods/issues/10065
  s.pod_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

  s.source_files = 'Rudder-Adobe/Classes/**/*'

  s.static_framework = true

  s.dependency 'Rudder'
  
  s.ios.deployment_target = '8.0'
  

  s.ios.dependency 'AdobeMobileSDK'
  
  s.dependency 'AdobeVideoHeartbeatSDK'


end
