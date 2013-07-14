//
//  RDHCollectionViewGridLayout.h
//  RDHCollectionViewGridLayout
//
//  Created by Richard Hodgkins on 06/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const RDHCollectionViewGridLayoutSectionHeaderKind;

@interface RDHCollectionViewGridLayout : UICollectionViewLayout

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
 * Setting this property to NO will remove any section headers if the are being used.
 *
 * The default value of this property is NO.
 */
@property (nonatomic, assign) BOOL sectionsStartOnNewLine;

/**
 * The size (in the same dimension as lineDimension) of the section supplementary views.
 * When a vertical scrollDirection is set, this dimension is the height, when horizontal this is the width of the headers. However when the scrollDirection is horizontal, the headers are rotated by 90 degrees counter-clockwise. For example a label in the headers would be rotated to read from bottom to top
 * This property is only useable when sectionsStartOnNewLine is YES, as the section header is placed above the items in that section and as when sectionsStartOnNewLine is NO, items from different sections can be on the same line so this would make no sense.
 * The default value of this property is 0.
 */
@property (nonatomic, assign) CGFloat sectionDimension;

/**
 *
 *
 * The default value of this property is YES.
 */
@property (nonatomic, assign) BOOL floatingSectionHeaders;

@end
