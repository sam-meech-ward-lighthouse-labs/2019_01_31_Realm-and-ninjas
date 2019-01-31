//
//  Ninja.h
//  FindANinja
//
//  Created by Sam Meech-Ward on 2019-01-31.
//  Copyright © 2019 meech-ward. All rights reserved.
//

#import <Foundation/Foundation.h>
@class House;

NS_ASSUME_NONNULL_BEGIN

@interface Ninja : NSObject

- (instancetype)initWithStyle:(NSString *)style withAge:(int)age withWeight:(double)weight withBirthdate:(NSDate *)birthdate;

@property (nonatomic, nullable) NSString *style;
@property (nonatomic) int age;
@property (nonatomic) double weight;
@property (nonatomic) NSDate *birthdate;

@property (nonatomic) House *house;

@property (nonatomic) NSArray<House *> *houses;

@end

NS_ASSUME_NONNULL_END
