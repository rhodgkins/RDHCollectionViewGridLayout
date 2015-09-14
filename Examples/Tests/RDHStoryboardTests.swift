//
//  RDHStoryboardTests.swift
//  RDHCollectionViewGridLayoutDemo
//
//  Created by Richard Hodgkins on 16/03/2015.
//  Copyright (c) 2015 Rich H. All rights reserved.
//

import UIKit
import XCTest


class RDHStoryboardTests: XCTestCase {
    
    var collectionView: UICollectionView!
    var dataSource: TestDataSource!
    var layout: RDHCollectionViewGridLayout!
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()
        
        dataSource = TestDataSource()
        
        let collectionVC = UIStoryboard(name: "TestStoryboard", bundle: NSBundle(forClass: self.dynamicType)).instantiateInitialViewController() as! UICollectionViewController
        
        window = UIWindow(frame:CGRect(x: 0, y: 0, width: 640, height: 640))
        collectionView = collectionVC.collectionView
        layout = collectionView.collectionViewLayout as! RDHCollectionViewGridLayout
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: TestDataSource.CellID)
        collectionView.dataSource = dataSource
        collectionView.delegate = nil
        
        window.rootViewController = collectionVC
        window.makeKeyAndVisible()
    }
    
    private func updateWindowFrame() {
        var frame = CGRect.zero
        if layout.scrollDirection == .Vertical {
            frame.size.width = 640
            frame.size.height = 2000
        } else {
            frame.size.width = 2000
            frame.size.height = 640
        }
        window.frame = frame
        window.layoutIfNeeded()
        collectionView.frame = frame
        collectionView.layoutIfNeeded()
    }
    
    func testDefaults() {
        
        updateWindowFrame()
    }
}
