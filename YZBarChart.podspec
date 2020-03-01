Pod::Spec.new do |s|

   s.platform = :ios
   s.ios.deployment_target = '11.0'
   s.name = "YZBarChart"
   s.summary = "YZBarChart this is simple bar chart view"
   s.requires_arc = true

   s.version = "1.2.0"

   s.author = { "Yaroslav Zavyalov" => "yaroslavzavyalov1@gmail.com" }

   s.homepage = "https://github.com/YarZav/YZBarChart"

   s.source = { :git => "https://github.com/YarZav/YZBarChart.git", :tag => "#{s.version}"}

   s.framework = "UIKit"

   s.source_files = "YZBarChart/**/*.{swift}"

   s.resources = "YZBarChart/**/*.{png,jpeg,jpg,storyboard,xib}"
   s.resource_bundles = {
    'YZBarChart' => ['YZBarChart/**/*.xcassets']
   }
end
