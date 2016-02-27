//
//  SwipeToDeleteContactListController.m
//  SwipeToDeleteContact
//
//  Created by Rene Kahle on 19.01.2016.
//  Copyright (c) 2016 Rene Kahle. All rights reserved.
//


#import "Preferences/PSListController.h"

#import "Social/SLComposeViewController.h"
#import <Social/SLServiceTypes.h>


#import "../DebugLog.h"


#ifndef kCFCoreFoundationVersionNumber_iOS_9_0
#define kCFCoreFoundationVersionNumber_iOS_9_0 1240.10
#endif


@interface SwipeToDeleteContactListController : PSListController

 @property (nonatomic, strong, retain) PSSpecifier *useAlarmSpecifier;
@property (nonatomic, strong, retain) PSSpecifier *deletAllSpecifier;

@end

@implementation SwipeToDeleteContactListController


- (id)initForContentSize:(CGSize)size {


    self = [super initForContentSize:size];

     if (self) {


    

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationEnteredForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        
   	
   		

    }
 
    return self;
}





- (id)specifiers {
	if (_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"SwipeToDeleteContact" target:self] retain];

		self.useAlarmSpecifier = [self specifierForID:@"useAlarm"];
		self.deletAllSpecifier = [self specifierForID:@"useAll"];
	}
    
	return _specifiers;
}


-(void)viewDidLoad{
	
	[super viewDidLoad];


	NSString *tweetAboutpath = [NSString stringWithFormat:@"%@/%@", [[self bundle] bundlePath], @"tweet.png"];
	
	

	UIBarButtonItem *tweetAbout = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:tweetAboutpath] style:UIBarButtonItemStylePlain target:self action:@selector(tweet)];

	[[self navigationItem] setRightBarButtonItem:tweetAbout];



	[self showOrHideAll];



}

- (void)viewWillAppear:(BOOL)animated {

	[super viewWillAppear:animated];

	
	[self showOrHideAll];

 


}

- (void)applicationEnteredForeground:(id)something {
	
	

	[self showOrHideAll];
	
	


}


- (void)showOrHideAll {


		if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_9_0) {

		
			// should hide
		
		Log(@"hiding ...");
		
      

		[self removeSpecifier:self.deletAllSpecifier animated:YES];
		



	} else if  (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_9_0) { 

		// should show

				Log(@"showing ...");
		
		if ([self specifierForID:@"useAll"]) {
			
			Log(@" -> already showing");
		
		} else { 

      [self   insertSpecifier:self.deletAllSpecifier
              afterSpecifier:[self specifierForID:@"useAlarm"]
              animated:YES];
		
		
      			Log(@"-> added");
		
    }
	
  }



}



-(void)donation {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=9ARRFBVXMQPAG"]];
    
}

-(void)twitter {
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://user?screen_name=DPDDEPP"]]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=DPDDEPP"]];
	} else {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/DPDDEPP"]];
	}
}


-(void)tweet {

	SLComposeViewController * composeController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
	
	[composeController setInitialText:@"I'm using SwipeToDeleteContact, an awesome Cydia tweak by @DPDdepp. Go and grab it now!"];
	
	[[self navigationController] presentViewController:composeController animated:YES completion:nil];

	
}



-(void)dimMe
{


[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"cydia://package/org.thebigboss.dimme"]]; //; cydia://package/

}

-(void)noMore
{


[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"cydia://package/org.thebigboss.nomoremissed"]]; //; cydia://package/

}
-(void)stopalarm8
{


[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"cydia://package/org.thebigboss.stopalarmios8"]]; //; cydia://package/

}
-(void)NoBanner
{


[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"cydia://package/org.thebigboss.nobanner"]]; //; cydia://package/

}

-(void)kidsec
{


[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"cydia://package/org.thebigboss.kidsecure"]]; //; cydia://package/

}
@end
