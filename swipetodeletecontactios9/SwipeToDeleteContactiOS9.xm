//
//  SwipeToDeleteContactiOS9.x
//  SwipeToDeleteContactiOS9
//
//  Created by Rene Kahle on 22.01.2016.
//  Copyright (c) 2016 Rene Kahle. All rights reserved.
//




#import "../HEADERS.h"
#import "../DebugLog.h"
#import <UIKit/UIKit.h>



#define IS_OS_9_OR_LATER [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0
#define APPID @"com.packetfahrer.swipetodeletecontact"
#define DEFAULT_ENABLED YES
#define PREFS_ENABLED_KEY @"swEnabled"

#define Enabled ([preferences objectForKey: PREFS_ENABLED_KEY] ? [[preferences objectForKey: PREFS_ENABLED_KEY] boolValue] : DEFAULT_ENABLED)

#define DEFAULT_USEALARM YES
#define PREFS_USEALARM_KEY @"useAlarm"


#define DEFAULT_USEALL NO
#define PREFS_USEALL_KEY @"useAll"

#define useAlarm ([preferences objectForKey: PREFS_USEALARM_KEY] ? [[preferences objectForKey: PREFS_USEALARM_KEY] boolValue] : DEFAULT_USEALARM)
#define useAlL ([preferences objectForKey: PREFS_USEALL_KEY] ? [[preferences objectForKey: PREFS_USEALL_KEY] boolValue] : DEFAULT_USEALL)


#define LocalizationsDirectory @"/Library/Application Support/SwipeToDeleteContact/Localizations"
#define LOCALIZED_TITEL  [[NSBundle bundleWithPath:LocalizationsDirectory]localizedStringForKey:@"Swipe to Delete!" value:@"Swipe to Delete!" table:nil]

#define LOCALIZED_MESSAGE [[NSBundle bundleWithPath:LocalizationsDirectory]localizedStringForKey:@"Really delete this Contact?" value:@"Really delete this Contact?" table:nil]
#define LOCALIZED_MESSAGE_ALL [[NSBundle bundleWithPath:LocalizationsDirectory]localizedStringForKey:@"Really delete all Contacts?" value:@"Really delete all Contacts?" table:nil]


#define LOCALIZED_CANCEL [[NSBundle bundleWithPath:LocalizationsDirectory]localizedStringForKey:@"Cancel" value:@"Cancel" table:nil]
#define LOCALIZED_YES [[NSBundle bundleWithPath:LocalizationsDirectory]localizedStringForKey:@"Yes" value:@"Yes" table:nil]





static CNMutableContact *contact;

static NSDictionary *preferences = nil;


void loadPreferences() {
	
	
	if (preferences) {
		[preferences release];
		 preferences = nil;


	}
	
	if (IS_OS_9_OR_LATER) { 

		
		NSArray *keyList = [(NSArray *)CFPreferencesCopyKeyList((CFStringRef)APPID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost) autorelease];
		preferences = (NSDictionary *)CFPreferencesCopyMultiple((CFArrayRef)keyList, (CFStringRef)APPID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);

		Log (@"loadPreferences %@", preferences);
	}


}	

%group main


%hook CNContactListViewController //THIS IS A SUBCLASS OF A UITABLEVIEWCONTROLLER


- (void)viewDidLoad
{

	if (useAlL) {

	UIBarButtonItem  *deletaAllButton= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteAllContact)]; 
  
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.navigationItem.rightBarButtonItem,deletaAllButton,nil];


	}

	
    %orig;




}

- (void)viewWillAppear:(BOOL)arg1{
	

	if (useAlL) {

	UIBarButtonItem  *deletaAllButton= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteAllContact)]; 
  
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.navigationItem.rightBarButtonItem,deletaAllButton,nil];


	}

    %orig;

}


- (BOOL)tableView:(id)arg1 canEditRowAtIndexPath:(NSIndexPath *)indexPath
{

	if (Enabled) {


		return YES;

	
	} else {

	return NO;

	
	}

}


%new

 -(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
 					    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
    	  
    	
    	contact = [[self _contactAtIndexPath:indexPath] mutableCopy];
    	

    	Log(@"CNMutableContact  %@", contact);

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

				self.tableView.editing = NO;
				

			}

		
		}


		if ([alertView tag] == 0076) {
		
			if (buttonIndex == 1) {

			[self deleteAllContactsNow];
		
			} else {


				Log (@"cancel");

				return;
				

			}

		
		}


	
}

%new(v@:)

- (void)deleteContact {

		

			CNContactStore *contactStore = [[CNContactStore alloc] init];

			CNSaveRequest *saveRequest = [[CNSaveRequest alloc] init];

				
			[saveRequest deleteContact:contact];

			[contactStore executeSaveRequest:saveRequest error:nil];


			self.tableView.editing = NO;


			[self.tableView reloadData];

			contact = nil;

			[contact release];

	
}


%new(v@:)


- (void)deleteAllContact {



	if (useAlarm) {


   		UIAlertView *x = [[UIAlertView alloc] initWithTitle:LOCALIZED_TITEL
					    message:LOCALIZED_MESSAGE_ALL
					    delegate:self
				  		cancelButtonTitle:LOCALIZED_CANCEL
				  		otherButtonTitles:LOCALIZED_YES, nil];
   						[x setTag:0076];
						[x show];


					
					return;
		
    	}

    	[self deleteAllContactsNow];

    


			

}


%new(v@:)


- (void)deleteAllContactsNow {


			dispatch_async(dispatch_get_main_queue(), ^{


			CNContactStore *contactStore = [[CNContactStore alloc] init];

			

			[contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {


			NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey];
       

			NSString *containerId = contactStore.defaultContainerIdentifier;
			NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
		
			NSArray *cnContacts = [contactStore unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];

			if (error) {
			
				Log(@"error fetching contacts %@", error);
			
			} else {



				

					CNSaveRequest *saveRequest = [[CNSaveRequest alloc] init];

					for (CNContact *contact in cnContacts) {

					[saveRequest deleteContact:[contact mutableCopy]];
				
					}

					[contactStore executeSaveRequest:saveRequest error:nil];
				
				 

					}

			


				}];


				self.tableView.editing = NO;


				[self.tableView reloadData];

			});

}


%end

%end


#import <spawn.h>


static void PreferencesChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	
	pid_t pid;
    int status;
    const char* args[] = { "killall", "-9", "Contacts", NULL };
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
    waitpid(pid, &status, WEXITED);
	

	
	loadPreferences();


}


%ctor {
	@autoreleasepool {
		
		%init(main);


		loadPreferences();

    	
    	/*
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
											NULL,
											(CFNotificationCallback)loadPreferences,
											CFSTR("com.packetfahrer.SwipeChanged"),
											NULL,
											CFNotificationSuspensionBehaviorDeliverImmediately);
		*/

		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), 
											NULL, PreferencesChangedCallback, 
											CFSTR("com.packetfahrer.SwipeChanged"), 
											NULL, CFNotificationSuspensionBehaviorDeliverImmediately);



	}

}

