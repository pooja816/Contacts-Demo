//
//  ViewController.m
//  ContactsDemo
//
//  Created by Pooja Gupta on 20/03/17.
//  Copyright © 2017 craterzone. All rights reserved.
//

#import "ContactsVC.h"
#import "ContactsManager.h"
#import "Contact.h"


@interface ContactsVC () <CNContactsDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *_contactsArray;
}
@property (weak, nonatomic) IBOutlet UIButton *selectContactButton;
@property (weak, nonatomic) IBOutlet UIImageView *contactImageView;
@property (weak, nonatomic) IBOutlet UILabel *fullnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailIdLabel;
@property (weak, nonatomic) IBOutlet UIButton *getAllContactsButton;
@property (weak, nonatomic) IBOutlet UITableView *contactsTableView;

@end


static NSString *CELL_REUSE_IDENTIFIER = @"Cell";


@implementation ContactsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.contactsTableView.delegate = self;
    self.contactsTableView.dataSource = self;
    
    
    [self.contactsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_REUSE_IDENTIFIER];
}

#pragma mark - IBAction
- (IBAction)selectContactButtonClicked:(id)sender {
    [ContactsManager sharedInstance].delegate = self;
    [[ContactsManager sharedInstance] selectContactFromViewController:self];
    
}


- (IBAction)getAllContactsButtonClicked:(id)sender {
    [ContactsManager sharedInstance].delegate = self;
    [[ContactsManager sharedInstance] fetchAllContactsFromViewController:self];
    
}

#pragma mark - TableView Delegate & DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _contactsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSE_IDENTIFIER];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_REUSE_IDENTIFIER];
    }
    
    Contact *contact = (Contact *)[_contactsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = contact.name;
    cell.imageView.image = contact.image;
    cell.detailTextLabel.text = contact.emailId;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - CNContactDelegate Methods
-(void)setContactDetails:(Contact *) contact{
    self.fullnameLabel.text = contact.name;
    self.phoneNumberLabel.text = contact.phone;
    self.emailIdLabel.text = contact.emailId;
    self.contactImageView.image = contact.image;
}

-(void)loadAllContacts:(NSMutableArray *)contacts{
    [self refereshListWithContacts:contacts];
}

-(void)updateContacts:(NSMutableArray *)contacts{
    [self refereshListWithContacts:contacts];
}

-(void)refereshListWithContacts:(NSMutableArray *)contacts{
    _contactsArray = contacts;
    [self.contactsTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
