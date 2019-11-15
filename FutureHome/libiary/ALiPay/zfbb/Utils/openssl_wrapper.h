 
#import <Foundation/Foundation.h>

int rsa_sign_with_private_key_pem(char *message, int message_length
                                  , unsigned char *signature, unsigned int *signature_length
                                  , char *private_key_file_path, BOOL rsa2);
NSString *base64StringFromData(NSData *signature);
