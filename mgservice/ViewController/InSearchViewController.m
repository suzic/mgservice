//
//  SearchViewController.m
//  sdk2.0zhengquandasha
//
//  Created by peng on 15/11/30.
//  Copyright © 2015年 palmaplus. All rights reserved.
//

#import "InSearchViewController.h"


#define kScreenHeight   [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth    [[UIScreen mainScreen] bounds].size.width
@interface InSearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UISearchBar* searchBar;
@property(nonatomic,strong) UITableView* searchResultTableView;
@property (strong,nonatomic)UIActivityIndicatorView*  activityView;
//fffsearchPoiWithDestinationString
@end

@implementation InSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
 
    [self addNavigationSearchBar];
    
    [self addSearchResultTable];
    
    [self addActivityIndicatorView];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
     [center addObserver:self selector:@selector(keyboardDidHide)  name:UIKeyboardDidHideNotification object:nil];
}

- (void)keyboardDidHide
{
    if ([self.searchBar.text isEqualToString:@""]) {
        return;
    }
     [self.delegate searchPoiWithDestinationString:self.searchBar.text andNeewShowAlert:YES];
}
#pragma mark-添加加载动画的代码
-(void)addActivityIndicatorView{
    
    self.activityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    self.activityView.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
    
    self.activityView.frame=CGRectMake(0, 0, 100, 100);
    
    self.activityView.center=CGPointMake(kScreenWidth/2, kScreenHeight/2-50);
    
    self.activityView.color=[UIColor colorWithRed:38.0/255.0 green:230.0/255.0 blue:239.0/255.0 alpha:1];
    
    self.activityView.hidesWhenStopped=YES;//38 230 239
    
    [self.view addSubview:self.activityView];
    
   
    
}
-(void)addSearchResultTable{
    
    self.searchResultTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight ) style:UITableViewStyleGrouped];
   
    self.searchResultTableView.delegate = self;
    self.searchResultTableView.dataSource = self;
    
    [self.view addSubview:self.searchResultTableView];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissSearchKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
    
}

-(void)dismissSearchKeyboard{
    [self.searchBar resignFirstResponder];
    
    
}
-(void)addNavigationSearchBar{
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 60, 30)];
    _searchBar.backgroundColor = [UIColor whiteColor];
    _searchBar.placeholder = @"输入搜索名称";
    _searchBar.delegate = self;


}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

    NSLog(@"change=%@",change);
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"--------------");
    if ([searchText isEqualToString:@""]) {
        /**
         *  传空字符不会有搜索结果的回调。
         */
       
        [self.searchResultArray removeAllObjects];
        [self reloadTableview];
    }else{
        [self.delegate searchPoiWithDestinationString:searchBar.text andNeewShowAlert:NO];
         [self.activityView startAnimating];
    }
    
}
-(void)stopAnimating{
    [self.activityView stopAnimating];

}
-(void)searchBarResignFirstResponder{
    [self.searchBar resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
       return self.searchResultArray.count;
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.searchBar;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
    }//initWithStyle:UITableViewCellStyleSubtitle
    if (((NGRLocationModel *)self.searchResultArray[indexPath.row]).display == nil) {
        cell.textLabel.text = ((NGRLocationModel *)self.searchResultArray[indexPath.row]).name;
        cell.detailTextLabel.text = ((NGRLocationModel *)self.searchResultArray[indexPath.row]).address;
    }else{
        cell.textLabel.text = ((NGRLocationModel *)self.searchResultArray[indexPath.row]).display;
        cell.detailTextLabel.text = ((NGRLocationModel *)self.searchResultArray[indexPath.row]).address;
    }
    return  cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(void)reloadTableview{
    [self.searchResultTableView reloadData];
}
-(NSMutableArray*)searchResultArray{
    if (_searchResultArray == nil) {
        _searchResultArray = [NSMutableArray arrayWithCapacity: 80];;
    }
    return _searchResultArray;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate searchPoiFeature: (NGRLocationModel *)self.searchResultArray[indexPath.row] andSearchType:self.searchType];
     [self.navigationController popViewControllerAnimated:YES];
}
-(void)dealloc{
    
}

-(void)viewDidAppear:(BOOL)animated{
    if (self.searchResultTableView!=nil) {
        [self.searchResultTableView reloadData];
    }
    
}
-(void)showAlertNoSearchResult{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"没有搜索结果" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}
@end
