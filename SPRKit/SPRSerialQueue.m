//
//  SPRSerialQueue.m
//  SQLiteFTS
//
//  Created by David L Kinney on 9/28/15.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 SPRI LLC (www.spr.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//


#import "SPRSerialQueue.h"


static NSInteger const SPRSerialQueueSpecificKey = 0;


@interface SPRSerialQueue ()
@property (strong, nonatomic) dispatch_queue_t privateQueue;
@end


@implementation SPRSerialQueue

#pragma mark - NSObject

- (instancetype)init {
    return [self initWithLabel:nil];
}

#pragma mark - SPRSerialQueue

- (instancetype)initWithLabel:(NSString *)label {
    return [self initWithLabel:label qualityOfService:DISPATCH_QUEUE_PRIORITY_DEFAULT];
}

- (instancetype)initWithLabel:(NSString *)label qualityOfService:(dispatch_qos_class_t)qosClass {
    self = [super init];
    if (self) {
        char const * const cLabel = [label cStringUsingEncoding:NSUTF8StringEncoding];
        dispatch_queue_attr_t queueAttribs = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, qosClass, -10);
        dispatch_queue_t queue = dispatch_queue_create(cLabel, queueAttribs);
        
        dispatch_queue_set_specific(queue, &SPRSerialQueueSpecificKey, (__bridge void *)self, NULL);
        
        _privateQueue = queue;
    }
    return self;
}

- (void)performBlock:(void (^)(void))block {
    if (nil == block) return;
    
    void(^blockToRun)(void) = ([self isProfilingEnabled]) ? [self profiledBlockWithBlock:block] : block;
    
    void *currentSpecific = dispatch_get_specific(&SPRSerialQueueSpecificKey);
    BOOL onPrivateQueue = (currentSpecific == (__bridge void *)self);
    if (onPrivateQueue) {
        blockToRun();
    } else {
        dispatch_async(self.privateQueue, blockToRun);
    }
}

- (void)performBlockAndWait:(void (^)(void))block {
    if (nil == block) return;
    
    void(^blockToRun)(void) = ([self isProfilingEnabled]) ? [self profiledBlockWithBlock:block] : block;
    
    void *currentSpecific = dispatch_get_specific(&SPRSerialQueueSpecificKey);
    BOOL onPrivateQueue = (currentSpecific == (__bridge void *)self);
    if (onPrivateQueue) {
        blockToRun();
    } else {
        dispatch_sync(self.privateQueue, blockToRun);
    }
}

#pragma mark - Private

- (void(^)(void))profiledBlockWithBlock:(void(^)(void))block {
    void(^profiledBlock)(void) = ^{
        NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
        if (block) block();
        NSTimeInterval stop = [NSDate timeIntervalSinceReferenceDate];
        NSTimeInterval elapsed = stop - start;
        NSLog(@"Block took %0.3f seconds", elapsed);
    };
    return profiledBlock;
}

@end
