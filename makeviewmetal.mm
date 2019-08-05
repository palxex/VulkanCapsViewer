#ifdef VK_USE_PLATFORM_MACOS_MVK
#import <Cocoa/Cocoa.h>
#else
#import <UIKit/UIKit.h>
#import <Metal/Metal.h>
#endif

#include <QuartzCore/CAMetalLayer.h>
static CALayer *origLayer;

extern "C" void makeViewMetalCompatible(void* handle)
{
#ifdef VK_USE_PLATFORM_MACOS_MVK
    NSView* view = (NSView*)handle;
    assert([view isKindOfClass:[NSView class]]);

    if (![view.layer isKindOfClass:[CAMetalLayer class]])
    {
        origLayer=[view layer];
        [view setLayer:[CAMetalLayer layer]];
    }
#else
    UIView* view = (UIView*)handle;
    assert([view isKindOfClass:[UIView class]]);

    CAMetalLayer *metalLayer = [CAMetalLayer new]; // Calls alloc + init

    CGSize viewSize = view.frame.size;
    metalLayer.frame = view.frame;
    metalLayer.opaque = true;
    metalLayer.framebufferOnly = true;
    metalLayer.drawableSize = viewSize;
    metalLayer.pixelFormat = (MTLPixelFormat)80;//BGRA8Unorm==80
    [view.layer addSublayer:metalLayer];
#endif
}