//
//  TestDataSources.swift
//  RDHCollectionViewGridLayoutDemo
//
//  Created by Richard Hodgkins on 16/03/2015.
//  Copyright (c) 2015 Rich H. All rights reserved.
//

import Foundation
import UIKit.UICollectionView

@objc final class TestDataSource: NSObject, UICollectionViewDataSource {
    
    class var CellID: String { return "CellID" }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type(of: self).CellID, for:indexPath) 
        cell.backgroundColor = UIColor.red
        return cell
    }
}
