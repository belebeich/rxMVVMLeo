# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'rxMVVMLeo' do
    pod 'RxSwift',    '~> 4.0'
    pod 'RxCocoa',    '~> 4.0'
    pod 'SwiftyJSON'
    pod 'Alamofire'
    pod 'RxAlamofire'
    pod 'KeychainSwift'
end

target 'rxMVVMLeoiOS' do
    pod 'RxSwift',    '~> 4.0'
    pod 'RxCocoa',    '~> 4.0'
    pod 'SwiftyJSON'
    pod 'Alamofire'
    pod 'RxAlamofire'
    pod 'KeychainSwift'
    pod 'RxAnimated'
    pod 'RxDataSources'
end

target 'rxMVVMLeoToday' do
    pod 'RxSwift',    '~> 4.0'
    pod 'RxCocoa',    '~> 4.0'
    pod 'SwiftyJSON'
    pod 'Alamofire'
    pod 'RxAlamofire'
    pod 'KeychainSwift'
end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
