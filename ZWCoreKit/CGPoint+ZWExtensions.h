static inline
CGPoint CGPointNegate(CGPoint p) {
	return CGPointMake(-p.x, -p.y);
}

static inline
CGPoint CGPointAdd(CGPoint a, CGPoint b) {
	return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline
CGPoint CGPointSub(CGPoint a, CGPoint b) {
	return CGPointMake(a.x - b.x, a.y - b.y);
}

static inline
CGPoint CGPointMul(CGPoint p, CGFloat multiplier) {
	return CGPointMake(p.x * multiplier, p.y * multiplier);
}

static inline
CGPoint CGPointMid(CGPoint a, CGPoint b) {
	return CGPointMake((a.x + b.x) / 2.0, (a.y + b.y) / 2.0);
}

static inline
CGFloat CGPointDistance(CGPoint a, CGPoint b) {
	CGFloat dx = a.x - b.x;
	CGFloat dy = a.y - b.y;
	return sqrt(dx * dx + dy * dy);
}

static inline
CGPoint CGPointInvert(CGPoint p) {
	return CGPointMake(p.y, p.x);
}

static inline
CGPoint CGPointMakeProportional(CGPoint a, CGSize b) {
	return CGPointMake(a.x / b.width, a.y / b.height);
}

static inline
CGPoint CGPointFromProportional(CGPoint a, CGSize b) {
	return CGPointMake(a.x * b.width, a.y * b.height);
}

static inline
CGPoint CGPointOffset(CGPoint p, CGFloat offsetX, CGFloat offsetY) {
	return CGPointMake(p.x + offsetX, p.y + offsetY);
}

extern CGPoint CGPointOnLineClosestToPoint(CGPoint point, CGPoint lineStart, CGPoint lineEnd, BOOL constrainToLineSegment);