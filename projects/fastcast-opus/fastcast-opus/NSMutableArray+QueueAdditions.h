//
//  NSMutableArray+QueueAdditions.h
//  fastcast-opus
//
//  Created by Uncovered on 12/18/15.
//  Copyright © 2015 Allfree Group LLC. All rights reserved.
//

#ifndef NSMutableArray_QueueAdditions_h
#define NSMutableArray_QueueAdditions_h

@interface NSMutableArray (QueueAdditions)
- (id) dequeue;
- (void) enqueue:(id)obj;
@end

#endif /* NSMutableArray_QueueAdditions_h */
