typedef void* SHA1Context;
extern SHA1Context SHA1ContextInit(void);
extern void SHA1ContextUpdate(SHA1Context ctx, const unsigned char *data, unsigned int dataLength);
extern void SHA1ContextFinal(SHA1Context ctx, unsigned char *digestOut);
extern void SHA1ContextInvalidate(SHA1Context ctx);

extern void SHA1(const unsigned char *data, NSUInteger length, unsigned char *digestOut);