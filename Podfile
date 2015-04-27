source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '8.0'

inhibit_all_warnings!

xcodeproj 'Lunr iOS'

pod 'AFNetworking', '~> 2.5'
pod 'AFNetworking-Synchronous/2.x'
pod 'AFNetworkActivityLogger', '~> 2.0'

pod 'MagicalRecord/Shorthand'



post_install do |installer|
  target = installer.project.targets.find{|t| t.to_s == "Pods-MagicalRecord"}
    target.build_configurations.each do |config|
        s = config.build_settings['GCC_PREPROCESSOR_DEFINITIONS']
        s = [ '$(inherited)' ] if s == nil;
        s.push('MR_ENABLE_ACTIVE_RECORD_LOGGING=0') if config.to_s == "Debug";
        config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] = s
    end
end