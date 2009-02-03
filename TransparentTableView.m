#import "TransparentTableView.h"

@implementation TransparentTableView
- (void)awakeFromNib {

    [[self enclosingScrollView] setDrawsBackground: NO];
}

- (BOOL)isOpaque {

    return NO;
}

- (void)drawBackgroundInClipRect:(NSRect)clipRect {

    // don't draw a background rect
}

@end
