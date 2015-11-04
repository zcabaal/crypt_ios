//
//  Obfuscator+Swift.m
//  Crypt
//
//  Created by Mac Owner on 02/11/2015.
//  Copyright © 2015 Crypt transfer. All rights reserved.
//

#import "Obfuscator+Swift.h"
#import "Crypt-Swift.h"

@implementation Obfuscator(Swift)
+(instancetype) initForSwift{
    return [Obfuscator newWithSalt:[AppDelegate class],[NSArray class],[NSString class], nil];
}
@end
