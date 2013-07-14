//
//  RDHCollectionViewGridLayout.m
//  RDHCollectionViewGridLayout
//
//  Created by Richard Hodgkins on 06/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "RDHCollectionViewGridLayout.h"

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

/*
 * If we're using the PSTCollectionView library then create a macro to swap out the classes. Any *CollectionView* libraries should use this ommiting the UI/PST prefix.
 * e.g.
 * UICollectionView -> __RDH_COLLECTION_VIEW_LIB(CollectionView)
 * UICollectionViewLayoutAttribute -> __RDH_COLLECTION_VIEW_LIB(CollectionViewLayoutAttribute)
 * This is not needed for enums as they are just typedefs.
 */
#ifdef RDH_USING_PSTCOLLECTIONVIEW
    #define __RDH_COLLECTION_VIEW_LIB(__CLASS__) PST##__CLASS__
#else
    #define __RDH_COLLECTION_VIEW_LIB(__CLASS__) UI##__CLASS__
#endif

@interface RDHCollectionViewGridLayout ()

@property (nonatomic, copy) NSArray *firstLineFrames;
@property (nonatomic, copy, readonly) NSMutableDictionary *itemAttributes;

/// This property is used to store the lineDimension when it is set to 0 (depends on the average item size) and the base item size.
@property (nonatomic, assign) CGSize calculatedItemSize;

/// This property is re-calculated when invalidating the layout
@property (nonatomic, assign) NSUInteger numberOfLines;

@end

@implementation RDHCollectionViewGridLayout

-(instancetype)init
{
    self = [super init];
    if (self) {
        // Default properties
        _scrollDirection = UICollectionViewScrollDirectionVertical;
        _lineDimension = 0;
        _lineItemCount = 4;
        _itemSpacing = 0;
        _lineSpacing = 0;
        _sectionsStartOnNewLine = NO;
        
        _firstLineFrames = nil;
        _itemAttributes = [NSMutableDictionary dictionary];
        _numberOfLines = 0;
    }
    return self;
}

-(void)invalidateLayout
{
    [super invalidateLayout];
    
    self.firstLineFrames = nil;
    [self.itemAttributes removeAllObjects];
    self.numberOfLines = 0;
    self.calculatedItemSize = CGSizeZero;
}

-(void)prepareLayout
{
    [super prepareLayout];
    
    self.numberOfLines = [self calculateNumberOfLines];
    
    self.calculatedItemSize = [self calculateItemSize];
    
    NSInteger const sectionCount = [self.collectionView numberOfSections];
    for (NSInteger section=0; section<sectionCount; section++) {
        
        NSInteger const itemCount = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger item=0; item<itemCount; item++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            self.itemAttributes[indexPath] = [self calculateLayoutAttributesForItemAtIndexPath:indexPath];
        }
    }
}

-(CGSize)collectionViewContentSize
{
    CGSize size;
    
    switch (self.scrollDirection) {
        case UICollectionViewScrollDirectionHorizontal:
            size.width = self.numberOfLines * self.calculatedItemSize.width;
            // Add spacings
            size.width += (self.numberOfLines - 1) * self.lineSpacing;
            size.height = [self constrainedCollectionViewDimension];
            break;
            
        case UICollectionViewScrollDirectionVertical:
            size.width = [self constrainedCollectionViewDimension];
            size.height = self.numberOfLines * self.calculatedItemSize.height;
            // Add spacings
            size.height += (self.numberOfLines - 1) * self.lineSpacing;
            break;
    }
    
    return size;
}

-(__RDH_COLLECTION_VIEW_LIB(CollectionViewLayoutAttributes) *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    __RDH_COLLECTION_VIEW_LIB(CollectionViewLayoutAttributes) *layoutAttrs = self.itemAttributes[indexPath];
    
    if (!layoutAttrs) {
        layoutAttrs = [self calculateLayoutAttributesForItemAtIndexPath:indexPath];
        self.itemAttributes[indexPath] = layoutAttrs;
    }
    
    return layoutAttrs;
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttributes = [NSMutableArray arrayWithCapacity:[self.itemAttributes count]];
    
    [self.itemAttributes enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *const indexPath, __RDH_COLLECTION_VIEW_LIB(CollectionViewLayoutAttributes) *attr, BOOL *stop) {
        
        if (CGRectIntersectsRect(rect, attr.frame)) {
            [layoutAttributes addObject:attr];
        }
    }];
    
    return layoutAttributes;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}

#pragma mark - Lazily loaded properties

