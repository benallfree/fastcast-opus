//
//  ViewController.m
//  fastcast-opus
//
//  Created by Uncovered on 12/16/15.
//  Copyright © 2015 Allfree Group LLC. All rights reserved.
//

#import "ViewController.h"

#import "Novocaine.h"
#import "NSMutableArray+QueueAdditions.h"
#import "BufferEntry.h"

#define     SERVER_IP @"127.0.0.1"
#define     SERVER_PORT 33333

#define     TIMEOUT -1
#define     AUDIO_TAG 1




@interface ViewController()<GCDAsyncUdpSocketDelegate>
{
    GCDAsyncUdpSocket *udpSocket;
    NSMutableArray *buffers;
    dispatch_queue_t udpQueue;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    buffers = [[NSMutableArray alloc] init];
    udpQueue = dispatch_get_main_queue();
    udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:udpQueue];
    [udpSocket connectToHost:SERVER_IP onPort:SERVER_PORT error:nil];
    [udpSocket setReceiveFilter:^BOOL(NSData *data, NSData *address, __autoreleasing id *context) {
        return true;
    } withQueue:udpQueue];
    [udpSocket beginReceiving:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self performSelectorInBackground:@selector(startRecording) withObject:nil];
}

- (void) startRecording {
    
    __weak typeof(self)wself = self;
    NSError *audioSessionError = nil;
    [[AVAudioSession sharedInstance] setPreferredSampleRate:48000.0 error:&audioSessionError];
    Novocaine *audioManager = [Novocaine audioManager];
    
    // Capture mic input
    [audioManager setInputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels) {
        NSData *d = [NSData dataWithBytes:data length:sizeof(float)*numFrames*numChannels];
        [udpSocket sendData:d withTimeout:TIMEOUT tag:AUDIO_TAG];
    }];
    
    double sampleRate = [AVAudioSession sharedInstance].sampleRate;
    
    // Play audio from echo server
    [audioManager setOutputBlock:^(float *outData, UInt32 numFrames, UInt32 numChannels) {
        if([buffers count]==0)
        {
            outData = NULL;
            numFrames = 0;
            numChannels = 0;
            return;
        }
        BufferEntry *be = [buffers dequeue];
        memcpy(outData, be.buffer, be.length);
    }];
    
    [audioManager play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AsyncUdpSocket

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address {
    
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error
{
    
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    int numChannels = 2;
    BufferEntry *be = [BufferEntry alloc];
    [be init:(float *)[data bytes] ofNumFrames:(UInt32)[data length]/sizeof(float)/numChannels andNumChannels:numChannels];
    [buffers enqueue:be];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    
}
@end
