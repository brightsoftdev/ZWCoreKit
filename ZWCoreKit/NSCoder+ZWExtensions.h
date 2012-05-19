#import <Foundation/Foundation.h>


@interface NSCoder (ZWExtensions)

- (void)encodeObjectsFromDictionary:(NSDictionary *)pDictionary;
- (void)encodeObjectsFromTarget:(id)pTarget forKeys:(NSArray *)pKeys;
- (void)decodeObjectsToTarget:(id)pTarget forKeys:(NSArray *)pKeys;
- (void)encodeObjectsFromTarget:(id)pTarget forKeyPaths:(NSArray *)pKeyPaths;
- (void)decodeObjectsToTarget:(id)pTarget forKeyPaths:(NSArray *)pKeyPaths;

@end
