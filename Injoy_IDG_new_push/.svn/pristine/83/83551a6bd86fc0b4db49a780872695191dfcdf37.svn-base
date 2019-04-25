//
//  CXIMVoiceOperation.m
//  SDMarketingManagement
//
//  Created by Rao on 16/4/26.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "CXIMVoiceOperation.h"
#import "PlayerManager.h"

@interface CXIMVoiceOperation () <PlayingDelegate> {
    dispatch_queue_t messageQueue;
    BOOL executing;
    BOOL finished;
    BOOL canceled;
}
@property (strong, nonatomic) CXIMMessage* message;
@property (assign, nonatomic) BOOL operationStarted;
- (void)playVoiceAction;
- (void)finish;
@end

@implementation CXIMVoiceOperation

- (instancetype)initWithMessageModel:(CXIMMessage*)model
{
    if (self = [super init]) {
        executing = NO;
        finished = NO;
        messageQueue = dispatch_queue_create("com.cx.im", NULL);
        self.message = model;
    }
    return self;
}

- (void)start
{
    self.operationStarted = YES;

    if ([self isCancelled]) {
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)main
{
    @autoreleasepool {
        if ([self isCancelled]) {
            return;
        }
        [self playVoiceAction];
    }
}

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isExecuting
{
    return executing;
}

- (BOOL)isFinished
{
    return finished;
}

- (void)playVoiceAction
{
    NSString* localUrl = [(CXIMVoiceMessageBody*)self.message.body localUrl];
    NSString* tempUrl = [NSHomeDirectory() stringByAppendingPathComponent:localUrl];
    NSLog(@"localUrl:%@", tempUrl);
    [[PlayerManager sharedManager] playAudioWithFileName:tempUrl playerType:DDSpeaker delegate:(id<PlayingDelegate>)self];
    if ([self.voiceOperationDelegate respondsToSelector:@selector(playMessage:)]) {
        [self.voiceOperationDelegate playMessage:self.message];
    }
}

#pragma mark - PlayingDelegate

/// 播放完成
- (void)playingStoped
{
    NSLog(@"播放完成");

    if ([self.voiceOperationDelegate respondsToSelector:@selector(playStoped)]) {
        [self.voiceOperationDelegate playStoped];
    }

    [self finish];
}

#pragma mark -

- (void)finish
{
    if (self.operationStarted == NO) {
        return;
    }

    [self willChangeValueForKey:@"isFinished"];
    finished = YES;
    [self didChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    executing = NO;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)cancel
{
    [super cancel];
    [self finish];
}

@end
