//
//  ContactsUtil.m
//  ContactsDemo
//
//  Created by Pooja Gupta on 20/03/17.
//  Copyright © 2017 craterzone. All rights reserved.
//

#import "ContactsManager.h"
#import "Contact.h"


@implementation ContactsManager{
    NSMutableArray *_totalPhoneNumberArray;
    CNContactStore *contactStore;
    NSMutableArray *groupsOfContact;
}

+(ContactsManager *) sharedInstance{
    static ContactsManager *contactsManager = nil;
    static dispatch_once_t once;
    dispatch_once(&once,^{
        contactsManager = [[ContactsManager alloc] init];
    });
    return contactsManager;

}

- (id)init { //init method
    if (self = [super init]) {
        _totalPhoneNumberArray = [NSMutableArray array]; //init a mutableArray
    }
    return self;
}

-(void)getPermissionToUser {
    
    [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError *error) {
        //permission Request alert will show here.
        
        if (granted) { //if user allow to access a contacts in this app.
            [self fetchContactsFromContactsFrameWork]; //access contacts
        } else {
           
            // Navigate to Settings page to enable the access
           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }];
    
}


#pragma mark - Fetch all contacts
//Method of fetch contacts from Addressbooks or Contacts framework
- (void)fetchAllContactsFromViewController:(UIViewController *)viewController{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contactStoreChanged:) name:CNContactStoreDidChangeNotification object:nil];
    
    groupsOfContact = [@[] mutableCopy]; //init a mutable array
    
    //In iOS 9 and above, use Contacts.framework
    if (NSClassFromString(@"CNContactStore")) { //if Contacts.framework is available
        contactStore = [[CNContactStore alloc] init]; //init a contactStore object
        
        //Check contacts authorization status using Contacts.framework entity
        switch ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts]) {
                
            case CNAuthorizationStatusNotDetermined: { //Address book status not determined.
                [self getPermissionToUser];
            }
                break;
            case CNAuthorizationStatusAuthorized: { //Contact access permission is already authorized.
                [self fetchContacts]; //access contacts
            }
                break;
            default: { //else ask permission to user
                [self getPermissionToUser];
            }
                break;
        }
        
    }
}

-(void)fetchContacts{
    
    _totalPhoneNumberArray = [self fetchContactsFromContactsFrameWork];
    
    if ([self.delegate respondsToSelector:@selector(loadAllContacts:)]) {
        [self.delegate loadAllContacts:_totalPhoneNumberArray];
    }
}

- (NSMutableArray *)fetchContactsFromContactsFrameWork { //access contacts using contacts.framework
    
    NSArray *keyToFetch = @[CNContactEmailAddressesKey,CNContactFamilyNameKey,CNContactGivenNameKey,CNContactPhoneNumbersKey,CNContactPostalAddressesKey,CNContactImageDataKey,CNContactIdentifierKey]; //contacts list key params to access using contacts.framework
    
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keyToFetch]; //Contacts fetch request parrams object allocation
    
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        [groupsOfContact addObject:contact]; //add objects of all contacts list in array
    }];
    
    NSMutableArray *phoneNumberArray = [@[] mutableCopy]; // init a mutable array

    //generate a custom dictionary to access
    for (CNContact *contact in groupsOfContact) {

        [phoneNumberArray addObject:[self getFullContactDetail:contact]];
    }
    
    return [phoneNumberArray mutableCopy]; //get a copy of all contacts list to array.
    
}




#pragma mark - Get details of contact selected
-(void)selectContactFromViewController:(UIViewController *)viewController{
    CNContactPickerViewController *contactPicker = [CNContactPickerViewController new];
    
    contactPicker.delegate = self;
    
    [viewController presentViewController:contactPicker animated:YES completion:nil];
}


-(Contact *)getFullContactDetail:(CNContact *)contact{
    Contact *contactDetail = [Contact new];
    
    contactDetail.name = [self getFullName:contact];
    contactDetail.phone = [self getPhoneNumber:contact];
    contactDetail.emailId = [self getEmailId:contact];
    contactDetail.image = [self getContactImage:contact];
    
    return contactDetail;
}

-(NSString *)getFullName:(CNContact *)contact{
    NSString *fullName = [NSString stringWithFormat:@"%@ %@",contact.givenName,contact.familyName];
    return ((fullName.length > 0) ? fullName : @"");
}

-(NSString *)getPhoneNumber:(CNContact *)contact{
    NSString *phone;
    
    for(CNLabeledValue * phonelabel in contact.phoneNumbers) {
        CNPhoneNumber * phoneNo = phonelabel.value;
        phone = [phoneNo stringValue];
    }
    
    return (phone.length > 0) ? phone : @"";
    
}

-(NSString *)getEmailId:(CNContact *)contact{
    NSString *emailId;
    
    for(CNLabeledValue * emaillabel in contact.emailAddresses) {
        emailId = emaillabel.value;
    }
    
    return ((emailId.length > 0) ? emailId : @"");
}


-(UIImage *)getContactImage:(CNContact *)contact{
    UIImage * contactImage;
    
    if(contact.imageData) {
        NSData * imageData = (NSData *)contact.imageData;
        contactImage = [[UIImage alloc] initWithData:imageData];
    }
    return contactImage;
}



#pragma mark - ContactPicker delegate
- (void) contactPicker:(CNContactPickerViewController *)picker

      didSelectContact:(CNContact *)contact {
    
    [self setContactDetails:contact];
}

-(void)setContactDetails:(CNContact *)contactObject {
    
    if ([self.delegate respondsToSelector:@selector(setContactDetails:)]) {
        [self.delegate setContactDetails:[self getFullContactDetail:contactObject]];
    }
        
}


#pragma mark - Contact Store changed Notification
-(void)contactStoreChanged:(NSNotification *)aNotification{
    NSLog(@"%@",aNotification);
    [self updateContacts];
}

-(void)updateContacts{
    _totalPhoneNumberArray = [self fetchContactsFromContactsFrameWork];
    
    if ([self.delegate respondsToSelector:@selector(updateContacts:)]) {
        [self.delegate updateContacts:_totalPhoneNumberArray];
    }
}


@end
