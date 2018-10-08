//
//  SalesManager.h
#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "CommonCategory.h"

//===============================================================================
//subscription product
#define ProductRemoveAd          @"" // Your Subscription ID
#define ProductOneMonth          @"" // Your Subscription ID
#define ProductThreeMonth        @"" // Your Subscription ID
#define ProductSixMonth          @"" // Your Subscription ID
#define ProductTwelveMonth       @"" // Your Subscription ID
#define ProductBoosterMonth      @"" // Your Subscription ID

//0-Testing(Sandbox Mode) 1-Producation Mode
#define isProductionMode          0//subscription receipt validation

#define keySubscriptionTrialIsOn         @"100"
#define keySubscriptionTrialExpired      @"101"
#define keySubscriptionOneMonthly        @"102"
#define keySubscriptionThreeMonthly      @"103"
#define keySubscriptionSixMonthly        @"104"
#define keySubscriptionTwelveMonthly     @"105"
#define keySubscriptionBoosterPack       @"106"

//constants
#define Password            @""     //Your app specific Password (Get From iTunes Connect)
//===============================================================================

@protocol SalesManagerProtocol <NSObject>

- (void)responseRecieved:(BOOL)failed;
@optional
- (void)itemsRestored;
- (void)productsCached;
- (void)timerFiredWithRemainingSec:(NSInteger)seconds;

@end

typedef void (^BlockCompletion) (void);

@interface SalesManager : NSObject<SKProductsRequestDelegate, SKPaymentTransactionObserver, SKRequestDelegate>
@property NSString *currentIdentifier;
@property NSArray *products;
@property NSArray *productIdentifiers;
@property SKProductsRequest *request;
@property (weak, nonatomic) id <SalesManagerProtocol> delegate;

@property(nonatomic,strong) NSString *booster_pack_id;
@property(nonatomic,strong) NSString *oneMonth_pack_id;
@property(nonatomic,strong) NSString *threeMonth_pack_id;
@property(nonatomic,strong) NSString *sixMonth_pack_id;
@property(nonatomic,strong) NSString *TwelevMonth_pack_id;
+ (SalesManager*)sharedInstance;
- (void)cacheProducts;
- (void)restorePurchases;
-(void)validateReceipeWithCompletion:(BlockCompletion)blockCompletion;
-(void)setUserSubscribedToProduct:(NSString*)productID subscribed:(BOOL)isSubscribed;
-(NSString*)subscribedProductIdIfAny;
-(void)buyItemWithIdentifier:(NSString*)productID;
-(BOOL)isProductPurchased:(NSString*)productID;

-(NSString*)subscriptionStatusCodeFromProductID:(NSString*)productID;
@end
