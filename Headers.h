#import <UIKit/UITableViewCell.h>

#import <UIKit/UITableViewCell.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "DebugLog.h"


@class NSString, NSDateComponents, NSDate, NSData, NSArray, CNActivityAlert, NSDictionary, NSSet, SGRecordId;


@interface CNContact : NSObject 

@end


@class NSArray, NSString, NSDictionary, CNContactStore, CNContactFilter, CNContact, CNContactFormatter;
@protocol CNContactDataSource <NSObject, NSCopying>



@property (nonatomic,readonly) NSArray * contacts; 
@property (nonatomic,readonly) CNContactStore * store; 


@end



@protocol CNContactDataSource, CNContactListViewControllerDelegate;
@class NSObject, _UIContentUnavailableView, CNContact, NSString, CNContactFormatter, UISearchController, UISearchBar, CNContactListBannerView, CNAvatarCardController, NSArray;

@interface CNContactListViewController : UITableViewController  <UIAlertViewDelegate>


-(id)initWithDataSource:(id)arg1 ;

- (id)_contactAtIndexPath:(id)arg1;

- (void)deleteAllContacts;
- (void)deleteAllContactsNow;
- (void)deleteContact;

@end

@class NSMutableDictionary, NSString, NSMutableArray, NSDictionary, NSArray;

@interface CNSaveRequest : NSObject 

-(void)deleteContact:(id)arg1 ;
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end


@class NSArray, NSString, NSData, NSDateComponents, CNActivityAlert, NSDate, CNContact, NSSet, NSDictionary;

@interface CNMutableContact : CNContact 

	
-(void)setSnapshot:(CNContact *)arg1 ;

@end



@interface UITableViewRowData : NSObject
- (NSInteger)globalRowForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface UITableView (SwipeToDeleteContact)
- (UITableViewRowData *)_rowData;
@end



@interface CNContactStoreDataSource : NSObject  {

	CNContactStore* _store;
	NSArray* _keysToFetch;
	CNContact* _meContact;

}

@property (nonatomic,retain) CNContactStore * store;                                                       //@synthesize store=_store - In the implementation block


-(NSArray *)contacts;

@end


 #import <Contacts/Contacts.h>  
 #import <ContactsUI/ContactsUI.h>  

@interface CNContactStore (SwipeToDeleteContact)


-(BOOL)executeSaveRequest:(id)arg1 error:(id*)arg2 ;

@end


//ios 8

@interface ABModel : NSObject
- (ABRecordRef)displayedMemberAtIndex:(NSInteger)index;
- (ABAddressBookRef)addressBook;
@end

@interface ABMembersDataSource : NSObject <UITableViewDataSource, UIActionSheetDelegate>
- (ABModel *)model;
- (void)deleteContact;
@end

@interface ABMembersController : NSObject
@property (nonatomic,readonly) UITableView * currentTableView; 
- (UITableView *)tableView;
@end

@interface ABMembersViewController : UIViewController
- (id)initWithModel:(ABModel *)model;
- (ABMembersController *)membersController;
- (void)personWasDeleted;
- (void)updateEditButton;
-(id)tableView;

@end

@interface ABMemberCell : UITableViewCell
- (void)setNamePieces:(NSArray *)pieces;

- (NSArray *)namePieces;
- (NSString *)namePieceForIndex:(NSUInteger)index;
- (void)setNamePiece:(NSUInteger)index toName:(NSString *)name;
- (void)adaptToEditing;
@end



