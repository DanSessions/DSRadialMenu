#
# Be sure to run `pod lib lint DSRadialMenu.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "DSRadialMenu"
  s.version          = "0.5.0"
  s.summary          = "DSRadialMenu is a menu with a radial layout. It allows you to add menu items that will appear from behind a center button."
  s.description      = <<-DESC
                        DSRadialMenu allows you to add menu items that appear from behind a center button. Menu items can be shown by specifying a position that relates to the hours on a clock face.
                       DESC
  s.homepage         = "https://github.com/DanSessions/DSRadialMenu"
  s.license          = 'MIT'
  s.author           = { "Dan Sessions" => "dansessions@gmail.com" }
  s.source           = { :git => "https://github.com/DanSessions/DSRadialMenu.git", :tag => s.version.to_s }

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  #s.resource_bundles = {
  #  'DSRadialMenu' => ['Pod/Assets/*.png']
  #}

end
