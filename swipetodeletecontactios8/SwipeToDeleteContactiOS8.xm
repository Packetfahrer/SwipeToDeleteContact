//
//  SwipeToDeleteContactiOS9.x
//  SwipeToDeleteContactiOS9
//
//  Created by Rene Kahle on 22.01.2016.
//  Copyright (c) 2016 Rene Kahle. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "../HEADERS.h"


#define isiPad() ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)


#define LocalizationsDirectory @"/Library/Application Support/SwipeToDeleteContact/Localizations"
#define LOCALIZED_TITEL  [[NSBundle bundleWithPath:LocalizationsDirectory]localizedStringForKey:@"Swipe to Delete!" value:@"Swipe to Delete!" table:nil]
#define LOCALIZED_MESSAGE [[NSBundle bundleWithPath:LocalizationsDirectory]localizedStringForKey:@"Really delete this Contact?" value:@"Really delete this Contact?" table:nil]

#define LOCALIZED_CANCEL [[NSBundle bundleWithPath:LocalizationsDirectory]localizedStringForKey:@"Cancel" value:@"Cancel" table:nil]

#define LOCALIZED_YES [[NSBundle bundleWithPath:LocalizationsDirectory]localizedStringForKey:@"Yes" value:@"Yes" table:nil]


static id membersViewController = nil;
static NSInteger globalRow = -1;

//static BOOL g_isEditing = NO;


#define APPID @"com.packetfahrer.swipetodeletecontact"

#define DEFAULT_ENABLED YES
#define PREFS_ENABLED_KEY @"swEnabled"

#define Enabled ([preferences objectForKey: PREFS_ENABLED_KEY] ? [[preferences objectForKey: PREFS_ENABLED_KEY] boolValue] : DEFAULT_ENABLED)

#define DEFAULT_USEALARM YES
#define PREFS_USEALARM_KEY @"useAlarm"
#define useAlarm ([preferences objectForKey: PREFS_USEALARM_KEY] ? [[preferences objectForKey: PREFS_USEALARM_KEY] boolValue] : DEFAULT_USEALARM)

#define IS_OS_8_OR_LATER [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0



static NSDictionary *preferences = nil;


void loadPreferences() {
	
	
	if (preferences) {
		[preferences release];
		 preferences = nil;


	}
	
	if (IS_OS_8_OR_LATER) { 

		
		NSArray *keyList = [(NSArray *)CFPreferencesCopyKeyList((CFStringRef)APPID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost) autorelease];
		preferences = (NSDictionary *)CFPreferencesCopyMultiple((CFArrayRef)keyList, (CFStringRef)APPID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);

		Log (@"loadPreferences %@", preferences);
	}


}



%group main


%hook ABMembersViewController

- (id)initWithModel:(id)arg1 {
	if ((self = %orig))
		
		membersViewController = self;
		
	return self;
}

%end


%hook ABMembersDataSource


%new(c@:@@)

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

	if (Enabled) {

	
		Log (@"Enabled %i", Enabled);


	if ([[tableView _rowData] globalRowForRowAtIndexPath:indexPath] == 0  && [[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.mobilephone"]) {
	
	
		return NO; 

	}


	return YES;

	} else {

	return NO;

	
	}

}


%new(v@:@i@)
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		globalRow = [[tableView _rowData] globalRowForRowAtIndexPath:indexPath];
		
		if (!isiPad() && [[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.mobilephone"])
			
			globalRow--;
		
		
		if (useAlarm) {

			UIAlertView *x = [[UIAlertView alloc] initWithTitle:LOCALIZED_TITEL
					    message:LOCALIZED_MESSAGE
					    delegate:self
				  		cancelButtonTitle:LOCALIZED_CANCEL
				  		otherButtonTitles:LOCALIZED_YES, nil];
   						[x setTag:0075];
						[x show];

						return;
		
		}
		
		[self deleteContact];
	}

}

%new(v@:@i)


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {


	if ([alertView tag] == 0075) {
		
			if (buttonIndex == 1) {

			[self deleteContact];
		
			} else {

				
				[[membersViewController tableView] setEditing:NO animated:YES]; 

			}

		
		}


	

}

%new(v@:)
- (void)deleteContact {

	ABModel *model = [self model];
	
	ABAddressBookRef ab = [model addressBook];
		
	ABRecordRef person = [model displayedMemberAtIndex:globalRow];
	
	ABAddressBookRemoveRecord(ab, person, NULL);
	ABAddressBookSave(ab, NULL);
	
	[membersViewController personWasDeleted];
}

%end


%end


%ctor {
	
	NSAutoreleasePool *p = [NSAutoreleasePool new];

		%init(main);


		loadPreferences();

    	
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
											NULL,
											(CFNotificationCallback)loadPreferences,
											CFSTR("com.packetfahrer.SwipeChanged"),
											NULL,
											CFNotificationSuspensionBehaviorDeliverImmediately);


	[p drain];
	
	
}
