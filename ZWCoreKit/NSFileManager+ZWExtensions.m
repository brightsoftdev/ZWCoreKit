#import "NSFileManager+ZWExtensions.h"


@implementation NSFileManager (ZWExtensions)

- (BOOL)forceReplaceItemAtURL:(NSURL *)pTargetURL
				withItemAtURL:(NSURL *)pSourceURL
			   backupItemName:(NSString *)pBackupItemName 
					  options:(NSFileManagerItemReplacementOptions)pOptions 
			 resultingItemURL:(NSURL **)pResultingURL
						error:(NSError **)pError {
	// vars
	BOOL result = NO;
	
	// try to use regular replace method
	if(!(result = [self replaceItemAtURL:pTargetURL
						   withItemAtURL:pSourceURL
						  backupItemName:pBackupItemName 
								 options:pOptions
						resultingItemURL:pResultingURL
								   error:pError])) {
		if(pError != nil) {
			ZWLog(@"%@", *pError);
		}
	}
	
	return result;
}

@end
