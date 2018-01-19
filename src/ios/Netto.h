//
//  Netto.h
//  Netto
//
//  Created by Evan Wieland https://bitsmithy.io on 1/18/18.
//

#import <Cordova/CDV.h>

@interface Netto : CDVPlugin

- (void) traffic:(CDVInvokedUrlCommand*)command;

@end