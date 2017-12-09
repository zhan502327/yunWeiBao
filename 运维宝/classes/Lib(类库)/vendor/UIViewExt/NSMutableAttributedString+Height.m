#import "NSMutableAttributedString+Height.h"
#define kConstWidth 300
#define kFontSize 13

@implementation NSMutableAttributedString (Height)

+(NSMutableAttributedString*)attributedStringWithString:(NSString *)theString
                                               fontName:(NSString *)theFontName
                                              fontColor:(UIColor *)theColor
                                               fontSize:(CGFloat)theSize
                                              wordSpace:(CGFloat)theWordSpace
                                              lineSpace:(CGFloat)theLineSpace
                                             headIndent:(CGFloat)theHeadIndent
                                              topIndent:(CGFloat)theTopIndent
                                             leftIndent:(CGFloat)theLeftIndent
                                           bottomIndent:(CGFloat)theBottomIndent
                                            rightIndent:(CGFloat)theRightIndent
                                             aligenment:(NSTextAlignment)theAligenment
{
    if (!theString) return nil;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:theString];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineHeightMultiple:theLineSpace];
    [paragraphStyle setLineSpacing:theLineSpace];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    [paragraphStyle setAlignment:theAligenment];
    [paragraphStyle setFirstLineHeadIndent:(theSize+theWordSpace)*theHeadIndent];
    [paragraphStyle setHeadIndent:theLeftIndent];
    [paragraphStyle setTailIndent:-theRightIndent];
    [paragraphStyle setParagraphSpacingBefore:theTopIndent];
    [paragraphStyle setParagraphSpacing:theBottomIndent];
    
    NSRange range = NSMakeRange(0, [theString length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
//    字体
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:theSize] range:range];
    [attributedString addAttribute:NSForegroundColorAttributeName value:theColor range:range];
    [attributedString addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:theWordSpace] range:range];
    
    return attributedString;
}

//获取字符串高度
- (CGFloat)getSelfTextHeight:(float)width{
    
    if(self.string.length==0) return 0;
    NSRange range = NSMakeRange(0, 0);
    NSDictionary *dict = [self attributesAtIndex:0 effectiveRange:&range];
    CGSize size = [self.string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    
    return size.height;
    
}

//获取字符串高度
- (CGFloat)getSelfTextHeight{
    
    if(self.string.length==0) return 0;
    NSRange range = NSMakeRange(0, 0);
    NSDictionary *dict = [self attributesAtIndex:0 effectiveRange:&range];
    CGSize size = [self.string boundingRectWithSize:CGSizeMake(kConstWidth, CGFLOAT_MAX) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    
    return size.height;
    
}

- (CGSize)getSelfTextSizeWithWidth:(CGFloat)width
{
    if(self.string.length==0) return CGSizeZero;
    NSRange range = NSMakeRange(0, 0);
    NSDictionary *dict = [self attributesAtIndex:0 effectiveRange:&range];
    CGSize size = [self.string boundingRectWithSize:CGSizeMake(width,   CGFLOAT_MAX) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    
    return size;
}

@end
