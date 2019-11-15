 

#import <Foundation/Foundation.h>

@interface APRSASigner : NSObject

- (id)initWithPrivateKey:(NSString *)privateKey;

- (NSString *)signString:(NSString *)string withRSA2:(BOOL)rsa2;

@end
