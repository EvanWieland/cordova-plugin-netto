//
//  Netto.m
//  Netto
//
//  Created by Evan Wieland https://bitsmithy.io on 1/18/18.
//

#import "Netto.h"

#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>

@implementation Netto

static NSString *const DataCounterKeyRxBytes = @"receivedBytes";
static NSString *const DataCounterKeyTxBytes = @"transmittedBytes";
static NSString *const DataCounterKeyTotalBytes = @"totalBytes";

//
// Dictionary credits:
// https://stackoverflow.com/a/8014012/3957465
//

NSDictionary *TrafficCounter(NSString *InitialRx, NSString *InitialTx, NSString *InitialTotal)
{
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;

    u_int32_t InitialRxBytes    = [InitialRx intValue];
    u_int32_t InitialTxBytes    = [InitialTx intValue];
    u_int32_t InitialTotalBytes = [InitialTotal intValue];

    u_int32_t WiFiSent = 0;
    u_int32_t WiFiReceived = 0;
    u_int32_t WWANSent = 0;
    u_int32_t WWANReceived = 0;

    u_int32_t RawRxBytes = 0;
    u_int32_t RawTxBytes = 0;
    u_int32_t RawTotalBytes = 0;

    u_int32_t RxBytes = 0;
    u_int32_t TxBytes = 0;
    u_int32_t TotalBytes = 0;

    if (getifaddrs(&addrs) == 0)
    {
        cursor = addrs;
        while (cursor != NULL)
        {
            if (cursor->ifa_addr->sa_family == AF_LINK)
            {
                #ifdef DEBUG
                const struct if_data *ifa_data = (struct if_data *)cursor->ifa_data;
                if(ifa_data != NULL)
                {
                    NSLog(@"Interface name %s: sent %tu received %tu",cursor->ifa_name,ifa_data->ifi_obytes,ifa_data->ifi_ibytes);
                }
                #endif

                // Name of interfaces:
                // en0 is WiFi
                // pdp_ip0 is WWAN
                NSString *name = [NSString stringWithFormat:@"%s",cursor->ifa_name];
                if ([name hasPrefix:@"en"])
                {
                    const struct if_data *ifa_data = (struct if_data *)cursor->ifa_data;
                    if(ifa_data != NULL)
                    {
                        WiFiSent += ifa_data->ifi_obytes;
                        WiFiReceived += ifa_data->ifi_ibytes;
                    }
                }

                if ([name hasPrefix:@"pdp_ip"])
                {
                    const struct if_data *ifa_data = (struct if_data *)cursor->ifa_data;
                    if(ifa_data != NULL)
                    {
                        WWANSent += ifa_data->ifi_obytes;
                        WWANReceived += ifa_data->ifi_ibytes;
                    }
                }

            }

            cursor = cursor->ifa_next;
        }

        freeifaddrs(addrs);
    }

    RawRxBytes    = WiFiReceived + WWANReceived;
    RawTxBytes    = WiFiSent + WWANSent;
    RawTotalBytes = RawRxBytes + RawTxBytes;

    RxBytes    = RawRxBytes    - InitialRxBytes;
    TxBytes    = RawTxBytes    - InitialTxBytes;
    TotalBytes = RawTotalBytes - InitialTotalBytes;

    return @{
             DataCounterKeyRxBytes:[NSNumber numberWithUnsignedInt:RxBytes],
             DataCounterKeyTxBytes:[NSNumber numberWithUnsignedInt:TxBytes],
             DataCounterKeyTotalBytes:[NSNumber numberWithUnsignedInt:TotalBytes]
    };
}

- (void) traffic:(CDVInvokedUrlCommand*)command {

    [self.commandDelegate runInBackground:^{
        NSString *callbackId = [command callbackId];
        CDVPluginResult* result = nil;

        NSString *InitialRxBytes = [command.arguments objectAtIndex:0];
        NSString *InitialTxBytes = [command.arguments objectAtIndex:1];
        NSString *InitialTotalBytes = [command.arguments objectAtIndex:2];

        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:TrafficCounter(InitialRxBytes, InitialTxBytes, InitialTotalBytes)];

        [self.commandDelegate sendPluginResult:result callbackId:callbackId];
    }];
}

@end
