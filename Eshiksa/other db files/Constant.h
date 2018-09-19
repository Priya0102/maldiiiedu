//
//  Constant.h
//  Eshiksa


#import <Foundation/Foundation.h>

@interface Constant : NSObject

+(void)executequery:(NSString *)strurl strpremeter:(NSString*)premeter withblock:(void(^)(NSData *,NSError*))block;
//globally it can be accessed & execute query is argument name and type object name

@end
