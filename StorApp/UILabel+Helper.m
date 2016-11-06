//
//  UILabel+Helper.m
//  Stor
//
//  Created by Darran Hall on 11/5/16.
//  Copyright © 2016 Stor App. All rights reserved.
//

#import "UILabel+Helper.h"

@implementation UILabel (Helper)

- (void)setSubstituteFontName:(NSString *)name UI_APPEARANCE_SELECTOR {
    
    self.font = [UIFont fontWithName:name size:self.font.pointSize];

}

@end
