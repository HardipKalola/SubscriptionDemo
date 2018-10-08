
#import "SalesManager.h"
#import "HKStorage.h"


@interface SalesManager () 

@end


@implementation SalesManager

+ (SalesManager*)sharedInstance {
    static SalesManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        
        self.booster_pack_id = ProductBoosterMonth;
        self.oneMonth_pack_id = ProductOneMonth;
        self.threeMonth_pack_id = ProductThreeMonth;
        self.sixMonth_pack_id = ProductSixMonth;
        self.TwelevMonth_pack_id = ProductTwelveMonth;
        self.productIdentifiers = @[self.booster_pack_id,self.oneMonth_pack_id,self.threeMonth_pack_id,self.sixMonth_pack_id,self.TwelevMonth_pack_id];

    }
    return self;
}

- (void)cacheProducts {
    [self validateProductIdentifiers:self.productIdentifiers];
}


- (void)validateProductIdentifiers:(NSArray *)identifiers {
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc]
                                          initWithProductIdentifiers:[NSSet setWithArray:identifiers]];
    
    // Keep a strong reference to the request.
    self.request = productsRequest;
    productsRequest.delegate = self;
    [productsRequest start];
}

// SKProductsRequestDelegate protocol method
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"Products received %@",response.products);
    self.products = response.products;
    
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *item = nil;
    
    for (SKProduct *product in self.products) {
        item = [NSMutableDictionary dictionaryWithDictionary:[storage objectForKey:product.productIdentifier]];
        item[@"price"] = product.priceAsString;
        [storage setObject:item forKey:product.productIdentifier];
        NSLog(@"ID =%@ & Price =%@",product.productIdentifier,product.priceAsString);
        
        //Price Store In User Default
        if ([product.productIdentifier isEqualToString:ProductOneMonth]) {
            [HKStorage hk_setObject:product.priceAsString forKey:key_sub_priceOneMonth];
        }
        if ([product.productIdentifier isEqualToString:ProductThreeMonth]) {
            [HKStorage hk_setObject:product.priceAsString forKey:key_sub_priceThreeMonth];

        }
        if ([product.productIdentifier isEqualToString:ProductSixMonth]) {
            [HKStorage hk_setObject:product.priceAsString forKey:key_sub_priceSixMonth];

        }
        if ([product.productIdentifier isEqualToString:ProductTwelveMonth]) {
            [HKStorage hk_setObject:product.priceAsString forKey:key_sub_priceTwelveMonth];

        }
        if ([product.productIdentifier isEqualToString:ProductBoosterMonth]) {
            [HKStorage hk_setObject:product.priceAsString forKey:key_sub_priceBoosterPack];
        }
    }
    
    [storage setBool:YES forKey:@"pricesCached"];
    [storage synchronize];
    
    if ([self.delegate respondsToSelector:@selector(productsCached)]) {
        [self.delegate productsCached];
    }
}

//response for productRequest
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    //NSLog(@"%@", error);
    
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    
    if (![storage boolForKey:@"pricesCached"]) {
        [self.delegate responseRecieved:YES];
    } else {
        //products cached before
        [self.delegate productsCached];
    }
}

- (void)makePaymentRequestForProduct:(SKProduct *)product {
    
//    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
//        //NSLog(@"connection unavailable");
//        [self.delegate responseRecieved:YES];
//    } else {
        //NSLog(@"connection available");
        SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
        //payment.quantity = 1;
        [[SKPaymentQueue defaultQueue] addPayment:payment];
//    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    
    for (SKPaymentTransaction *transaction in transactions) {
        
        switch (transaction.transactionState) {
                // Call the appropriate custom method for the transaction state.
            case SKPaymentTransactionStatePurchasing:
                //NSLog(@"purchasing");
                break;
            case SKPaymentTransactionStateDeferred:
                //NSLog(@"deffered");
                break;
            case SKPaymentTransactionStateFailed:
                [self transactionFailed:transaction];
                
                break;
            case SKPaymentTransactionStatePurchased:
                [self transactionSuccess:transaction];
                //NSLog(@"purchased");
                break;
            case SKPaymentTransactionStateRestored:
                [self transactionRestored:transaction];
                //NSLog(@"restored");
                break;
            default:
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                // For debugging
                //NSLog(@"StoreKit transaction state %@", @(transaction.transactionState));
                break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    //NSLog(@"Error here");
    [self.delegate responseRecieved:YES];
}

- (void)transactionFailed:(SKPaymentTransaction *)transaction {
    //NSLog(@"Purchase Failed.");

    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [self.delegate responseRecieved:YES];
}

- (void)transactionRestored:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)transactionSuccess:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    //NSLog(@"Purchase Sucessfully.");
    //[self.delegate responseRecieved:NO];
    if ([self.currentIdentifier isEqualToString:self.oneMonth_pack_id] ||
        [self.currentIdentifier isEqualToString:self.threeMonth_pack_id] ||
        [self.currentIdentifier isEqualToString:self.sixMonth_pack_id] ||
        [self.currentIdentifier isEqualToString:self.TwelevMonth_pack_id] ||
        [self.currentIdentifier isEqualToString:self.booster_pack_id]) {
        
        //all set to invalide
        [[SalesManager sharedInstance] setUserSubscribedToProduct:self.oneMonth_pack_id subscribed:NO];
        [[SalesManager sharedInstance] setUserSubscribedToProduct:self.threeMonth_pack_id subscribed:NO];
        [[SalesManager sharedInstance] setUserSubscribedToProduct:self.sixMonth_pack_id subscribed:NO];
        [[SalesManager sharedInstance] setUserSubscribedToProduct:self.TwelevMonth_pack_id subscribed:NO];
        [[SalesManager sharedInstance] setUserSubscribedToProduct:self.booster_pack_id subscribed:NO];

        //only one is valid
        [[SalesManager sharedInstance] setUserSubscribedToProduct:self.currentIdentifier subscribed:YES];
        
        [self.delegate responseRecieved:NO];
    }
}


- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {

    [self validateReceipeWithCompletion:^{
        //[self.delegate responseRecieved:NO];
        if ([self.delegate respondsToSelector:@selector(itemsRestored)]) {
            [self.delegate itemsRestored];
        }
    }];
    
    //NSLog(@"restoring finished");
}

- (void)buyItem {
    
    if (!self.products) {
        [self.delegate responseRecieved:YES];
        return;
    }
    for (SKProduct *product in self.products) {
        if ([product.productIdentifier isEqualToString:self.currentIdentifier]) {
            [self makePaymentRequestForProduct:product];
            break;
        }
    }
}


- (void)restorePurchases {
//    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue]restoreCompletedTransactions];
}

-(void)buyItemWithIdentifier:(NSString*)productID{
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"currentReceipt"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.currentIdentifier = [NSString stringWithFormat:@"%@",productID];
    [self buyItem];
}
-(BOOL)isProductPurchased:(NSString*)productID{
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    NSDictionary *product = [storage objectForKey:productID];
    return [product[@"purchased"] boolValue];
}
-(NSString*)subscribedProductIdIfAny{
    
    if ([self isProductPurchased:self.oneMonth_pack_id]) {
        return self.oneMonth_pack_id;
    }
    if ([self isProductPurchased:self.threeMonth_pack_id]) {
        return self.threeMonth_pack_id;
    }
    if ([self isProductPurchased:self.sixMonth_pack_id]) {
        return self.sixMonth_pack_id;
    }
    if ([self isProductPurchased:self.TwelevMonth_pack_id]) {
        return self.TwelevMonth_pack_id;
    }
    if ([self isProductPurchased:self.booster_pack_id]) {
        return self.booster_pack_id;
    }
    return @"";
}
-(void)setUserSubscribedToProduct:(NSString*)productID subscribed:(BOOL)isSubscribed{
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *item = [NSMutableDictionary dictionaryWithDictionary:[storage objectForKey:productID]];
    item[@"purchased"] = [NSNumber numberWithBool:isSubscribed];
    [storage setObject:item forKey:productID];
    
    if (!isSubscribed) {
        if ([storage objectForKey:@"currentReceipt"]) {
            [storage removeObjectForKey:@"currentReceipt"];
        }
    }
    [storage synchronize];
}
-(void)setExpireDateForProduct:(NSString*)productID expireDate:(double)expire_date_ms{
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *item = [NSMutableDictionary dictionaryWithDictionary:[storage objectForKey:productID]];
    
    if ([[item allKeys] containsObject:@"expire"]) {
        double current_expire = [item[@"expire"] doubleValue];
        if (expire_date_ms > current_expire) {
            //subscription extended
        
        }
    }
    item[@"expire"] = [NSNumber numberWithDouble:expire_date_ms];
    [storage setObject:item forKey:productID];
    [storage synchronize];
}

