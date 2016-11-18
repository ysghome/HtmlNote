//
//  ViewController.m
//  HtmlNote
//
//  Created by apple on 16/11/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"
#import "TFHpple/TFHpple.h"
#import "TFHpple/TFHppleElement.h"
#import "TFHpple/XPathQuery.h"
#import "YYKit.h"
#import "NSString+FounqGONMarkupParser.h"
#import "HTMLElement.h"

@interface ViewController ()<YYTextViewDelegate,HTMLElementDelegate>

@property (nonatomic, strong) HTMLElement *hElement;
@property (nonatomic, strong) YYTextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *htmlString = @"蜀门手游官方社区！<h4>欢迎来到蜀门手游官方社区！</h4><p><b>一个好的社区气氛需要大家一同营造！</b></p><p><b>社区规则不是为了限制大家，而是为了让社区更好的讨论氛围~</b></p><p><b>非常感谢大家理解，希望每个人都能自觉遵守社区规则！</b></p><div class=\"img\"><img src=\"http://img.shumen.oss.founq.com/37155/2016111006001.png@!img\"></div><br/><p><font color=\"#FF0000\"><b>社区管理：</b></font></p><p><font color=\"#FF0000\"><b>蜀门小狐狸、蜀门一号机、</b></font></p><p><font color=\"#FF0000\"><b>蜀门帅四、蜀门_夜幕</b></font></p><p><b>如有发现问题，可以联系以上四位。</b></p><p><b>社区提倡多发质量贴、严禁恶意灌水。</b></p><div class=\"img\"><img src=\"http://img.shumen.oss.founq.com/37155/2016111006001.png@!img\"></div><br/><h5>删帖准则</h5><p>1.转载未注明或重复转载。</p><p>2.重复被发多次的雷同贴。</p><p>3.开贴求交易帐号，求充值等帖子。</p><p>4.各种辱骂，侮辱，进行人身攻击，针对某位玩家的帖子。</p><p>5.大量刷屏的无意义贴。</p><p>6.没经过他人同意随便爆出他人照片、ID、QQ等隐私信息。</p><p>7.黄暴话题、政治敏感话题。</p><p>8.一切形式的广告贴：各种外挂宣传，破解下载，求代练，招代练，QQ群、YY频道、CC频道、发礼包、发星钻、求礼包、留邮箱的帖子。</p><p>9.使用机器恶意刷楼的帖子。</p><p>10.恶意攻击游戏，对游戏的某种玩法或者某个角色进行恶意攻击、辱骂。</p><p>11.各类钓鱼贴，【如：回复送元宝、顶贴送激活码等】。官方活动除外。</p><p>12.内容不实的帖子【帖子内容不符合客观事实，耸人听闻】。</p><p>13.战争贴，包括任何地图黑，等级黑，名族歧视，种族歧视，个人恩怨。</p><p>14.负面鼓动贴，各类删号，卖号，鼓动玩家离开社区的帖子。</p><div class=\"img\"><img src=\"http://img.shumen.oss.founq.com/37155/2016111006001.png@!img\"></div><br/><h5>首页推荐基本准则</h5><p>帖子内容积极向上，无任何形式的广告，有一定的人气后方有机会推荐。</p><p>1.活动贴：官方发布的活动帖子。</p><p>2.原创绘画：3张以上有质量的美图并家有一定的文字说明，无明显、单一网站的LOGO，内涵图请加上文字说明，当图片失效时取消精品。</p><p>3.原创小说：1w字以上小说，内容丰富，得到其他玩家认可。</p><p>4.原创攻略：欢迎各类精品攻略，尤其欢迎数据帝，细节帝，纠结帝，对比帝。</p><p>5.其它精品：高质量非转帖的各种内容，直播等管理视情况推荐。</p><div class=\"img\"><img src=\"http://img.shumen.oss.founq.com/37155/2016111006001.png@!img\"></div><br/><h5>封号准则</h5><p>1、【封号3天】灌水刷屏大量无标题或者重复标题的帖子。</p><p>2、【封号3天】【严重者封号15天】各种辱骂，侮辱，进行人身攻击，针对某人的帖子。</p><p>3、【封号3天】发布各类广告，各种外挂宣传，破解下载，求代练，招代练， QQ群、YY频道、CC频道、发礼包、发星钻、求礼包、留邮箱的帖子。</p><p>4、【封号15天】没经过他人同意随意爆出他人的照片、QQ、账号密码等隐私信息。</p><p>5、【封号3天】各种求外挂求代练找代练的帖子。</p><p>6、【封号15天】重复发布以上严禁内容，不知悔改者。</p><br><p>最后，希望你在蜀门手游官方社区玩的开心~！</p>";
//     NSString *htmlString = @"<p>&nbsp;&nbsp;&nbsp;&nbsp;千呼万唤始出来，犹抱琵琶半遮面的《蜀门》手游终于开启尝鲜测试预约啦！原汁原味的蜀门武侠重出江湖，记忆深处的回忆重现眼前。由《蜀门》端游原班人马倾力打造，给你一个熟悉的蜀门世界！想要第一时间一睹《蜀门》手游的芳容，就赶紧来预约参与尝鲜测试吧！</p><h3><font color=\"#FF0000\">&nbsp;&nbsp;&nbsp;&nbsp;参与报名地址</font>：<a href=\"https://sojump.com/jq/10091844.aspx\">前去报名</a></h3><h3>&nbsp;&nbsp;&nbsp;&nbsp;经典职业再现</h3><p>&nbsp;&nbsp;&nbsp;&nbsp;《蜀门》手游重聚五大经典职业，还原经典江湖，青城主攻近战，擅长近距离的格斗，“暗影远望刀剑啸，血染战衣狼烟袅，携刃驰骋川穹顶，戮尽神魔唯青城。”便是他的真实写照。</p><div class=\"img\"><img src=\"http://img.shumen.oss.founq.com/37155/2016102801001.png@!img\"></div><br/><p>&nbsp;&nbsp;&nbsp;&nbsp;拥有强大的治疗能力的百花是希望的象征，用诗来描述便是“山绝云翳接穹壁，朱唇美眸繁花旖，丹心妙手转危安，月影精轮愈天地。”</p><div class=\"img\"><img src=\"http://img.shumen.oss.founq.com/37155/2016102801002.png@!img\"></div><br/><h3>&nbsp;&nbsp;&nbsp;&nbsp;重回熟悉场景</h3><p>&nbsp;&nbsp;&nbsp;&nbsp;《蜀门》手游致力于还给玩家一个记忆深处的经典蜀门，不仅职业回归经典，游戏内的场景也将逐一还原。《蜀门》手游利用现代技术还原历史经典，作为曾经出生地的凝碧崖一定是玩家记忆深处的亮点，蜀门主城成都城也一定给玩家留下很多回忆，蜀门江湖的各个角落都承载了无数玩家的美好故事，如今场景逐一还原，你们是否想再重新感受一下当年的花好月圆？</p><div class=\"img\"><img src=\"http://img.shumen.oss.founq.com/37155/2016102801003.png@!img\"></div><br/><div class=\"img\"><img src=\"http://img.shumen.oss.founq.com/37155/2016102801004.png@!img\"></div><br/><p>&nbsp;&nbsp;&nbsp;&nbsp;指上情缘，再续蜀门。感谢所有的耐心等待，为了遇见更好的《蜀门》。</p><p>《蜀门》手游官方预约站：<a href=\"http://www.shumensy.com/\">http://www.shumensy.com/</a></p><p>《蜀门》手游官方微信：shumensy_2016</p><p>《蜀门》手游官方微博：蜀门手游</p><p>《蜀门》手游官方 Q群：529777</p><br/><p>《蜀门》手游运营团队</p>";
    
    NSData  * data      = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:data];
    NSMutableArray *array = [NSMutableArray array];
    NSArray * imageElements  = [doc searchWithXPathQuery:@"//div[@class='img']"];
    for (TFHppleElement * element in imageElements) {
        NSString *srcString = [element.firstChild objectForKey:@"src"];
        if (srcString) {
            [array addObject:srcString];
        }
    }
    
    NSArray * elements  = [doc searchWithXPathQuery:@"//body"];
    TFHppleElement * element = [elements firstObject];
    _hElement = [[HTMLElement alloc] initWithElement:element withDelegate:self];
    _hElement.imageArray = array;
    NSMutableAttributedString *attributedString = _hElement.attributedText;
    
    YYTextView *textView = [YYTextView new];
    [textView setBounces:NO];
    [textView setFrame:CGRectMake(15, 0, self.view.width-30, self.view.height)];
    textView.font = [UIFont systemFontOfSize:15];
    textView.delegate = self;
