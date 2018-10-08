

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <StoreKit/StoreKit.h>
@interface CommonCategory : NSObject

@end




@interface NSDictionary (Helper)

-(NSString*)jsonParameterString;
@end

@interface NSObject (Helper)

-(NSString*)boolString;

-(NSString*)jsonStringFromObject;
-(id)objectFromJSONString;

-(BOOL)isNotEmptyString;


+(NSString*)stringFromLocation:(CLLocationCoordinate2D)coordinate;
+(CLLocationCoordinate2D)locationFromString:(NSString*)string;
@end

@interface UINavigationController (Helper)

-(BOOL)popToViewControllerOfKind:(Class)aClass animated:(BOOL)animated;
@end

@implementation UINavigationController (Helper)

-(BOOL)popToViewControllerOfKind:(Class)aClass animated:(BOOL)animated{
    
    UIViewController *aVC=nil;
    NSEnumerator *enumration=[self.viewControllers reverseObjectEnumerator];
    for (UIViewController *obj in enumration) {
        if ([obj isKindOfClass:aClass]) {
            aVC=obj;
            break;
        }
    }
    
    if (aVC) {
        [self popToViewController:aVC animated:animated];
        return YES;
    }
    return NO;
}

@end

#pragma mark- =========================String================================

@interface NSString (Helper)
-(NSInteger)digitFromDocNumber;
-(BOOL)isAllDigits;
-(NSString*)prefixFromDocNumber;
-(NSDate*)getDateFromTimestamp;
@end




@interface UIImage (Helper)
- (UIImage *)maskedImageWithColor:(UIColor *)color;
@end

@interface UIView (SKHelper)
-(UIImage*)imageFromView;

@end

@interface UIPrintPageRenderer (PDF)
- (NSData*) printToPDF;
@end


@interface UIFont (Helper)
+(UIFont*)fontRobotoRegularWithSize:(CGFloat)fontSize;
+(UIFont*)fontRobotoLightWithSize:(CGFloat)fontSize;
@end

@interface SKProduct (priceAsString)
@property (nonatomic, readonly) NSString *priceAsString;
@end

