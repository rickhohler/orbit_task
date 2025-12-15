#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint orbit_task.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'orbit_task'
  s.version          = '0.0.1'
  s.summary          = 'The Next Generation Task Scheduler for Flutter.'
  s.description      = <<-DESC
The Next Generation Task Scheduler for Flutter. Orchestrate background execution seamlessly across Android, iOS, and Web.
                       DESC
  s.homepage         = 'https://github.com/rickhohler/orbit_task'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Rick Hohler' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Sources/orbit_task/**/*'
  s.priority         = 1000
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
