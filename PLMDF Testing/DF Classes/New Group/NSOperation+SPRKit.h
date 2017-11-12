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

@import Foundation;


/**
 \brief
 The NSOperation+SPRKit category adds methods to NSOperation that simplify
 access to the \c error and \c result properties of the receiver's \c
 dependencies .
 
 \discussion
 This category exists to encourage use of fine-grain operations that cascade
 their outputs to their downstream dependencies. This has several benefits
 including improving testability, ease of maintenance, and encouraging
 definition of proper dependencies between operations which allows an
 NSOperationQueue to maximize concurrency.
 
 In the past, this has been onerous to create fine-grain operations due to the
 lack of a standard mechanism to hand-off the output of each step to the next.
 This category defines \c -error and \c -result as the mechanism for handing
 off outputs and provides methods to make it easier to access those outputs.
 
 For example, instead of creating a monolithic NSOperation subclass that
 downloads, parses, and saves data, it may be preferrable to create three
 NSOperation subclasses: one that downloads the data, another that picks up
 that data and parses it, and a final operation that takes the parsed data and
 saves it.
 */
@interface NSOperation (SPRKit)

/**
 \brief
 Creates an NSDictionary containing entries for each NSOperation in the
 receiver's \c -dependencies array that has a \c name set and responds to \c
 -error with an NSError object. Each entry maps from the NSOperation's \c name
 to its \c -error value.
 
 \discussion
 If you need to know whether \em any dependency has its \c error set,
 regardless of whether its \c name is set, use \c -spr_hasDependencyWithError .
 
 \return
 NSDictionary with NSString keys and \c NSError values.
 
 \see spr_hasDependencyWithError
 \since 1.0
 */
- (NSDictionary *)spr_dependencyErrorsByName;

/**
 \brief
 Creates an NSDictionary containing entries for each NSOperation in the
 receiver's \c -dependencies array that has a \c name set and responds to \c
 -result with an NSObject. Each entry maps from the NSOperation's \c name
 to its \c -result value.
 
 \return
 NSDictionary with NSString keys and \c id values.
 
 \since 1.0
 */
- (NSDictionary *)spr_dependencyResultsByName;

/**
 \brief
 Convenience method for \c spr_dependencyResultsByName[name] .
 
 \return
 Value for the specified name in the dependency results dictionary returned by
 \c -spr_dependencyResultsByName .
 */
- (id)spr_dependencyResultWithName:(NSString *)name;

/**
 \brief
 Determines if any direct dependency has its \c error property set.
 
 \return
 \c YES when one or more direct dependencies responds to \c -error and returns
 a value; \c NO otherwise.
 
 \since 1.0
 */
- (BOOL)spr_hasDependencyWithError;

@end
