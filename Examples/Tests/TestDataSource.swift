//
//  TestDataSource.swift
//  RDHCollectionViewGridLayoutDemo
//
//  Created by Richard Hodgkins on 16/03/2015.
//  Copyright (c) 2015 Rich H. All rights reserved.
//

import Foundation
import UIKit.UICollectionView

@objc public class TestDataSource: NSObject, UICollectionViewDataSource {
    
    public class var CellID: String { return "CellID" }
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.dynamicType.CellID, forIndexPath:indexPath) 
        cell.backgroundColor = UIColor.redColor()
        return cell
    }
}