//
//  RDHCollectionViewGridLayout.h
//  RDHCollectionViewGridLayout
//
//  Created by Richard Hodgkins on 06/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

/* 
 * If we're using the PSTCollectionView library then create a macro to swap out the classes. Any *CollectionView* libraries should use this ommiting the UI/PST prefix.
 * e.g.
 * UICollectionView -> __RDH_COLLECTION_VIEW_LIB(CollectionView)
 * UICollectionViewLayoutAttribute -> __RDH_COLLECTION_VIEW_LIB(CollectionViewLayoutAttribute)
 * This is not needed for enums as they are just typedefs.
 */
#ifdef RDH_USING_PSTCOLLECTIONVIEW
    #import <PSTCollectionView/PSTCollectionView.h>
    #define __RDH_COLLECTION_VIEW_LIB(__CLASS__) PST##__CLASS__
#else
    #import <UIKit/UIKit.h>
    #define __RDH_COLLECTION_VIEW_LIB(__CLASS__) UI##__CLASS__
#endif

@interface RDHCollectionViewGridLayout : __RDH_COLLECTION_VIEW_LIB(CollectionViewLayout)

/**
 * A vertical direction will constrain the layout by rows (lineItemCount per row), a horizontal direction by columns (lineItemCount per column).
 *
 * The default value of this property is UICollectionViewScrollDirectionVertical.
 */
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

/**
 * Defines the size of the unconstrained dimension of the items. Simply, for vertical layouts this is the height of the items, and for horizontal layouts this is the width of the items.
 * Setting this value to 0 will make layout set the dimension to the average of the other dimenion on the same line. This is due to the layout taking account of dirty pixels, adding these extra pixels in the first X items on the line.
 * For example, if using a vertical scrollDirection and a lineItemCount of 5 when the collectionView has a width of 104, the first 4 items on every line will have a width of 21, and the last 20 (21 + 21 + 21 + 21 + 20 = 104), so the height of the lines would be 21 (20.8 rounded).
 *
 * The default value of this property is 0.
 */
@property (nonatomic, assign) CGFloat lineDimension;

/**
 * Defines the maximum number of items allowed per line. Simply, for vertical layouts this is the number of columns, and for horizontal layouts this is the number of rows. The layout accounts for adding the extra pixels to the first X items on the line. Best case is that the useable width is exactly divisible by lineItemCount, worse case is that `(useable width) mod lineItemCount = (lineItemCount - 1)` and that the first `(lineItemCount - 1)` items are 1 pixel bigger.
 *
 * The default value of this property is 4.
 */
@property (nonatomic, assign) NSUInteger lineItemCount;

/**
 * Defines the spacing of items on the same line of the layout. Simply, for vertical layouts this is the column spacing, and for horizontal layouts this is the row spacing.
 *
 * The default value of this property is 0.
 */
@property (nonatomic, assign) CGFloat itemSpacing;

/**
 * Defines the line spacing of the layout. Simply, for vertical layouts this is the row spacing, and for horizontal layouts this is the column spacing.
 *
 * The default value of this property is 0.
 */
@property (nonatomic, assign) CGFloat lineSpacing;

/**
 * To force sections to start on a new line set this property to YES. Otherwise the section will follow on on from the previous one.
 *
 * The default value of this property is NO.
 */
@property (nonatomic, assign) BOOL sectionsStartOnNewLine;

@end

#undef __RDH_COLLECTION_VIEW_LIB
