//
//  BufferEntry.h
//  fastcast-opus
//
//  Created by Uncovered on 12/18/15.
//  Copyright © 2015 Allfree Group LLC. All rights reserved.
//

#ifndef BufferEntry_h
#define BufferEntry_h

@interface BufferEntry : NSObject
-(void) init:(float *)withBuffer ofNumFrames:(UInt32) _nframes andNumChannels:(UInt32)_nchannels;
@property float* buffer;
@property UInt32 numFrames;
@property UInt32 numChannels;
@property UInt32 length;
@end


#endif /* BufferEntry_h */