-(void)validateReceipeWithCompletion:(BlockCompletion)blockCompletion{
        
    NSURL *url = [[NSBundle mainBundle] appStoreReceiptURL];
    if ([[NSFileManager defaultManager] fileExistsAtPath:url.path]) {
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSDictionary *receiptDictionary = @{@"receipt-data":[data base64EncodedStringWithOptions:(NSDataBase64EncodingEndLineWithLineFeed)],@"password":Password};
        
        NSData *dataToSend = [NSJSONSerialization dataWithJSONObject:receiptDictionary options:NSJSONWritingPrettyPrinted error:nil];
        
        NSURL *storeURL = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
        if (isProductionMode == 1) {
            storeURL = [NSURL URLWithString:@"https://buy.itunes.apple.com/verifyReceipt"];
        }
        
        NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
        [storeRequest setHTTPMethod:@"POST"];
        
        [storeRequest setHTTPBody:dataToSend];
        
        // Make a connection to the iTunes Store on a background queue.
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:storeRequest queue:queue
         
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   
                                   if (connectionError) {
                                       //NSLog(@"error %@",connectionError.description);
                                   } else {
                                       
                                       NSError *error;
                                       
                                       NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                       //NSLog(@"jsonResponse %@",jsonResponse);
                                       //this is JSON response
//                                       jsonResponse {
//                                           environment = Sandbox;
//                                           status = 21004;
//                                       }

                                       BOOL isSubscriptionInEffect = NO;
                                       double expire_date_ms = 0;
                                       NSDictionary *dicReceiptCurrent = nil;
                                       
                                       if (jsonResponse) {
                                           if ([jsonResponse objectForKey:@"latest_receipt_info"]) {
                                               NSArray *arrLatestReceipt = [jsonResponse objectForKey:@"latest_receipt_info"];

                                               arrLatestReceipt = [arrLatestReceipt sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                                                   
                                                  NSInteger obj1PurchaseMS = [[obj1 objectForKey:@"purchase_date_ms"] integerValue];
                                                  NSInteger obj2PurchaseMS = [[obj2 objectForKey:@"purchase_date_ms"] integerValue];
                                                   
                                                   return obj2PurchaseMS > obj1PurchaseMS;
                                               }];
                                               NSLog(@"receipt count %d",(int)arrLatestReceipt.count);
                                               
                                               for (int i=0; i<arrLatestReceipt.count; i++) {
                                                   NSDictionary *dicReceipt = [arrLatestReceipt objectAtIndex:i];
                                                   NSString *productID = [NSString stringWithFormat:@"%@",[dicReceipt objectForKey:@"product_id"]];
                                                   if ([productID isEqualToString:self.oneMonth_pack_id] ||
                                                       [productID isEqualToString:self.threeMonth_pack_id] ||
                                                       [productID isEqualToString:self.sixMonth_pack_id] ||
                                                       [productID isEqualToString:self.TwelevMonth_pack_id] ||
                                                       [productID isEqualToString:self.booster_pack_id])
                                                   {
                                                 
                                                       double expireDate = [[dicReceipt objectForKey:@"expires_date_ms"] doubleValue];
                                                       NSTimeInterval timeIntervalNow = [[NSDate date] timeIntervalSince1970];
                                                       
                                                       if (timeIntervalNow*1000 < expireDate) {
                                                           //
                                                           expire_date_ms = expireDate;
                                                           dicReceiptCurrent = dicReceipt;
                                                           isSubscriptionInEffect = YES;
                                                           NSUInteger timeRemaining = ((expireDate-timeIntervalNow*1000)/1000.0);
                                                           NSLog(@"time remaing %ld seconds",(long)timeRemaining);
                                                           break;
                                                       }
                                                   }
                                               }
                                           }
                                       }
                                       
                                       for (NSString *product_identifier in self.productIdentifiers) {
                                           [[SalesManager sharedInstance] setUserSubscribedToProduct:product_identifier subscribed:NO];
                                       }
                                       
                                       if (isSubscriptionInEffect) {
                                           //NSLog(@"Subscription is in effect");
                                           //NSLog(@"dicReceiptCurrent %@",dicReceiptCurrent);
                                           NSString *productID = [NSString stringWithFormat:@"%@",[dicReceiptCurrent objectForKey:@"product_id"]];
                                           
                                           [[NSUserDefaults standardUserDefaults] setObject:dicReceiptCurrent forKey:@"currentReceipt"];
                                           [[NSUserDefaults standardUserDefaults] synchronize];
                                           
                                           [[SalesManager sharedInstance] setExpireDateForProduct:productID expireDate:expire_date_ms];
                                           [[SalesManager sharedInstance] setUserSubscribedToProduct:productID subscribed:YES];
                                           
                                       }else{
                                           //NSLog(@"Subscription NOT in effect");
                                       }
                                       
                                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                           if (blockCompletion) {
                                               blockCompletion();
                                           }
                                       });
                                   }
                                   
                               }];
        
    }else{
        //no receipt
        if (blockCompletion) {
            blockCompletion();
        }
    }
}
-(NSString*)subscriptionStatusCodeFromProductID:(NSString*)productID{
    if (productID && productID.length) {
        if ([productID isEqualToString:ProductOneMonth]) {
            return keySubscriptionOneMonthly;
        }
        if ([productID isEqualToString:ProductThreeMonth]) {
            return keySubscriptionThreeMonthly;
        }
        if ([productID isEqualToString:ProductSixMonth]) {
            return keySubscriptionSixMonthly;
        }
        if ([productID isEqualToString:ProductTwelveMonth]) {
            return keySubscriptionTwelveMonthly;
        }
        if ([productID isEqualToString:ProductBoosterMonth]) {
            return keySubscriptionBoosterPack;
        }
    }
    return nil;
}

@end
