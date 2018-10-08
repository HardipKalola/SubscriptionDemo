

#import "CommonCategory.h"
#import <CoreLocation/CoreLocation.h>
@implementation CommonCategory

@end



@implementation NSDictionary (Helper)

-(NSString*)jsonParameterString{
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    if (jsonData) {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return @"";
}
@end

@implementation NSObject (Helper)
-(NSString*)boolString{
    id obj = self;
    if ([obj boolValue]) {
        return @"true";
    }
    return @"false";
}
-(NSString*)jsonStringFromObject{
    NSError *error;
    
    if (self != [NSNull null]) {
        NSData *dataJson = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        if (error == nil) {
            if (dataJson) {
                NSString *json = [[NSString alloc] initWithData:dataJson encoding:NSUTF8StringEncoding];
                if (json) {
                    return json;
                }
            }
        }
    }
    return @"";
}
-(id)objectFromJSONString{
    NSError *error;
    
    if (self != [NSNull null]) {
        id object = self;
        if ([object respondsToSelector:@selector(dataUsingEncoding:)]) {
            NSData *dataJson = [object dataUsingEncoding:NSUTF8StringEncoding];
            if (dataJson) {
                id object = [NSJSONSerialization JSONObjectWithData:dataJson options:NSJSONReadingMutableContainers error:&error];
                if (error == nil) {
                    if (object) {
                        return object;
                    }
                }
                
            }
        }
    }
    return [NSNull null];
}
-(BOOL)isNotEmptyString{
    id obj = self;
    if (obj) {
        if ([obj isKindOfClass:[NSString class]]) {
            if ([obj length]) {
                return YES;
            }
        }
    }
    
    return NO;
}




-(NSString*)stringFromLocation:(CLLocationCoordinate2D)coordinate{
    return [NSString stringWithFormat:@"%.4f,%.4f",coordinate.latitude,coordinate.longitude];
}
-(CLLocationCoordinate2D)locationFromString:(NSString*)string{
    NSArray *arrLocation = [string componentsSeparatedByString:@","];
    NSString *strLat = arrLocation[0];
    NSString *strLon = arrLocation[1];
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [strLat doubleValue];
    coordinate.longitude = [strLon doubleValue];
    return coordinate;
}


@end

@implementation NSString (Helper)
-(NSInteger)digitFromDocNumber{
    NSInteger digit = 0;
    for (int i=0; i<self.length; i++) {
        NSString *substring = [self substringFromIndex:i];
        if ([substring isAllDigits]) {
            digit = [substring integerValue];
            break;
        }
    }
    return digit;
}
- (BOOL)isAllDigits
{
    NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange r = [self rangeOfCharacterFromSet: nonNumbers];
    return r.location == NSNotFound && self.length > 0;
}
-(NSString*)prefixFromDocNumber{
    NSString *number = [NSString stringWithFormat:@"%d",(int)[self digitFromDocNumber]];
    NSString *substring = [self substringFromIndex:(self.length-number.length)];
    
    if ([substring isEqualToString:number]) {
        return [self substringToIndex:self.length-number.length];
    }
    return self;
}

-(NSDate*)getDateFromTimestamp{
    return [NSDate dateWithTimeIntervalSince1970:[self doubleValue]];
}
@end


@implementation UIImage (Helper)

- (UIImage *)maskedImageWithColor:(UIColor *)color
{
    UIImage *image = self;
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
    CGContextRef c = UIGraphicsGetCurrentContext();
    [image drawInRect:rect];
    CGContextSetFillColorWithColor(c, [color CGColor]);
    CGContextSetBlendMode(c, kCGBlendModeSourceAtop);
    CGContextFillRect(c, rect);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

@end

@implementation UIView (SKHelper)

-(UIImage*)imageFromView{
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 1.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

@end

@implementation UIPrintPageRenderer (PDF)
- (NSData*) printToPDF
{
    NSMutableData *pdfData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData( pdfData, self.paperRect, nil );
    [self prepareForDrawingPages: NSMakeRange(0, self.numberOfPages)];
    CGRect bounds = UIGraphicsGetPDFContextBounds();
    for ( int i = 0 ; i < self.numberOfPages ; i++ )
    {
        UIGraphicsBeginPDFPage();
        [self drawPageAtIndex: i inRect: bounds];
    }
    UIGraphicsEndPDFContext();
    return pdfData;
}
@end

@implementation UIFont (Helper)

+(UIFont*)fontRobotoRegularWithSize:(CGFloat)fontSize{
    return [UIFont fontWithName:@"Roboto-Regular" size:fontSize];
}
+(UIFont*)fontRobotoLightWithSize:(CGFloat)fontSize{
    return [UIFont fontWithName:@"Roboto-Light" size:fontSize];
}

@end

@implementation SKProduct (priceAsString)

- (NSString *) priceAsString
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[self priceLocale]];
    
    NSString *str = [formatter stringFromNumber:[self price]];
    return str;
}
@end
