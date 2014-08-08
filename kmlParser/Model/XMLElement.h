//
//  XMLElement.h
//  kmlParser
//
//  Created by Эдуард Пятницын on 08.08.14.
//  Copyright (c) 2014 com.EduardPyatnitsyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLElement : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSDictionary *attributes;
@property (nonatomic, strong) NSMutableArray *subElements;
@property (nonatomic, weak) XMLElement *parent;

@end
