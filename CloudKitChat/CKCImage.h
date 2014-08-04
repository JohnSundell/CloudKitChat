#if TARGET_OS_IPHONE
#define CKCImage UIImage
#else
#define CKCImage NSImage
#endif

@class CKCImage;