

#import "ChineseToPinyin.h"
#import "PinYin4Objc.h"

@implementation ChineseToPinyin

static inline NSString* pinYin(NSString* tempStr)
{
    NSString* sourceText = tempStr;
    HanyuPinyinOutputFormat* outputFormat = [[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeLowercase];
    NSString* outputPinyin = [PinyinHelper toHanyuPinyinStringWithNSString:sourceText withHanyuPinyinOutputFormat:outputFormat withNSString:@" "];
    return outputPinyin;
}

+ (NSString*)pinyinFromChineseString:(NSString*)string
{
    if (!string || ![string length])
        return nil;
    return pinYin(string);
}

+ (char)sortSectionTitle:(NSString*)string
{
    int cLetter = 0;
    if (!string || 0 == [string length])
        cLetter = '#';
    else {
        cLetter = [[[self pinyinFromChineseString:string] lowercaseString] characterAtIndex:0];
    }

    return cLetter;
}

@end