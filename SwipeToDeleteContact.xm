//
//  SwipeToDeleteContact.x
//  SwipeToDeleteContact
//
//  Created by Rene Kahle on 22.01.2016.
//  Copyright (c) 2016 Rene Kahle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "DebugLog.h"
#include <substrate.h>

#define isiOS9Up (kCFCoreFoundationVersionNumber >= 1217.11)

#define IS_OS_9_OR_LATER [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0
#define IS_OS_8_OR_LATER [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0


%group main

%end


%ctor {
	@autoreleasepool {
		%init(main);

		if (IS_OS_9_OR_LATER) {

			Log (@"init 9");

			dlopen("/Library/Application Support/SwipeToDeleteContact/SwipeToDeleteContactiOS9.dylib", RTLD_LAZY);
		} else

		if (IS_OS_8_OR_LATER) {

			Log (@"init 8");


			dlopen("/Library/Application Support/SwipeToDeleteContact/SwipeToDeleteContactiOS8.dylib", RTLD_LAZY);
		}



	}
}
