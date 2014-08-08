//
//  XMLElement.m
//  kmlParser
//
//  Created by Эдуард Пятницын on 08.08.14.
//  Copyright (c) 2014 com.EduardPyatnitsyn. All rights reserved.
//

#import "XMLElement.h"

@implementation XMLElement

- (NSMutableArray *) subElements{
    if (_subElements == nil){
        _subElements = [[NSMutableArray alloc] init];
    }
    return _subElements;
}

@end
