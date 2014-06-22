Pod::Spec.new do |s|
    s.name = 'RDHCollectionViewGridLayout'
    s.version = '1.1.2'
    s.license = 'MIT'
    
    s.summary = 'Grid layout for UICollectionView.'
    s.homepage = 'https://github.com/rhodgkins/RDHCollectionViewGridLayout'
    s.author = 'Rich Hodgkins'
    s.source = { :git => 'https://github.com/rhodgkins/RDHCollectionViewGridLayout.git', :tag => s.version.to_s }
    s.docset_url = "http://cocoadocs.org/docsets/RDHCollectionViewGridLayout/xcode-docset.atom"
    s.screenshots = [ "https://github.com/rhodgkins/RDHCollectionViewGridLayout/raw/master/Examples/images/5-line,%2010-item.png", 
                      "https://github.com/rhodgkins/RDHCollectionViewGridLayout/raw/master/Examples/images/vertical.png",
                      "https://github.com/rhodgkins/RDHCollectionViewGridLayout/blob/master/Examples/images/horizontal.png" ]

    s.frameworks = 'UIKit', 'CoreGraphics'
    s.requires_arc = true
    
    s.ios.deployment_target = '6.0'
    s.source_files = 'RDHCollectionViewGridLayout/'
end
