static inline
CGSize CGSizeScale(CGSize size, CGFloat scaleX, CGFloat scaleY) {
	return CGSizeApplyAffineTransform(size, CGAffineTransformMakeScale(scaleX, scaleY));
}

static inline
CGSize CGSizeMul(CGSize size, CGFloat multiplier) {
	return CGSizeScale(size, multiplier, multiplier);
}

static inline
CGSize CGSizeInvert(CGSize size) {
	return CGSizeMake(size.height, size.width);
}

static inline
CGSize CGSizeInset(CGSize size, CGFloat dx, CGFloat dy) {
	size.width += dx;
	size.height += dy;
	return size;
}