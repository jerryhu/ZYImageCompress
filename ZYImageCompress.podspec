Pod::Spec.new do |s|
  s.name         = "ZYImageCompress"
  s.version      = "1.1.0"
  s.summary      = "JPEG image compressor support with an UIImage category"

  s.description  = <<-DESC
                    This library provides a category for UIImage with support for compressing image
                    into a smaller size.
                   DESC

  s.homepage     = "https://github.com/jerryhu/ZYImageCompress"

  s.license      = "MIT"
  s.author             = { "Jerry Hu" => "jerryhunn@gmail.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/jerryhu/ZYImageCompress.git", :tag => "#{s.version}" }

  s.source_files  = "ZYImageCompress/**/*.{h,m}"
  s.framework  = "UIKit"
end
