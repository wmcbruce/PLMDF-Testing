//
// SPRAsyncOperation.h
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

@import Foundation;


/**
 \abstract
 Block to be executed upon completion of the asynchronous operation.
 
 \discussion
 This block must only be called once.
 
 \param result
 Result of the operation, if any. The value will be used to set the operation's
 \c result property. This value MAY BE \c nil if there is no result to expose.
 This value MUST BE \c nil if \c error is set.
 
 \param error
 If the asynchronous operation encountered an error condition, that error can
 be passed to the completion block. The error will be used to set the
 operation's \c error property. This value must be \c nil if \c result is set.
 
 \see SPRAsyncOperation error
 \see SPRAsyncOperation result
 */
typedef void (^SPRAsyncOperationCompletion)(id result, NSError *error);


/**
 \abstract
 The SPRAsyncOperation class is an NSOperation subclass that makes it easy to
 add asynchronous operations to an NSOperationQueue. Additionally,
 SPRAsyncOperation exposes an \c error property and a \c result property for
 downstream dependencies to use in their processing.
 
 \discussion
 NSOperation and its subclasses provided in the Foundation framework mark the
 operation as finished when the \c -main method exits. This has made it
 difficult to incorporate operations leveraging asynchronous frameworks, such
 as NSURLSession or AFNetworking, into NSOperationQueues.
 
 The SPRAsyncOperation class provides a simple override point for subclasses to
 initiate asynchronous operations and properly manages the NSOperation state
 throughout the operation's lifecycle, allowing you to focus on implementing
 the operation's business logic.
 
 Subclasses MUST NOT override \c -main . Instead, subclasses MUST override \c
 -asyncMain: .
 
 \since 1.0
 */
@interface SPRAsyncOperation : NSOperation

/**
 \abstract
 After the operation is finished, this property will contain the error passed
 to the completion block, if any.
 
 \discussion
 It can be useful for an operation to know if any of its dependencies were
 unable to complete their tasks successfully. The NSError provided to the
 completion callback is exposed as a property so that downstream operations can
 perform this check.
 
 Operation chains using this feature should have their \c name property set so
 that downstream operations that have multiple dependencies can determine which
 operations had errors.
 
 \since 1.0
 */
@property (copy, readonly) NSError *error;

/**
 \abstract
 After the operation is finished, this property will contain the result passed
 to the completion block, if any.
 
 \discussion
 This provides a mechanism for communicating to downstream dependencies. For
 example, one operation performs a network request and sets its \c result to
 the NSData object it received. The next operation reads that \c result ,
 parses it, and puts the parsed output in its own \c result property. A third
 operation reads that \c result and updates the data store.
 
 Operation chains using this feature should have their \c name property set so
 that downstream operations that have multiple dependencies can determine which
 preceding operations produced which results.
 
 \since 1.0
 */
@property (strong, readonly) id result;

/**
 \abstract
 You must override this method and use it to initiate your operation.
 
 \discussion
 Your custom implementation must not call \c super at any time.
 
 \param completion
 Your operation must call this block exactly once. This block will set the \c
 error and \c result properties of this object, then mark the operation as
 finished. When the block returns the operation has finished.
 
 \since 1.0
 */
- (void)asyncMain:(SPRAsyncOperationCompletion)completion;

@end
