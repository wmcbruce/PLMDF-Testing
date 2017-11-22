//
//  SPRSerialQueue.h
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


@import Foundation;


/**
 \brief
 Runs the block on the main queue with the arguments provided.
 
 \discussion
 If the block is \c NULL or \c nil , no dispatch to the main queue is
 performed.
 
 \code{.m}
 // prints "Hello, Amelia" from the main queue
 void(^hello)(NSString*) = ^(NSString *name) { NSLog(@"Hello, %@", name); };
 SPRDispatchOnMainQueue(hello, @"Amelia");
 
 // does nothing
 void(^aBlock)(NSData *content, NSError *error) = nil;
 DispatchOnMainQueue(aBlock, fileContent, fileManagerError);
 \endcode
 
 \param block
 Variable name of a block or a block literal to be executed on the main queue.
 May be \c nil . Values to send as arguments to the block follow this
 parameter as a variable arguments list (not terminated with \c nil !).
 */
#define SPRDispatchOnMainQueue(block, ...) if (block) { dispatch_async(dispatch_get_main_queue(), ^{ block(__VA_ARGS__); }); }

/**
 \brief
 SPRSerialQueue is a reentrant serial queue.
 
 \discussion
 When \c -performBlock: is invoked while already on the private queue (which is
 to say, from within the block passed to \c -performBlock ), the SPRSerialQueue
 does not deadlock. Instead, the second call proceeds inline.
 */
@interface SPRSerialQueue : NSObject

@property (assign, atomic, getter=isProfilingEnabled) BOOL profilingEnabled;

/**
 \brief
 Create a serial queue object with a given label and GCD priority.
 
 \discussion
 This method is the designated initializer for the class.
 
 \param label
 A string label to attach to the queue to uniquely identify it in debugging
 tools such as Instruments, \c sample , stackshots, and crash reports. Because
 applications, libraries, and frameworks can all create their own dispatch
 queues, a reverse-DNS naming style \em (com.example.myqueue) is recommended.
 This parameter is optional and can be \c nil .
 
 \param qosClass
 The quality of service you want to give to tasks executed using this queue.
 Quality-of-service helps determine the priority given to tasks executed by the
 queue. Specify one of the values \c QOS_CLASS_USER_INTERACTIVE ,
 \c QOS_CLASS_USER_INITIATED , \c QOS_CLASS_UTILITY , or \c
 QOS_CLASS_BACKGROUND . Queues that handle user-interactive or user-initiated
 tasks have a higher priority than tasks meant to run in the background.
 
 \return
 A new serial queue object.
 */
- (instancetype)initWithLabel:(NSString *)label
             qualityOfService:(dispatch_qos_class_t)qosClass
NS_DESIGNATED_INITIALIZER;

/**
 \brief
 Create a serial queue object with a given label.
 
 \discussion
 Creates a private queue with the default ( \c DISPATCH_QUEUE_PRIORITY_DEFAULT )
 quality of service.
 
 \param label
 A string label to attach to the queue to uniquely identify it in debugging
 tools such as Instruments, \c sample , stackshots, and crash reports. Because
 applications, libraries, and frameworks can all create their own dispatch
 queues, a reverse-DNS naming style \em (com.example.myqueue) is recommended.
 This parameter is optional and can be \c nil .
 
 \return
 A new serial queue object.
 */
- (instancetype)initWithLabel:(NSString *)label;

/**
 \brief
 Asynchronously runs the given block on a private queue.
 
 \discussion
 If called while on the private queue, the block is invoked directly (inline,
 synchronously).
 
 \param
 block to be invoked on the serial queue.
 */
- (void)performBlock:(void(^)(void))block;

/**
 \brief
 Synchronously runs the given block on a private queue.
 
 \discussion
 If called while on the private queue, the block is invoked directly.
 
 \param
 block to be invoked on the serial queue.
 */
- (void)performBlockAndWait:(void(^)(void))block;

@end
