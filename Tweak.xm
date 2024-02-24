#import <PSHeader/CameraApp/CameraApp.h>
#import <PSHeader/CameraMacros.h>
#import <theos/IOSMacros.h>
#import <version.h>

@interface CAMModeDialItem (Addition)
@property(retain, nonatomic) UILabel *label;
@end

static NSString *emojiForMode(NSInteger mode) {
    switch (mode) {
        case 0:
            return @"🖼";
        case 1:
            return @"📹";
        case 2:
            return @"🐢";
        case 3:
            return @"🎞";
        case 4:
            return @"🔲";
        case 5:
            return IS_IOS_OR_NEWER(iOS_10_0) ? @"⏳" : @"⚙️";
        case 6:
            return IS_IOS_OR_NEWER(iOS_10_0) ? @"🤳" : @"⏳";
        default:
            return nil;
    }
}

%hook CAMModeDialItem

%property(retain, nonatomic) UILabel *label;

- (void)_commonCAMModeDialItemInitialization {
    %orig;
    if (self.label == nil) {
        self.label = [[UILabel alloc] initWithFrame:CGRectZero];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.autoresizingMask = 0x12;
        [self addSubview:self.label];
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    if (IS_IPAD)
        return %orig;
    return CGSizeMake(self.superview.frame.size.height, self.superview.frame.size.height);
}

- (void)setTitle:(NSString *)title {
    %orig;
    self.label.text = title;
}

- (void)setFont:(UIFont *)font {
    %orig;
    self.label.font = font;
}

- (void)dealloc {
    self.label = nil;
    %orig;
}

%end

%hook CAMModeDial

- (void)_setItems:(NSDictionary <NSNumber *, CAMModeDialItem *> *)items {
    %orig;
    for (NSNumber *mode in items) {
        CAMModeDialItem *item = items[mode];
        NSString *emoji = emojiForMode([mode intValue]);
        if (emoji)
            item.title = emoji;
    }
}

%end

%ctor {
    openCamera10();
    %init;
}
