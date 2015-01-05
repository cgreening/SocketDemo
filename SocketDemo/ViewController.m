//
//  ViewController.m
//  SocketDemo
//
//  Created by Chris Greening on 05/01/2015.
//  Copyright (c) 2015 Chris Greening. All rights reserved.
//

#import "ViewController.h"
#import <SocketRocket/SRWebSocket.h>

@interface ViewController ()<SRWebSocketDelegate, UITextFieldDelegate>

@property(nonatomic, strong) IBOutlet UITextField *messageField;
@property(nonatomic, strong) IBOutlet UITextView *messages;
@property(nonatomic, strong) SRWebSocket *webSocket;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.messageField becomeFirstResponder];

    NSURL *wsURL = [NSURL URLWithString:@"wss://demows.herokuapp.com/"];
    self.webSocket = [[SRWebSocket alloc] initWithURL:wsURL];
    self.webSocket.delegate = self;
    [self.webSocket open];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [self.webSocket send:textField.text];
    textField.text = @"";
    return NO;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"Message %@", message);
    self.messages.text = [NSString stringWithFormat:@"%@\n%@", message, self.messages.text];
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"Socket opened");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    [[[UIAlertView alloc] initWithTitle:@"Closed" message:reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
