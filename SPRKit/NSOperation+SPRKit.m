//
// NSOperation+SPRKit.h
// SPRKit
//
// The MIT License
//
// Copyright (c) 2014–2015 SPRI, LLC <info@spr.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
//

#import "NSOperation+SPRKit.h"


@implementation NSOperation (SPRKit)

- (NSDictionary *)spr_dependencyErrorsByName {
    static Class NSErrorClass = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSErrorClass = [NSError class];
    });
    
    NSMutableDictionary *errorsByName = [[NSMutableDictionary alloc] init];
    
    NSArray *dependencies = [self dependencies];
    for (NSOperation *operation in dependencies) {
        NSString *name = operation.name;
        if (name != nil && [operation respondsToSelector:@selector(error)]) {
            id error = [operation performSelector:@selector(error)];
            BOOL isNSError = [error isKindOfClass:NSErrorClass];
            if (isNSError) {
                errorsByName[name] = error;
            }
        }
    }
    
    return [errorsByName copy];
}

- (NSDictionary *)spr_dependencyResultsByName {
    NSMutableDictionary *resultsByName = [[NSMutableDictionary alloc] init];
    
    NSArray *dependencies = [self dependencies];
    for (NSOperation *operation in dependencies) {
        NSString *name = operation.name;
        if (name != nil && [operation respondsToSelector:@selector(result)]) {
            id result = [operation performSelector:@selector(result)];
            BOOL isNSObject = [result conformsToProtocol:@protocol(NSObject)];
            if (isNSObject) {
                resultsByName[name] = result;
            }
        }
    }
    
    return [resultsByName copy];
}

- (id)spr_dependencyResultWithName:(NSString *)name {
    NSDictionary *results = [self spr_dependencyResultsByName];
    id result = results[name];
    return result;
}

- (BOOL)spr_hasDependencyWithError {
    BOOL hasError = NO;
    
    NSArray *dependencies = [self dependencies];
    for (NSOperation *operation in dependencies) {
        if ([operation respondsToSelector:@selector(error)]) {
            id error = [operation performSelector:@selector(error)];
            hasError = (error != nil);
        }
        
        if (hasError) break;
    }
    
    return hasError;
}

@end

