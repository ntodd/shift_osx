#import "NSHUDScroller.h"

@implementation NSHUDScroller

- (void)drawRect:(NSRect)rect
{
	[self drawKnob];
}

- (void)drawKnob
{
    NSRect knobslot = [self rectForPart:NSScrollerKnobSlot];
	[[NSColor colorWithDeviceWhite:0 alpha:0] set];
	[NSBezierPath fillRect:knobslot];
	NSBezierPath *knob = [NSBezierPath bezierPathWithRoundedRect:[self rectForPart:NSScrollerKnob] xRadius:5 yRadius:5];
	[[NSColor colorWithDeviceWhite:1 alpha:.8] set];
	[knob fill];
}

- (void)drawArrow:(NSScrollerArrow)arrow highlight:(BOOL)flag
{
    NSRect rect= [self rectForPart:NSScrollerNoPart];
	[[NSColor greenColor] set];
	[NSBezierPath fillRect:rect];

}

- (BOOL)isOpaque {
	
    return NO;
}


@end