/// Precalculate the frames for the first line as they can be reused for every line
-(NSArray *)firstLineFrames
{
    if (!_firstLineFrames) {
        
        CGFloat collectionConstrainedDimension = [self constrainedCollectionViewDimension];
        // Subtract the spacing between items on a line
        collectionConstrainedDimension -= (self.itemSpacing * (self.lineItemCount - 1));

        CGFloat constrainedItemDimension;
        switch (self.scrollDirection) {
            case UICollectionViewScrollDirectionVertical:
                constrainedItemDimension = self.calculatedItemSize.width;
                break;
                
            case UICollectionViewScrollDirectionHorizontal:
                constrainedItemDimension = self.calculatedItemSize.height;
                break;
        }
        
        // This value will always be less than the lineItemCount - this is the number of dirty pixels
        CGFloat remainingDimension = collectionConstrainedDimension - (constrainedItemDimension * self.lineItemCount);
        
        CGRect frame = CGRectZero;
        frame.size = self.calculatedItemSize;
        
        NSMutableArray *frames = [NSMutableArray arrayWithCapacity:self.lineItemCount];
        
        for (NSUInteger i=0; i<self.lineItemCount; i++) {
            
            CGRect itemFrame = frame;
            
            // Add an extra pixel if we've got dirty pixels left
            if (remainingDimension-- > 0) {
                switch (self.scrollDirection) {
                    case UICollectionViewScrollDirectionVertical:
                        itemFrame.size.width++;
                        break;
                        
                    case UICollectionViewScrollDirectionHorizontal:
                        itemFrame.size.height++;
                        break;
                }
            }
            
            [frames addObject:[NSValue valueWithCGRect:itemFrame]];
            
            // Move to the next item
            switch (self.scrollDirection) {
                case UICollectionViewScrollDirectionVertical:
                    frame.origin.x = itemFrame.origin.x + itemFrame.size.width + self.itemSpacing;
                    break;
                    
                case UICollectionViewScrollDirectionHorizontal:
                    frame.origin.y = itemFrame.origin.y + itemFrame.size.height + self.itemSpacing;
                    break;
            }
        }
        
        _firstLineFrames = [frames copy];
    }
    
    return _firstLineFrames;
}

#pragma mark - Calculation methods

-(NSUInteger)calculateNumberOfLines
{
    NSInteger numberOfLines;
    if (self.sectionsStartOnNewLine) {
        
        numberOfLines = 0;
        
        NSInteger const sectionCount = [self.collectionView numberOfSections];
        for (NSInteger section=0; section<sectionCount; section++) {
            // If there are too many items to fill a line, allow it to over flow.
            numberOfLines += ceil(((CGFloat) [self.collectionView numberOfItemsInSection:section]) / self.lineItemCount);
        }
        
        // Best case: numberOfLines = number of sections with items
        // Worse case: numberOfLines = 2 * number of sections with items
        
    } else {
        
        NSUInteger n = 0;
        NSInteger const sectionCount = [self.collectionView numberOfSections];
        for (NSInteger section=0; section<sectionCount; section++) {
            n += [self.collectionView numberOfItemsInSection:section];
        }
        CGFloat numberOfItems = n;
        // We just need to work out the number of lines
        numberOfLines = ceil(numberOfItems / self.lineItemCount);
    }
    
    return numberOfLines;
}

-(CGSize)calculateItemSize
{
    CGFloat collectionConstrainedDimension = [self constrainedCollectionViewDimension];
    // Subtract the spacing between items on a line
    collectionConstrainedDimension -= (self.itemSpacing * (self.lineItemCount - 1));
    
    const CGFloat constrainedItemDimension = floor(collectionConstrainedDimension / self.lineItemCount);
    
    CGSize size = CGSizeZero;
    switch (self.scrollDirection) {
        case UICollectionViewScrollDirectionVertical:
            size.width = constrainedItemDimension;
            if (self.lineDimension == 0) {
                size.height = round(collectionConstrainedDimension / self.lineItemCount);
            } else {
                size.height = self.lineDimension;
            }
            break;
            
        case UICollectionViewScrollDirectionHorizontal:
            size.height = constrainedItemDimension;
            if (self.lineDimension == 0) {
                size.width = round(collectionConstrainedDimension / self.lineItemCount);
            } else {
                size.width = self.lineDimension;
            }
            break;
    }
    
    return size;
}

