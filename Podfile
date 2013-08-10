inhibit_all_warnings!

def common_pods
  pod 'Hawk', :podspec => 'https://raw.github.com/tent/hawk-objc/master/Hawk.podspec'
end

target :ios do
  platform :ios, '7.0'
  link_with 'libtentclient'

  common_pods
end

target :osx_10_8 do
  platform :osx, '10.8'
  link_with 'TentClient'

  common_pods
end
