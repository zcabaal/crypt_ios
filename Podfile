# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'
# Uncomment this line if you're using Swift
use_frameworks!

pod "AFNetworking", "~> 3.1"
pod "Lock", "~> 1.23"
pod "Lock-Facebook", "~> 2.2"
#pod "Lock-Twitter", "~> 1.1"
#pod 'BDBOAuth1Manager', '~> 2.0'
pod "JWTDecode", "~> 1.0"
pod "SimpleKeychain", "~> 0.7"
pod 'TWReverseAuth', '~> 0.1'
pod 'PSAlertView', '~> 2.0'
pod "Google/SignIn", "~> 2.0"
pod "MBProgressHUD", "~> 0.9"
pod "Alamofire", "~> 3.3"
pod "Obfuscator", "~> 2.0"
pod "SwiftValidator", "~> 3.0"
pod "Braintree", "~> 4.2"
pod "Stripe", "~> 6.2"
pod "Canvas", "~> 0.1"


target 'Crypt' do

end

target 'CryptTests' do

end

target 'CryptUITests' do

end

post_install do |installer|
  installer.pods_project.build_configuration_list.build_configurations.each do |configuration|
    configuration.build_settings['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'YES'
  end
end
