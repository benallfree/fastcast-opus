//
//  BufferEntry.m
//  fastcast-opus
//
//  Created by Uncovered on 12/18/15.
//  Copyright © 2015 Allfree Group LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BufferEntry.h"

@implementation BufferEntry

-(void) init:(float *)withBuffer ofNumFrames:(UInt32) _nframes andNumChannels:(UInt32)_nchannels
{
    self.buffer = (float *)withBuffer;
    self.numChannels = _nchannels;
    self.numFrames = _nframes;
    self.length = sizeof(float)*_nchannels*_nframes;
}
@end
