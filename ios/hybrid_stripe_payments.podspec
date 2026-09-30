#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint hybrid_stripe_payments.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'hybrid_stripe_payments'
  s.version          = '1.0.0'
  s.summary          = 'Hybrid Stripe Payments flutter plugin.'
  s.description      = <<-DESC
Hybrid Stripe Payments Flutter Plugin.
                       DESC
  s.homepage         = 'https://rudo.es/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'hola@rudo.es' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'StripePaymentSheet'

  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.9'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'gula_stripe_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
