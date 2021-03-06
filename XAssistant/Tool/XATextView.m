//
//  XATextField.m
//  XAssistant
//
//  Created by 王家强 on 17/4/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "XATextView.h"

@interface XATextField: NSTextField

@end

@implementation XATextField

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        self.font = [NSFont systemFontOfSize:16];
        [self setFocusRingType:NSFocusRingTypeNone];
        [self setDrawsBackground:YES];
        [self setBackgroundColor:[NSColor clearColor]];
        self.textColor = [NSColor whiteColor];
        self.maximumNumberOfLines = 0;
        
        self.bordered = NO;
        self.wantsLayer = YES;
        
        // 重要：一定要设置如下属性，否则无法显示效果
        [[self cell] setBezeled:NO];
        [[self cell] setBordered:NO];
    }
    return self;
}

- (BOOL)becomeFirstResponder
{
    [super becomeFirstResponder];
    if (self.subviews.count) {
        __block NSView *keyboardFocusClipView;
        [self.subviews enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSClipView class]]) {
                keyboardFocusClipView = obj;
                *stop = YES;
            }
        }];
        if (keyboardFocusClipView) {
            NSView *view = keyboardFocusClipView.subviews[0];
            [(NSTextView*)view setInsertionPointColor:[NSColor whiteColor]];
        }
    }
    return [super becomeFirstResponder];
}

- (BOOL)performKeyEquivalent:(NSEvent *)event
{
    if (([event modifierFlags] & NSDeviceIndependentModifierFlagsMask) == NSCommandKeyMask) {
        // The command key is the ONLY modifier key being pressed.
        if ([[event charactersIgnoringModifiers] isEqualToString:@"x"]) {
            return [NSApp sendAction:@selector(cut:) to:[[self window] firstResponder] from:self];
        } else if ([[event charactersIgnoringModifiers] isEqualToString:@"c"]) {
            return [NSApp sendAction:@selector(copy:) to:[[self window] firstResponder] from:self];
        } else if ([[event charactersIgnoringModifiers] isEqualToString:@"v"]) {
            return [NSApp sendAction:@selector(paste:) to:[[self window] firstResponder] from:self];
        } else if ([[event charactersIgnoringModifiers] isEqualToString:@"a"]) {
            return [NSApp sendAction:@selector(selectAll:) to:[[self window] firstResponder] from:self];
        }
    }
    return [super performKeyEquivalent:event];
}

@end

@interface XASecureTextField: NSSecureTextField

@end

@implementation XASecureTextField

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        self.font = [NSFont systemFontOfSize:16];
        [self setFocusRingType:NSFocusRingTypeNone];
        [self setDrawsBackground:YES];
        [self setBackgroundColor:[NSColor clearColor]];
        self.textColor = [NSColor whiteColor];
        self.maximumNumberOfLines = 0;
        
        self.bordered = NO;
        self.wantsLayer = YES;
        
        // 重要：一定要设置如下属性，否则无法显示效果
        [[self cell] setBezeled:NO];
        [[self cell] setBordered:NO];
    }
    return self;
}

- (BOOL)becomeFirstResponder
{
    [super becomeFirstResponder];
    if (self.subviews.count) {
        __block NSView *keyboardFocusClipView;
        [self.subviews enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSClipView class]]) {
                keyboardFocusClipView = obj;
                *stop = YES;
            }
        }];
        if (keyboardFocusClipView) {
            NSView *view = keyboardFocusClipView.subviews[0];
            [(NSTextView*)view setInsertionPointColor:[NSColor whiteColor]];
        }
    }
    return [super becomeFirstResponder];
}

- (BOOL)performKeyEquivalent:(NSEvent *)event
{
    if (([event modifierFlags] & NSDeviceIndependentModifierFlagsMask) == NSCommandKeyMask) {
        // The command key is the ONLY modifier key being pressed.
        if ([[event charactersIgnoringModifiers] isEqualToString:@"x"]) {
            return [NSApp sendAction:@selector(cut:) to:[[self window] firstResponder] from:self];
        } else if ([[event charactersIgnoringModifiers] isEqualToString:@"c"]) {
            return [NSApp sendAction:@selector(copy:) to:[[self window] firstResponder] from:self];
        } else if ([[event charactersIgnoringModifiers] isEqualToString:@"v"]) {
            return [NSApp sendAction:@selector(paste:) to:[[self window] firstResponder] from:self];
        } else if ([[event charactersIgnoringModifiers] isEqualToString:@"a"]) {
            return [NSApp sendAction:@selector(selectAll:) to:[[self window] firstResponder] from:self];
        }
    }
    return [super performKeyEquivalent:event];
}

@end


/** ----------------------XATextView---------------------- */
@interface XATextView ()

@property(nonatomic,strong) XATextField *textField;

@property(nonatomic,strong) XASecureTextField *secureTextField;

@property(nonatomic,strong) NSTextField *lineView;

@property(nonatomic,strong) NSImageView *leftImageV;

@end


@implementation XATextView

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI
{
    self.secureTextEntry = NO;
    CGFloat w = self.frame.size.height-1;
    
    
    self.leftImageV = [[NSImageView alloc] initWithFrame:NSRectFromCGRect(CGRectMake(0, (w-25)/2, 25, 25))];
    [self addSubview:self.leftImageV];
    
    self.lineView = [[NSTextField alloc] initWithFrame:NSRectFromCGRect(CGRectMake(0, 0, self.frame.size.width, 1))];
    [self addSubview:self.lineView];
    self.lineView.editable = NO;
    self.lineView.layer.borderColor = [NSColor whiteColor].CGColor;
    
    self.secureTextField = [[XASecureTextField alloc] initWithFrame:NSRectToCGRect(CGRectMake(self.frame.size.height-1, 1, self.frame.size.width-self.frame.size.height, 24))];
    [self addSubview:self.secureTextField];
    self.secureTextField.hidden = YES;
    
    self.textField = [[XATextField alloc] initWithFrame:NSRectToCGRect(CGRectMake(self.frame.size.height-1, 1, self.frame.size.width-self.frame.size.height, 24))];
    [self addSubview:self.textField];
}

- (void)setPlaceholderString:(NSString *)placeholderString
{
    if (placeholderString) {
        self.textField.placeholderString = placeholderString;
        self.secureTextField.placeholderString = placeholderString;
    }
    _placeholderString = placeholderString;
}

- (void)setLeftImage:(NSImage *)leftImage
{
    if (leftImage) {
        self.leftImageV.image = leftImage;
        self.leftImageV.imageScaling = NSImageScaleAxesIndependently;
    }
    _leftImage = leftImage;
}

- (NSString *)text
{
    if (self.secureTextEntry) {
        return self.secureTextField.stringValue;
    } else {
        return self.textField.stringValue;
    }
}

- (void)setText:(NSString *)text
{
    if (self.secureTextEntry) {
        self.secureTextField.stringValue = text;
    } else {
        self.textField.stringValue = text;
    }
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry
{
    _secureTextEntry = secureTextEntry;
    if (secureTextEntry) {
        self.secureTextField.hidden = NO;
        self.textField.hidden = YES;
    }
}


@end










