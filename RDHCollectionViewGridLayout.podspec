Pod::Spec.new do |s|
    s.name = 'RDHCollectionViewGridLayout'
    s.version = '1.2.4'
    s.license = 'MIT'
    
    s.summary = 'Grid layout for UICollectionView.'
    s.homepage = 'https://github.com/rhodgkins/RDHCollectionViewGridLayout'
    s.author = 'Rich Hodgkins'
    s.source = { :git => 'https://github.com/rhodgkins/RDHCollectionViewGridLayout.git', :tag => s.version.to_s }
    s.social_media_url = 'https://twitter.com/rhodgkins'

    s.frameworks = 'Foundation', 'UIKit', 'CoreGraphics'
    s.requires_arc = true
    
    s.ios.deployment_target = '6.0'
    s.tvos.deployment_target = '9.0'
    s.source_files = 'RDHCollectionViewGridLayout/'
end
