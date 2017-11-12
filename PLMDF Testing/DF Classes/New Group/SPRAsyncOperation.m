//
// SPRAsyncOperation.m
// SPRKit
//
// The MIT License (MIT)
//
// Copyright (c) 2014-2015 SPR Consulting <info@spr.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

#import "SPRAsyncOperation.h"
/*
 //#import <libkern/OSAtomic.h>
 
 Replaced OSSPinLock with os_unfair_lock for iOS 10.x compatibility
 
 */
#import <os/lock.h>


@interface SPRAsyncOperation () {
    BOOL _executing;
    BOOL _finished;
    //OSSpinLock _operationStateLock;
    os_unfair_lock _operationStateLock;
}

@property (copy,   atomic) NSError *error;
@property (strong, atomic) id result;

@end


@implementation SPRAsyncOperation

#pragma mark - NSObject

- (instancetype)init {
    self = [super init];
    if (self) {
        // NSOperation states
        _executing = NO;
        _finished  = NO;
        
        // NSAsyncOperation outputs
        _error = nil;
        _result = nil;
        
        // Synchronizing access to the state flags
        _operationStateLock = OS_UNFAIR_LOCK_INIT;
    }
    return self;
}

#pragma mark - NSOperation

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isExecuting {
    BOOL executing = NO;
    
    os_unfair_lock_lock(&_operationStateLock);
    executing = _executing;
    os_unfair_lock_unlock(&_operationStateLock);
    
    return executing;
}

- (BOOL)isFinished {
    BOOL finished = NO;
    
    os_unfair_lock_lock(&_operationStateLock);
    finished = _finished;
    os_unfair_lock_unlock(&_operationStateLock);
    
    return finished;
}

- (void)main {
    if ([self isCancelled]) {
        [self sprao_atomicSetFinished:YES];
    } else {
        [self sprao_atomicSetExecuting:YES];
        
        // Upon completion, call set `result` and `error` properties, then call
        // sprao_completeOperation, which will set isExecuting and isFinished
        // properly.
        SPRAsyncOperation *__weak weakSelf = self;
        SPRAsyncOperationCompletion completion = ^(id result, NSError *error) {
            SPRAsyncOperation *__strong strongSelf = weakSelf;
            strongSelf.error = error;
            strongSelf.result = (error) ? nil : result;
            [strongSelf sprao_completeOperation];
        };
        
        // Kick off the asynchronous operation
        [self asyncMain:completion];
    }
}

#pragma mark - SPRAsyncOperation

- (void)asyncMain:(SPRAsyncOperationCompletion)completion {
    NSAssert(true, @"Subclasses of SPRAsyncOperation should not invoke [super asyncMain:]");
    completion(nil, nil);
}

#pragma mark - Private

- (void)sprao_atomicSetFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    
    os_unfair_lock_lock(&_operationStateLock);
    _finished = finished;
    os_unfair_lock_unlock(&_operationStateLock);
    
    [self didChangeValueForKey:@"isFinished"];
}

- (void)sprao_atomicSetExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    
    os_unfair_lock_lock(&_operationStateLock);
    _executing = executing;
    os_unfair_lock_unlock(&_operationStateLock);
    
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)sprao_completeOperation {
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    os_unfair_lock_lock(&_operationStateLock);
    _executing = NO;
    _finished = YES;
    os_unfair_lock_unlock(&_operationStateLock);
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

@end
