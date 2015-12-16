//
//  ViewController.m
//  FastOpus
//
//  Created by Altair on 12/16/15.
//  Copyright © 2015 altair. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.sampleRate = 48000;
    
    [self setupAudioSession];
    [self setupCaptureSession];
    [self setupAudioCapture];
    [self setupEncoder];
    [self start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupAudioSession
{
    NSError *error;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setPreferredSampleRate:48000 error:&error];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    [audioSession setPreferredIOBufferDuration:0.02 error:&error];
    [audioSession setActive:YES error:&error];
    self.sampleRate = audioSession.sampleRate;
}

- (void)setupCaptureSession
{
    self.captureSession = [AVCaptureSession new];
}

- (void)setupAudioCapture
{
    NSError *error;
    
    self.microphone = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    
    if(!self.microphone)
    {
        // TODO: Add error condition
    }
    
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:self.microphone error:&error];
    
    if(!audioInput)
    {
        // TODO: Add error condition
    }
    
    [self.captureSession addInput:audioInput];
    
    self.audio = [AVCaptureAudioDataOutput new];
    
    dispatch_queue_t audioQueue = dispatch_queue_create("AudioQueue", NULL);
    
    [self.audio setSampleBufferDelegate:self queue:audioQueue];
    
    [self.captureSession addOutput:self.audio];
}

- (void)setupEncoder
{
    
    self.encoder = [CSIOpusEncoder encoderWithSampleRate:self.sampleRate channels:1 frameDuration:0.01];
}

- (void)start
{
    [self.captureSession startRunning];
}


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CMFormatDescriptionRef formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer);
    CMMediaType mediaType = CMFormatDescriptionGetMediaType(formatDescription);
    
    if(mediaType == kCMMediaType_Audio)
    {
        NSArray *encodedSamples = [self.encoder encodeSample:sampleBuffer];
        for (NSData *encodedSample in encodedSamples) {
            NSLog(@"Encoded %lu bytes", (unsigned long)encodedSample.length);
        }
    }
    
}



@end
