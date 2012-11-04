//
//  ViewController.m
//  SimpleFileBrowser
//
//  Created by Yang Fei on 12-11-5.
//  Copyright (c) 2012年 能力有限公司. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray     *contents;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    NSString *currentPath = [[NSFileManager defaultManager] currentDirectoryPath];
    _contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:currentPath error:nil];
    self.title = currentPath;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    ViewController *vc = [self.navigationController.viewControllers lastObject];
    // 当pop回来时,vc为空,切回self.previousPath; 当push时,不切到previouspath
    if (self.previousPath && !vc) {
        [[NSFileManager defaultManager] changeCurrentDirectoryPath:self.previousPath];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_contents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ContentsCellIdentifier = @"ContentsCell";
    UITableViewCell *contentsCell = [tableView dequeueReusableCellWithIdentifier:ContentsCellIdentifier];
    if (contentsCell == nil){
        contentsCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ContentsCellIdentifier];
    }
    
    contentsCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    contentsCell.textLabel.text = [_contents objectAtIndex:indexPath.row];
    contentsCell.imageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",self.title,[_contents objectAtIndex:indexPath.row]]];
    return contentsCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *selectedPath = [_contents objectAtIndex:indexPath.row];
    NSString *prePath = [[NSFileManager defaultManager] currentDirectoryPath];
    
    BOOL flag = [[NSFileManager defaultManager] changeCurrentDirectoryPath:selectedPath];
    
    // It is a directory
    if (flag){
        ViewController *vc = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
        vc.previousPath = prePath;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    // It is a file
    else{
        
    }
    
}

@end
