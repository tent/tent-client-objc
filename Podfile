source 'https://github.com/CocoaPods/Specs.git'
inhibit_all_warnings!

xcodeproj 'Support/TentClient.xcodeproj'

def common_pods
  podspec :path => 'TentClient.podspec'
end

target :ios do
  platform :ios, '7.0'
  link_with 'libtentclient'

  common_pods
end

target :osx_10_9 do
  platform :osx, '10.9'
  link_with 'TentClient'

  common_pods
end