-(__RDH_COLLECTION_VIEW_LIB(CollectionViewLayoutAttributes) *)calculateLayoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    __RDH_COLLECTION_VIEW_LIB(CollectionViewLayoutAttributes) *attrs = [__RDH_COLLECTION_VIEW_LIB(CollectionViewLayoutAttributes) layoutAttributesForCellWithIndexPath:indexPath];
    
    CGRect frame;
    NSUInteger line;
    
    if (self.sectionsStartOnNewLine) {
        // As we start a section on a new line, this value does not need to account for previous sections
        frame = [self.firstLineFrames[indexPath.item % self.lineItemCount] CGRectValue];
        
        line = 0;
        for (NSInteger section=0; section<indexPath.section; section++) {
            // If there are too many items to fill a line, allow it to over flow.
            line += ceil(((CGFloat) [self.collectionView numberOfItemsInSection:section]) / self.lineItemCount);
        }
        // Add the line that this item is on in this section
        line += indexPath.item / self.lineItemCount;
        
    } else {
        
        // Need to calculate the number of items that have come before in previous sections
        NSUInteger numberOfItems = 0;
        for (NSInteger section=0; section<indexPath.section; section++) {
            // If there are too many items to fill a line, allow it to over flow.
            numberOfItems += [self.collectionView numberOfItemsInSection:section];
        }
        // And now calculate this items place
        numberOfItems += indexPath.item;
        
        // Get frame of this item - it'll be offset by the possible previous items on this line
        frame = [self.firstLineFrames[numberOfItems % self.lineItemCount] CGRectValue];
        
        // Now work out the line
        line = numberOfItems / self.lineItemCount;
    }
    
    // Work out the x/y offset depending on the scroll direction
    CGFloat spacingOffset = (line * self.lineSpacing);
    switch (self.scrollDirection) {
        case UICollectionViewScrollDirectionVertical:
            frame.origin.y += (line * self.calculatedItemSize.height) + spacingOffset;
            break;
            
        case UICollectionViewScrollDirectionHorizontal:
            frame.origin.x += (line * self.calculatedItemSize.width) + spacingOffset;
            break;
    }
    
    attrs.frame = frame;
    // Place below the scroll bar
    attrs.zIndex = -1;
    
    return attrs;
}

#pragma mark - Convenince sizing methods

-(CGFloat)constrainedCollectionViewDimension
{
    CGSize collectionViewInsetBoundsSize = UIEdgeInsetsInsetRect(self.collectionView.bounds, self.collectionView.contentInset).size;
    
    switch (self.scrollDirection) {
        case UICollectionViewScrollDirectionHorizontal:
            return collectionViewInsetBoundsSize.height;
            
        case UICollectionViewScrollDirectionVertical:
            return collectionViewInsetBoundsSize.width;
    }
}

#pragma mark - Detail setters that invalidate the layout

-(void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    NSAssert(scrollDirection == UICollectionViewScrollDirectionHorizontal || scrollDirection == UICollectionViewScrollDirectionVertical, @"Invalid scrollDirection: %d", scrollDirection);
    
    if (_scrollDirection != scrollDirection) {
        _scrollDirection = scrollDirection;
        
        [self invalidateLayout];
    }
}

-(void)setLineDimension:(CGFloat)lineDimension
{
    NSAssert(lineDimension >= 0, @"Negative lineDimension is meaningless");
    
    if (_lineDimension != lineDimension) {
        _lineDimension = lineDimension;
        
        [self invalidateLayout];
    }
}

-(void)setLineItemCount:(NSUInteger)lineItemCount
{
    NSAssert(lineItemCount > 0, @"Zero line item count is meaningless");
    if (_lineItemCount != lineItemCount) {
        _lineItemCount = lineItemCount;
        
        [self invalidateLayout];
    }
}

-(void)setItemSpacing:(CGFloat)itemSpacing
{
    if (_itemSpacing != itemSpacing) {
        _itemSpacing = itemSpacing;
        
        [self invalidateLayout];
    }
}

-(void)setLineSpacing:(CGFloat)lineSpacing
{
    if (_lineSpacing != lineSpacing) {
        _lineSpacing = lineSpacing;
        
        [self invalidateLayout];
    }
}

-(void)setSectionsStartOnNewLine:(BOOL)sectionsStartOnNewLine
{
    if (_sectionsStartOnNewLine != sectionsStartOnNewLine) {
        _sectionsStartOnNewLine = sectionsStartOnNewLine;
        
        [self invalidateLayout];
    }
}

@end

#undef __RDH_COLLECTION_VIEW_LIB