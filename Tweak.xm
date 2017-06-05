#import "../PS.h"

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
            return @"🎈";
        case 3:
            return @"🎞";
        case 4:
            return @"🔲";
        case 5:
            return isiOS10Up ? @"⏳" : @"⚙️";
        case 6:
            return isiOS10Up ? @"🤳" : @"⏳";
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
    [self.label release];
    self.label = nil;
    %orig;
}

%end

%group iOS9Up

%hook CAMModeDial

- (NSString *)_titleForMode: (NSInteger)mode {
    NSString *emoji = emojiForMode(mode);
    return emoji ? emoji : %orig;
}

%end

%end

%group iOS8

%hook CAMCameraView

- (NSString *)modeDial: (id)arg1 titleForItemAtIndex: (NSUInteger)index {
    NSString *emoji = emojiForMode([MSHookIvar<CAMCaptureController *>(self, "_cameraController").supportedCameraModes[index] intValue]);
    return emoji ? emoji : %orig;
}

%end

%end

%group iOS7

%hook PLCameraView

- (NSString *)modeDial: (id)arg1 titleForItemAtIndex: (NSUInteger)index {
    NSString *emoji = emojiForMode([MSHookIvar<PLCameraController *>(self, "_cameraController").supportedCameraModes[index] intValue]);
    return emoji ? emoji : %orig;
}

%end

%end

%ctor {
    %init;
    if (isiOS9Up) {
        openCamera9();
        %init(iOS9Up);
    } else if (isiOS8) {
        openCamera8();
        %init(iOS8);
    } else {
        openCamera7();
        %init(iOS7);
    }
}
