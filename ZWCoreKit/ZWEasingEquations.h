#import <Foundation/Foundation.h>

// t = current time (0 -> duration)
// b = start value
// c = change in value
// d = duration

#pragma mark - Linear

static inline CGFloat ZWEasingLinear(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
	return c*t/d+b;
}

#pragma mark - Sine

static inline CGFloat ZWEasingSineEaseIn(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
	return -c*cos(t/d*(M_PI/2.0))+c+b;
}
static inline CGFloat ZWEasingSineEaseOut(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
	return c*sin(t/d*(M_PI/2.0))+b;
}
static inline CGFloat ZWEasingSineEaseInOut(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
	return -c/2.0*(cos(M_PI*t/d)-1.0)+b;
}

#pragma mark - Circ

static inline CGFloat  ZWEasingCircEaseIn(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
	return -c*(sqrt(1.0-(t/=d)*t)-1.0)+b;
}
static inline CGFloat ZWEasingCircEaseOut(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
	return c*sqrt(1.0-(t=t/d-1.0)*t)+b;
}
static inline CGFloat ZWEasingCircEaseInOut(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
	if((t/=d/2.0)<1.0) {
		return -c/2.0*(sqrt(1.0-t*t)-1.0)+b;
	}
	return c/2.0*(sqrt(1.0-(t-=2.0)*t)+1.0)+b;
}