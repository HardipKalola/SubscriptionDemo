
//

#import <Foundation/Foundation.h>

#define  key_user_id                            @"key_user_id"
#define  key_sub_priceOneMonth                  @"SubscriptionPriceOneMonth"
#define  key_sub_priceThreeMonth                @"SubscriptionPriceThreeMonth"
#define  key_sub_priceSixMonth                  @"SubscriptionPriceSixMonth"
#define  key_sub_priceTwelveMonth               @"SubscriptionPriceTwelveMonth"
#define  key_sub_priceBoosterPack               @"SubscriptionPriceBoosterPack"


@interface HKStorage : NSObject

+(void)hk_setObject:(id)object forKey:(NSString*)key;
+(id)hk_objectForKey:(NSString*)key;
+(void)hk_removeObjectForKey:(NSString*)key;

//+(void)setUserObject:(id)object forKey:(NSString*)key;
//+(id)userObjectForKey:(NSString*)key;
//+(void)removeUserObjectForKey:(NSString*)key;

@end
