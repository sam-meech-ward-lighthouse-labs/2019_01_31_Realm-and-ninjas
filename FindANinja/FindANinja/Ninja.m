//
//  Ninja.m
//  FindANinja
//
//  Created by Sam Meech-Ward on 2019-01-31.
//  Copyright © 2019 meech-ward. All rights reserved.
//

#import "Ninja.h"
#import "FindANinja-Swift.h"

@implementation Ninja

- (instancetype)initWithStyle:(NSString *)style withAge:(int)age withWeight:(double)weight withBirthdate:(NSDate *)birthdate
{
  self = [super init];
  if (self) {
    _style = style;
    _age = age;
    _weight = weight;
    _birthdate = birthdate;
    
    _house = [[House alloc] init];
    
  }
  return self;
}

@end
