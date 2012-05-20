#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

static inline
CGRect CGRectMakeCentered(CGSize size, CGSize inside) {
	return CGRectMake(inside.width / 2 - size.width / 2, inside.height / 2 - size.height / 2, size.width, size.height);
}

static inline
CGRect CGRectMakeCenteredInRect(CGSize size, CGRect inside) {
	return CGRectMake(inside.origin.x + inside.size.width / 2 - size.width / 2, inside.origin.y + inside.size.height / 2 - size.height / 2, size.width, size.height);
}

static inline
CGRect CGRectMakeWithComponents(CGPoint origin, CGSize size) {
	CGRect r = CGRectZero;
	r.origin = origin;
	r.size = size;
	return r;
}

static inline
CGRect CGRectMakeWithOrigin(CGPoint origin) {
	return CGRectMakeWithComponents(origin, CGSizeZero);
}

static inline
CGRect CGRectMakeWithSize(CGSize size) {
	return CGRectMakeWithComponents(CGPointZero, size);
}