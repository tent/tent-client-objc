Pod::Spec.new do |s|
  s.name     = 'TentClient'
  s.version  = '0.0.1'
  s.license  = { :type => 'BSD', :file => 'LICENCE' }
  s.summary  = 'Objective-C Tent client library.'
  s.homepage = 'https://github.com/tent/tent-client-objc'
  s.authors  = { 'Jesse Stuart' => 'jesse@jessestuart.ca' }
  s.source   = { :git => 'https://github.com/tent/tent-client-objc.git' }
  s.requires_arc = true

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.9'

  s.source_files = 'TentClient/**/*.{h,m}'

  s.dependency 'Hawk'
  s.dependency 'AFNetworking', '2.0.0-RC3'
end
