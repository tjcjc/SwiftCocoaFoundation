# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
plugin 'cocoapods-binary'
install! 'cocoapods', :disable_input_output_paths => true

target 'SwiftCocoaFoundation' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SwiftCocoaFoundation
  pod 'SwiftProtobuf', '~> 1.0', :binary => true

  target 'SwiftCocoaFoundationTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Quick', :binary => true
    pod 'Nimble', :binary => true
  end

  # target 'SwiftCocoaFoundationUITests' do
  #   # Pods for testing
  #   pod 'Quick'
  #   pod 'Nimble'
  # end

end
