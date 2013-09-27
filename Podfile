inhibit_all_warnings!

def common_pods
  pod 'Hawk', :podspec => 'https://raw.github.com/tent/hawk-objc/master/Hawk.podspec'
  pod 'AFNetworking', '2.0.0-RC3'
  pod 'Mantle', '1.3'
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
