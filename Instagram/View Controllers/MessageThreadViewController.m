//
//  MessageThreadViewController.m
//  Instagram
//
//  Created by Xurxo Riesco on 7/9/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "MessageThreadViewController.h"
#import "MessageCell.h"

@interface MessageThreadViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *messageField;
@property (strong, nonatomic) NSMutableArray *messages;
@property NSInteger skip;

@end

@implementation MessageThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.messages = [[NSMutableArray alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.messageField.delegate = self;
    [self fetchMessages];
    self.navigationItem.title = self.user.username;
    //[self fetchOwnMessages];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(onTimer) userInfo:nil repeats:true];
}
- (void)onPrint {
    NSLog(@"%@", self.messages);
}
- (void)onTimer {
    [self fetchMessages];
}
- (void) fetchMessages {
    // construct query
    User *user =[PFUser currentUser];
    NSArray *users = [NSArray arrayWithObjects:user,self.user,nil];
    PFQuery *query = [Message query];
    [query whereKey:@"author" containedIn:users];
    [query includeKey:@"author"];
    //NSLog(@"User chatting to: %@", self.user);
    [query whereKey:@"toUser" containedIn:users];
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray<Message *> *messages, NSError *error) {
        if (messages != nil) {
            //NSLog(@"%@", messages);
            self.messages = messages;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.messageField resignFirstResponder];
    return YES;
}
- (IBAction)onSend:(id)sender {
    Message *message = [Message new];
    message.text = self.messageField.text;
    message.author = [PFUser currentUser];
    message.toUser = self.user;
    [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded)
        {
            [self fetchMessages];
            self.messageField.text = @"";
        }
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Message *message = self.messages[indexPath.row];
    if([message.author.username isEqualToString:[PFUser currentUser].username])
    {
        MessageCell *messageCell = [ tableView dequeueReusableCellWithIdentifier:@"MessageCell" ];
        [messageCell loadOwnMessage:message];
        return messageCell;
    }else{
        MessageCell *messageCell = [ tableView dequeueReusableCellWithIdentifier:@"MessageCell" ];
        [messageCell loadMessage:message];
        return messageCell;
  }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

@end
