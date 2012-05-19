#import <Foundation/Foundation.h>


@interface NSFileManager (ZWExtensions)

- (BOOL)forceReplaceItemAtURL:(NSURL *)pTargetURL
				withItemAtURL:(NSURL *)pSourceURL
			   backupItemName:(NSString *)pBackupItemName 
					  options:(NSFileManagerItemReplacementOptions)pOptions 
			 resultingItemURL:(NSURL **)pResultingURL
						error:(NSError **)pError;

@end
