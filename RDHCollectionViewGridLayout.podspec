Pod::Spec.new do |s|
  s.name = 'RDHCollectionViewGridLayout'
  s.version = '0.0.1'
  s.license = 'MIT'
  s.platform = :ios, '6.0'
  
  s.summary = 'Grid layout for UICollectionView'
  s.homepage = 'https://github.com/rhodgkins/RDHCollectionViewGridLayout'
  s.author = 'Rich Hodgkins'
  s.source = { :git => 'https://github.com/rhodgkins/RDHCollectionViewGridLayout.git', :tag => s.version.to_s }
  
  s.source_files = 'RDHCollectionViewGridLayout/'
  s.frameworks = 'UIKit', 'Foundation', 'CoreGraphics'
  s.requires_arc = true
end
