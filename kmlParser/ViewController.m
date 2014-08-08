//
//  ViewController.m
//  kmlParser
//
//  Created by Эдуард Пятницын on 08.08.14.
//  Copyright (c) 2014 com.EduardPyatnitsyn. All rights reserved.
//

#import "ViewController.h"
#import "XMLElement.h"


@interface ViewController (){
    XMLElement *rootElement;
    XMLElement *currentElementPointer;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSXMLParser* parser = [[NSXMLParser alloc] initWithContentsOfURL:[[NSBundle mainBundle]
                                                                      URLForResource: @"borders" withExtension:@"xml"]];
    [parser setDelegate:self];
    if ([parser parse]){
        NSLog(@"The XML is parsed.");
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Parsing delegate methods

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    rootElement = nil;
    currentElementPointer = nil;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
    currentElementPointer = nil;
}

- (void)        parser:(NSXMLParser *)parser
       didStartElement:(NSString *)elementName
          namespaceURI:(NSString *)namespaceURI
         qualifiedName:(NSString *)qName
            attributes:(NSDictionary *)attributeDict{
        if (rootElement == nil){
        /* We don't have a root element. Create it and point to it */
            rootElement = [[XMLElement alloc] init];
            currentElementPointer = rootElement;
        } else {
        /* Already have root. Create new element and add it as one of
         the subelements of the current element */
            XMLElement *newElement = [[XMLElement alloc] init];
            newElement.parent = currentElementPointer;
            [currentElementPointer.subElements addObject:newElement];
            currentElementPointer = newElement;
        }
        currentElementPointer.name = elementName;
   
        currentElementPointer.attributes = attributeDict;
}

- (void)        parser:(NSXMLParser *)parser
         didEndElement:(NSString *)elementName
          namespaceURI:(NSString *)namespaceURI
         qualifiedName:(NSString *)qName{
    
    currentElementPointer = currentElementPointer.parent;
    
}


- (void)        parser:(NSXMLParser *)parser
       foundCharacters:(NSString *)string{
    
    if ([currentElementPointer.text length] > 0){
        currentElementPointer.text =
        [currentElementPointer.text stringByAppendingString:string];
    } else {
        currentElementPointer.text = string;
    }
    
}

- (IBAction)btnPrsd:(id)sender {
    NSLog(@"btnPrsd");
    self.countryArray = [[NSMutableArray alloc] init];
    for (XMLElement *element in rootElement.subElements) {
        NSMutableDictionary *country = [[NSMutableDictionary alloc] initWithCapacity:1];
        //Country *country = [[Country alloc] init];
        XMLElement *tempElement = element.subElements[0];
        [country setObject:tempElement.text forKey:@"name"];
        //country.name = tempElement.text;
        
        
        tempElement = element.subElements[4];
        tempElement = tempElement.subElements[1];
        tempElement = tempElement.subElements[0];
        tempElement = tempElement.subElements[0];
        tempElement = tempElement.subElements[0];
        [country setObject:tempElement.text forKey:@"coords"];
        //country.coords = tempElement.text;
        [self.countryArray addObject:country];
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *arrayPath = [[paths objectAtIndex:0]
                            stringByAppendingPathComponent:@"borders.plist"];
    
    [NSKeyedArchiver archiveRootObject: self.countryArray toFile:arrayPath];
    
    //[self.countryArray writeToFile:arrayPath atomically:YES];
    
    NSArray *arrayFromFile = [NSKeyedUnarchiver unarchiveObjectWithFile: arrayPath];
    // Print the contents
    for (NSDictionary *element in arrayFromFile)
        NSLog(@"Name: %@    coords:%@", [element objectForKey:@"name"], [element objectForKey:@"coords"]);
}
@end
