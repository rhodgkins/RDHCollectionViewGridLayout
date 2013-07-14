Pod::Spec.new do |s|
  s.name = 'RDHCollectionViewGridLayout'
  s.version = '0.0.1'
  s.license = 'MIT'
  
  s.summary = 'Grid layout for UICollectionView'
  s.homepage = 'https://github.com/rhodgkins/RDHCollectionViewGridLayout'
  s.author = 'Rich Hodgkins'
  s.source = { :git => 'https://github.com/rhodgkins/RDHCollectionViewGridLayout.git', :tag => s.version.to_s }
  
  s.source_files = 'RDHCollectionViewGridLayout/'
  s.frameworks = 'UIKit', 'Foundation', 'CoreGraphics'
  s.requires_arc = true
  
  s.preferred_dependency = 'Core'
  
  s.subspec 'Core' do |c|
    c.platform = :ios, '6.0'
  end
  
  s.subspec 'PST' do |pst|
    pst.platform = :ios, '5.1'
    pst.dependency 'PSTCollectionView'
    pst.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'RDH_USING_PSTCOLLECTIONVIEW' }
  end

end
