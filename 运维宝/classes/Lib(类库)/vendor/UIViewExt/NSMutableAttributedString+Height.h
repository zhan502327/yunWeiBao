#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (Height)

/**
 *  按照格式生成MutableAttributedString字符串
 *
 *  @param theString       文本字符串
 *  @param theFontName     字体名称
 *  @param theColor        字体颜色
 *  @param theSize         字体大小
 *  @param theWordSpace    字间距
 *  @param theLineSpace    行间距
 *  @param theHeadIndent   首行缩进字符个数
 *  @param theTopIndent    段落顶部空间
 *  @param theLeftIndent   段落左侧缩进
 *  @param theBottomIndent 段落底部缩进
 *  @param theRightIndent  段落右侧缩进
 *  @param theAligenment   排版方式
 *
 *  @return 可变属性字符串
 */
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
                                                aligenment:(NSTextAlignment)theAligenment;

- (CGFloat)getSelfTextHeight:(float)width;
- (CGFloat)getSelfTextHeight;
- (CGSize)getSelfTextSizeWithWidth:(CGFloat)width;
@end
