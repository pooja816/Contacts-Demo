//
//  Contact.h
//  ContactsDemo
//
//  Created by Pooja Gupta on 20/03/17.
//  Copyright © 2017 craterzone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Contact : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *emailId;
@property (nonatomic, copy) UIImage *image;
@end