//    textView.backgroundColor = [UIColor redColor];
    textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    textView.contentInset = UIEdgeInsetsMake(0, 0, -20, 0);
    [textView setScrollsToTop:NO];
    [textView setScrollEnabled:NO];
    textView.scrollIndicatorInsets = textView.contentInset;
    [textView setEditable:NO];
    [_contentView addSubview:textView];
    
//    YYLabel *textView = [YYLabel new];
//    [textView setFrame:CGRectMake(15, 0, self.view.width-30, self.view.height)];
//    textView.numberOfLines = 0;
//    textView.attributedText = attributedString;
//    textView.userInteractionEnabled = YES;
//    textView.textVerticalAlignment = YYTextVerticalAlignmentTop;
//    //    textView.backgroundColor = [UIColor redColor];
//    [_contentView addSubview:textView];
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT)];
    container.maximumNumberOfRows = 0;
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:attributedString];
    CGFloat textHeight = textLayout.textBoundingSize.height;
    textView.attributedText = attributedString;
    [textView setHeight:textHeight+20];
    [_contentView setContentSize:textView.size];
    _textView = textView;
}

- (void)htmlElement:(HTMLElement*)htmlElement withType:(HTMLElementClickType)type {
    NSLog(@"htmlElement i s %@ ...",htmlElement);
}

- (void)htmlElement:(HTMLElement*)htmlElement refreshAttributed:(NSAttributedString *)attributedText withReplaceRange:(NSRange)range {
    NSLog(@"range is %@",NSStringFromRange(range));
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:_textView.attributedText];
    [attributedString replaceCharactersInRange:range withAttributedString:attributedText];
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT)];
    container.maximumNumberOfRows = 0;
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:attributedString];
    CGFloat textHeight = textLayout.textBoundingSize.height;
    _textView.attributedText = attributedString;
    [_textView setHeight:textHeight+20];
    [_contentView setContentSize:_textView.size];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
