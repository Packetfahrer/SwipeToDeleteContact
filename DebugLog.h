//
//  DebugLog.h
//
//  LogC()			print Class, Selector, Comment				(ObjC only)
//  Log0			print Class, Selector						(ObjC only)
//  LogMore()		print Filename, Line, Signature, Comment	(ObjC only)
//  Log(s, ...)		print Comment								(C, ObjC)
//
#include <CoreFoundation/CFLogUtilities.h>

#ifdef __DEBUG__

// Default Prefix
#ifndef DEBUG_PREFIX
	#define DEBUG_PREFIX @"[SWIPETODELETE:]"
#endif
#endif


#ifdef __DEBUG__

	#define Log(s, ...) \
	NSLog(@"%@ >> [Line: %d] %@ ", DEBUG_PREFIX, \
	 __LINE__, \
	[NSString stringWithFormat:(s), ##__VA_ARGS__] \
	)

#define LogMore(s, ...) \
  NSLog(@"%@ %@: [Line: %d] >> %s >> %@", \
    DEBUG_PREFIX, \
    [[NSString stringWithUTF8String:__FILE__] lastPathComponent], \
    __LINE__, \
    __PRETTY_FUNCTION__, \
    [NSString stringWithFormat:(s), \
    ##__VA_ARGS__] \
  )

#else
	#define Log(...)
  	#define LogMore(...)

#endif




