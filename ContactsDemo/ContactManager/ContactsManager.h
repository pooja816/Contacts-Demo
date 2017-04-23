//
//  ContactsManager.h
//  ContactsDemo
//
//  Created by Pooja Gupta on 20/03/17.
//  Copyright © 2017 craterzone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
@class Contact;


@protocol CNContactsDelegate <NSObject>



/*!
 *@author - Pooja Gupta
 * @discussion Method to set the contact details of selected contact
 * @param contact 
 > */
-(void)setContactDetails:(Contact *) contact;


/*!
 *@author - Pooja Gupta
 * @discussion Method to load all contacts fetched form from CNContactStore
 * @param contacts
 > */
-(void)loadAllContacts:(NSMutableArray *)contacts;


/*!
 *@author - Pooja Gupta
 * @discussion Method to update the contacts and will be called if any contact is added/deleted/modifed
 * @param contacts description#>
 */
-(void)updateContacts:(NSMutableArray *)contacts;
@end




@interface ContactsManager : NSObject <CNContactPickerDelegate>

@property (weak, nonatomic) id<CNContactsDelegate> delegate;

+(ContactsManager *)sharedInstance;


/*!
 *@author - Pooja Gupta
 * @discussion Method to select a contact from CNContactStore
 * @param viewController
 >*/
-(void)selectContactFromViewController:(UIViewController *)viewController;


/*!
 *@author - Pooja Gupta
 * @discussion Method to fetch all contacts from CNContactStore
 * @param viewController #>
 */
- (void)fetchAllContactsFromViewController:(UIViewController *)viewController;
@end
