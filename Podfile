# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'CrossFitTracker' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod 'ReactiveCocoa', '~> 5.0.0'
  pod 'ReactiveSwift', :git => 'https://github.com/ReactiveCocoa/ReactiveSwift.git', :branch => 'signal-deadlock-fix'
  pod 'Alamofire', '~> 4.0'
  pod 'SnapKit', '~> 3.2.0'

  target 'CrossFitTrackerTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
