//
//  ViewController.m
//  fastcast-opus
//
//  Created by Uncovered on 12/16/15.
//  Copyright © 2015 Allfree Group LLC. All rights reserved.
//

#import "ViewController.h"

#import "Novocaine.h"
#import "RingBuffer.h"

#define     SERVER_IP @"127.0.0.1"
#define     SERVER_PORT 33333

#define     TIMEOUT -1
#define     AUDIO_TAG 1


@interface ViewController()<GCDAsyncUdpSocketDelegate>
{
    GCDAsyncUdpSocket *udpSocket;
    dispatch_queue_t udpQueue;
}
    @property (nonatomic, assign) RingBuffer *ringBuffer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    udpQueue = dispatch_get_main_queue();
    udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:udpQueue];
    [udpSocket connectToHost:SERVER_IP onPort:SERVER_PORT error:nil];
    [udpSocket setReceiveFilter:^BOOL(NSData *data, NSData *address, __autoreleasing id *context) {
        return true;
    } withQueue:udpQueue];
    [udpSocket beginReceiving:nil];
    
//    [udpSocket receiveWithTimeout:TIMEOUT tag:AUDIO_TAG];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.ringBuffer = new RingBuffer(32768, 2);
    [self performSelectorInBackground:@selector(startRecording) withObject:nil];
}

- (void) startRecording {
    
    __weak typeof(self)wself = self;
    Novocaine *audioManager = [Novocaine audioManager];
    //
    //    // Make some NOISE
    ////    [audioManager setOutputBlock:^(float *newdata, UInt32 numFrames, UInt32 thisNumChannels)
    ////    {
    ////        for (int i = 0; i < numFrames * thisNumChannels; i++) {
    ////            newdata[i] = (rand() % 100) / 100.0f / 2;
    ////        }
    ////    }];
    //
    //
    //    // Play-through
    //
    [audioManager setInputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels) {
        NSData *d = [NSData dataWithBytes:data length:sizeof(float)*numFrames*numChannels];
        [udpSocket sendData:d withTimeout:TIMEOUT tag:AUDIO_TAG];
    }];

    
    [audioManager setOutputBlock:^(float *outData, UInt32 numFrames, UInt32 numChannels) {
        wself.ringBuffer->FetchInterleavedData(outData, numFrames, numChannels);
    }];
    
    //
    ////    [audioManager setInputBlock:^(float *newAudio, UInt32 numSamples, UInt32 numChannels) {
    ////        NSLog([NSString stringWithFormat:@"%d", (unsigned int)numSamples]);
    ////        // Now you're getting audio from the microphone every 20 milliseconds or so. How's that for easy?
    ////        // Audio comes in interleaved, so,
    ////        // if numChannels = 2, newAudio[0] is channel 1, newAudio[1] is channel 2, newAudio[2] is channel 1, etc.
    ////    }];
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
    self.ringBuffer->AddNewInterleavedFloatData((float *)[data bytes], [data length]/sizeof(float)/numChannels, numChannels);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    
}


//- (void)onUdpSocket:(GCDAsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
//{
//    
//}
//
//- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
//{
//    
//}
//
//- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
//{
//    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//    return true;
//}
//
//- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag
//{
////    NSLog(@"send data");
//}
//
//- (void)onUdpSocketDidClose:(AsyncUdpSocket *)sock
//{
//    
//}

@end
