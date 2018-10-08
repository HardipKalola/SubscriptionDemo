
//

#import "HKStorage.h"
#import "Archiver.h"
@implementation HKStorage

+(void)hk_setObject:(id)object forKey:(NSString*)key{
    NSDictionary *dicUserData = [Archiver readFile:@"user_data"];
    NSMutableDictionary *dicUserSavedData = [[NSMutableDictionary alloc] init];
    if (dicUserData) {
        [dicUserSavedData addEntriesFromDictionary:dicUserData];
    }
    [dicUserSavedData setObject:object forKey:key];
    [Archiver createFile:dicUserSavedData fileName:@"user_data"];
}
+(id)hk_objectForKey:(NSString*)key{
    
    NSDictionary *dicUserData = [Archiver readFile:@"user_data"];
    if (dicUserData) {
        if ([dicUserData isKindOfClass:[NSDictionary class]]) {
            if ([dicUserData objectForKey:key]) {
                return [dicUserData objectForKey:key];
            }
        }
    }
    return nil;
}
+(void)hk_removeObjectForKey:(NSString*)key{
    NSDictionary *dicUserData = [Archiver readFile:@"user_data"];
    if ([dicUserData objectForKey:key]) {
        NSMutableDictionary *dicUserSavedData = [[NSMutableDictionary alloc] init];
        if (dicUserData) {
            [dicUserSavedData addEntriesFromDictionary:dicUserData];
        }
        [dicUserSavedData removeObjectForKey:key];
        [Archiver createFile:dicUserSavedData fileName:@"user_data"];
    }
}


@end
