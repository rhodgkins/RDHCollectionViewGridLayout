//
//  RDHEmptyGridLayoutTests.swift
//  RDHCollectionViewGridLayoutDemo
//
//  Created by Richard Hodgkins on 22/06/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

import UIKit
import XCTest

final class RDHEmptyGridLayoutTests : XCTestCase {

    private var collectionView: UICollectionView!
    private var layout: RDHCollectionViewGridLayout!
    private let dataSource = EmptyTestDataSource()
    private var window: UIWindow!

    override func setUp() {
        super.setUp()
        
        window = UIWindow(frame: CGRect(x: 0, y: 0, width: 640, height: 640))
        window.makeKeyAndVisible()
        layout = RDHCollectionViewGridLayout()
        let controller = UICollectionViewController(collectionViewLayout: layout)
        controller.edgesForExtendedLayout = []
        controller.automaticallyAdjustsScrollViewInsets = false
        collectionView = controller.collectionView
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: TestDataSource.CellID)
        collectionView.dataSource = dataSource
        collectionView.delegate = nil
        window.rootViewController = controller
    }

    func testParameters() {
        layout.scrollDirection = .horizontal
        XCTAssertEqual(layout.scrollDirection, .horizontal, "Scroll direction should be horiztonal")
        
        layout.scrollDirection = .horizontal
        XCTAssertFalse(layout.value(forKeyPath: "verticalScrolling") as! Bool)
        layout.scrollDirection = .vertical
        XCTAssertTrue(layout.value(forKeyPath: "verticalScrolling") as! Bool)
        
        layout.setValue(true, forKey: "verticalScrolling")
        XCTAssertEqual(layout.scrollDirection, .vertical, "Scroll direction should be vertical")
        layout.setValue(false, forKey: "verticalScrolling")
        XCTAssertEqual(layout.scrollDirection, .horizontal, "Scroll direction should be horiztonal")
        
        layout.lineSize = 123
        XCTAssertEqual(layout.lineSize, 123, "Line size is incorrect")
        XCTAssertEqual(layout.lineMultiplier, 1, "Line multiplier should be default")
        XCTAssertEqual(layout.lineExtension, 0, "Line extension should be default")
        
        layout.lineMultiplier = 2
        XCTAssertEqual(layout.lineSize, 0, "Line size should be default")
        XCTAssertEqual(layout.lineMultiplier, 2, "Line multiplier is incorrect")
        XCTAssertEqual(layout.lineExtension, 0, "Line extension should be default")
        
        layout.lineExtension = 200
        XCTAssertEqual(layout.lineSize, 0, "Line size should be default")
        XCTAssertEqual(layout.lineMultiplier, 1, "Line multiplier should be default")
        XCTAssertEqual(layout.lineExtension, 200, "Line extension is incorrect")
        
        layout.lineExtension = 0
        XCTAssertEqual(layout.lineSize, 0, "Line size should be default")
        XCTAssertEqual(layout.lineMultiplier, 1, "Line multiplier should be default")
        XCTAssertEqual(layout.lineExtension, 0, "Line extension should be default")

        layout.lineDimension = 123
        XCTAssertEqual(layout.lineSize, 123, "Line size is incorrect")
        XCTAssertEqual(layout.lineMultiplier, 1, "Line multiplier should be default")
        XCTAssertEqual(layout.lineExtension, 0, "Line extension should be default")
        
        layout.lineItemCount = 7
        XCTAssertEqual(layout.lineItemCount, 7, "Line item count should be 7")
        
        layout.itemSpacing = 23
        XCTAssertEqual(layout.itemSpacing, 23, "Line spacing should be 23")
        
        layout.sectionsStartOnNewLine = true
        XCTAssertTrue(layout.sectionsStartOnNewLine, "Sections should start on new lines")
    }

    func updateWindowFrame() {

        var frame = CGRect.zero
        if (layout.scrollDirection == .vertical) {
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

    func testSizeLocationsWithVerticalScrollViewSectionsStartOnNewLineFalse() {

        layout.itemSpacing = 0
        layout.lineSpacing = 0
        layout.lineSize = 120
        layout.lineItemCount = 2
        layout.scrollDirection = .vertical
        layout.sectionsStartOnNewLine = false
        updateWindowFrame()
        
        checkFrames()
    }

    func testSizeLocationsWithHorizontalScrollViewSectionsStartOnNewLineFalse() {

        layout.itemSpacing = 0
        layout.lineSpacing = 0
        layout.lineSize = 120
        layout.lineItemCount = 2
        layout.scrollDirection = .horizontal
        layout.sectionsStartOnNewLine = false
        updateWindowFrame()

        checkFrames()
    }

    func testSizeLocationsWithVerticalScrollViewSectionsStartOnNewLineTrue() {

        layout.itemSpacing = 0
        layout.lineSpacing = 0
        layout.lineSize = 120
        layout.lineItemCount = 2
        layout.scrollDirection = .vertical
        layout.sectionsStartOnNewLine = true
        updateWindowFrame()
        
        checkFrames()
    }

    func testSizeLocationsWithHorizontalScrollViewSectionsStartOnNewLineTrue() {

        layout.itemSpacing = 0
        layout.lineSpacing = 0
        layout.lineSize = 120
        layout.lineItemCount = 2
        layout.scrollDirection = .horizontal
        layout.sectionsStartOnNewLine = true
        updateWindowFrame()
        
        checkFrames()
    }

    func testMultiplierDimensionLocationsWithVerticalScrollViewSectionsStartOnNewLineFalse() {

        layout.itemSpacing = 0
        layout.lineSpacing = 0
        layout.lineMultiplier = 0.5
        layout.lineItemCount = 2
        layout.scrollDirection = .vertical
        layout.sectionsStartOnNewLine = false
        updateWindowFrame()
        
        checkFrames()
    }

    func testMultiplierDimensionLocationsWithHorizontalScrollViewSectionsStartOnNewLineFalse() {

        layout.itemSpacing = 0
        layout.lineSpacing = 0
        layout.lineMultiplier = 0.5
        layout.lineItemCount = 2
        layout.scrollDirection = .horizontal
        layout.sectionsStartOnNewLine = false
        updateWindowFrame()
        
        checkFrames()
    }

    func testMultiplierDimensionLocationsWithVerticalScrollViewSectionsStartOnNewLineTrue() {

        layout.itemSpacing = 0
        layout.lineSpacing = 0
        layout.lineMultiplier = 0.5
        layout.lineItemCount = 2
        layout.scrollDirection = .vertical
        layout.sectionsStartOnNewLine = true
        updateWindowFrame()
        
        checkFrames()
    }

    func testMultiplierDimensionLocationsWithHorizontalScrollViewSectionsStartOnNewLineTrue() {

        layout.itemSpacing = 0
        layout.lineSpacing = 0
        layout.lineMultiplier = 0.5
        layout.lineItemCount = 2
        layout.scrollDirection = .horizontal
        layout.sectionsStartOnNewLine = true
        updateWindowFrame()
        
        checkFrames()
    }

    func testExtensionDimensionLocationsWithVerticalScrollViewSectionsStartOnNewLineFalse() {

        layout.itemSpacing = 0
        layout.lineSpacing = 0
        layout.lineExtension = 50
        layout.lineItemCount = 2
        layout.scrollDirection = .vertical
        layout.sectionsStartOnNewLine = false
        updateWindowFrame()
        
        checkFrames()
    }

    func testExtensionDimensionLocationsWithHorizontalScrollViewSectionsStartOnNewLineFalse() {

        layout.itemSpacing = 0
        layout.lineSpacing = 0
        layout.lineExtension = 50
        layout.lineItemCount = 2
        layout.scrollDirection = .horizontal
        layout.sectionsStartOnNewLine = false
        updateWindowFrame()
        
        checkFrames()
    }

    func testExtensionDimensionLocationsWithVerticalScrollViewSectionsStartOnNewLineTrue() {

        layout.itemSpacing = 0
        layout.lineSpacing = 0
        layout.lineExtension = 50
        layout.lineItemCount = 2
        layout.scrollDirection = .vertical
        layout.sectionsStartOnNewLine = true
        updateWindowFrame()
        
        checkFrames()
    }

    func testExtensionWithHorizontalScrollViewSectionsStartOnNewLineTrue() {

        layout.itemSpacing = 0
        layout.lineSpacing = 0
        layout.lineExtension = 50
        layout.lineItemCount = 2
        layout.scrollDirection = .horizontal
        layout.sectionsStartOnNewLine = true
        updateWindowFrame()
        
        checkFrames()
    }

    func testAutomaticDimensionLocationsWithVerticalScrollViewSectionsStartOnNewLineFalse() {

        layout.itemSpacing = 0
        layout.lineSpacing = 0
        layout.lineSize = 0
        layout.lineItemCount = 2
        layout.scrollDirection = .vertical
        layout.sectionsStartOnNewLine = false
        updateWindowFrame()
        
        checkFrames()
    }

    func testAutomaticDimensionLocationsWithHorizontalScrollViewSectionsStartOnNewLineFalse() {

        layout.itemSpacing = 0
        layout.lineSpacing = 0
        layout.lineSize = 0
        layout.lineItemCount = 2
        layout.scrollDirection = .horizontal
        layout.sectionsStartOnNewLine = false
        updateWindowFrame()
        
        checkFrames()
    }

    func testAutomaticDimensionLocationsWithVerticalScrollViewSectionsStartOnNewLineTrue() {

        layout.itemSpacing = 0
        layout.lineSpacing = 0
        layout.lineSize = 0
        layout.lineItemCount = 2
        layout.scrollDirection = .vertical
        layout.sectionsStartOnNewLine = true
        updateWindowFrame()
        
        checkFrames()
    }

    func testAutomaticWithHorizontalScrollViewSectionsStartOnNewLineTrue() {

        layout.itemSpacing = 0
        layout.lineSpacing = 0
        layout.lineSize = 0
        layout.lineItemCount = 2
        layout.scrollDirection = .horizontal
        layout.sectionsStartOnNewLine = true
        updateWindowFrame()
        
        checkFrames()
    }

    func testDirtyPixelCalculationsVerticalScrolling() {

        layout.itemSpacing = 0
        layout.lineSpacing = 0
        layout.lineSize = 0
        layout.lineItemCount = 3
        layout.scrollDirection = .vertical
        layout.sectionsStartOnNewLine = false
        updateWindowFrame()
        
        checkFrames()
    }

    func testDirtyPixelCalculationsHorizontalScrolling() {

        layout.itemSpacing = 0
        layout.lineSpacing = 0
        layout.lineSize = 0
        layout.lineItemCount = 3
        layout.scrollDirection = .horizontal
        layout.sectionsStartOnNewLine = false
        updateWindowFrame()
        
        checkFrames()
    }

    func testItemSpacingWithVerticalScrolling() {

        layout.itemSpacing = 2
        layout.lineSpacing = 0
        layout.lineSize = 0
        layout.lineItemCount = 3
        layout.scrollDirection = .vertical
        layout.sectionsStartOnNewLine = false
        updateWindowFrame()
        
        checkFrames()
    }

    func testItemSpacingWithHorizontalScrolling() {

        layout.itemSpacing = 2
        layout.lineSpacing = 0
        layout.lineSize = 0
        layout.lineItemCount = 3
        layout.scrollDirection = .horizontal
        layout.sectionsStartOnNewLine = false
        updateWindowFrame()
        
        checkFrames()
    }

    func testLineSpacingVerticalScrolling() {

        layout.itemSpacing = 0
        layout.lineSpacing = 10
        layout.lineSize = 0
        layout.lineItemCount = 2
        layout.scrollDirection = .vertical
        layout.sectionsStartOnNewLine = false
        updateWindowFrame()
        
        checkFrames()
    }

    func testLineSpacingHorizontalScrolling() {

        layout.itemSpacing = 0
        layout.lineSpacing = 10
        layout.lineSize = 0
        layout.lineItemCount = 2
        layout.scrollDirection = .horizontal
        layout.sectionsStartOnNewLine = false
        updateWindowFrame()
        
        checkFrames()
    }

    func testItemAndLineSpacingVerticalScrolling() {

        layout.itemSpacing = 2
        layout.lineSpacing = 10
        layout.lineSize = 0
        layout.lineItemCount = 3
        layout.scrollDirection = .vertical
        layout.sectionsStartOnNewLine = false
        updateWindowFrame()
        
        checkFrames()
    }

    func testItemAndLineSpacingHorizontalScrolling() {

        layout.itemSpacing = 2
        layout.lineSpacing = 10
        layout.lineSize = 0
        layout.lineItemCount = 3
        layout.scrollDirection = .horizontal
        layout.sectionsStartOnNewLine = false
        updateWindowFrame()
        
        checkFrames()
    }

    func checkFrames() {

        let exp = expectation(description: "Frame checking")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            var frame = CGRect.zero
            var size = CGSize.zero
            if (self.layout.scrollDirection == .vertical) {
                frame.size.width = 640
                frame.size.height = 2000
                size.width = frame.size.width
            } else {
                frame.size.width = 2000
                frame.size.height = 640
                size.height = frame.size.height
            }
            XCTAssertEqual(self.window.frame, frame, "Incorrect window frame (\(self.testCaseName))")
            XCTAssertEqual(self.collectionView.contentSize, size, "Incorrect content size (\(self.testCaseName))")
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
