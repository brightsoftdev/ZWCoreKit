#import "hmac.h"
#import "sha1.h"

void HMACSHA1(const unsigned char *data, NSUInteger dataLength, const unsigned char *key, NSUInteger keyLength, unsigned char *digestOut) {
	const size_t B = 64;
	const size_t L = 20;
	unsigned char k_ipad[B + 1];
	unsigned char k_opad[B + 1];
	
	unsigned char *useKey = nil;
	
	if(keyLength > B) {
		useKey = (unsigned char *)malloc(sizeof(unsigned char) * 20);
		SHA1(key, keyLength, useKey);
		keyLength = L;
	} else {
		useKey = (unsigned char *)malloc(keyLength);
		memcpy(useKey, key, keyLength);
	}
	
	/* start out by storing key in pads */
	memset(k_ipad, 0, sizeof k_ipad);
	memset(k_opad, 0, sizeof k_opad);
	memcpy(k_ipad, useKey, keyLength);
	memcpy(k_opad, useKey, keyLength);
	
	for(int i = 0; i < B; ++i) {
		k_ipad[i] ^= 0x36;
		k_opad[i] ^= 0x5c;
	}
	
	// sha1 context
	SHA1Context ctx = nil;
	
	// inner sha1
	ctx = SHA1ContextInit();
	SHA1ContextUpdate(ctx, k_ipad, B);
	SHA1ContextUpdate(ctx, data, dataLength);
	SHA1ContextFinal(ctx, digestOut);
	
	ctx = SHA1ContextInit();
	SHA1ContextUpdate(ctx, k_opad, B);
	SHA1ContextUpdate(ctx, (const unsigned char *)digestOut, L);
	SHA1ContextFinal(ctx, digestOut);
}
