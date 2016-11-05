//
//  LoginViewController.m
//  cap
//
//  Created by Alexei Pineda Caraballo on 7/22/16.
//  Copyright © 2016 Alexei Pineda Caraballo. All rights reserved.
//

#import "LoginViewController.h"
#import "GestorV.h"
#import "AppDelegate.h"
#import "LoadingView.h"
#import "ASIHTTPRequestDelegate.h"
#import "RequestManager.h"
#import "SBJsonBase.h"
#import "SBJsonParser.h"
#import "Admin.h"
#import "Usuario.h"
#import "Manager.h"
#import "HomeContadorVC.h"
#import "HomeInversionistaVC.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txbUsuario;
@property (weak, nonatomic) IBOutlet UITextField *txbPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnEntrar;
@property (weak, nonatomic) IBOutlet UIButton *btnPickRol;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [GestorV getGV].rol = @"administrador";
    [self PrepararCompontes];
    
    //iniciando datos
    [GestorV getGV].user = nil;
    [GestorV getGV].userAutenticado = nil;
    [GestorV getGV].isLogguedUser = NO;
    [GestorV getGV].token = @"";
    [GestorV getGV].uid = @"";
    [GestorV getGV].rolId = @"";
    [GestorV getGV].rol = @"";
    
}
-(void)viewDidAppear:(BOOL)animated
{
    /*ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://www.lucky-kidz.com/dataUser/user/login"]];
   
    [request addRequestHeader:@"Referer" value:@"http://allseeing‐i.com/"];
    [request setPostValue:@"username" forKey:@"username"];
    [request setPostValue:@"password" forKey:@"asdas"];
    [request setCompletionBlock:^{
         NSString *responseString = [request responseString];
        int a = 5;
    }];
    [request setFailedBlock:^{
     NSError *error = [request error];
        int a = 5;
    }];
    [request startAsynchronous];*/
    /*iendo directo a */
    HomeInversionistaVC * vc = [[HomeInversionistaVC alloc] initWithNibName:@"HomeInversionistaVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)PrepararCompontes
{
    [[GestorV getGV] ConvertirEnAnillo:_txbUsuario borderWidth:1 color:[UIColor whiteColor]];
     [[GestorV getGV] ConvertirEnAnillo:_txbPassword borderWidth:1 color:[UIColor whiteColor]];
     [[GestorV getGV] ConvertirEnAnillo:_btnEntrar borderWidth:1 color:[UIColor whiteColor]];
    [[GestorV getGV] ConvertirEnAnillo:_btnPickRol borderWidth:1 color:[UIColor whiteColor]];
    NSAttributedString *strUsuarioPlaceHolder = [[NSAttributedString alloc] initWithString:@"usuario" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    _txbUsuario.attributedPlaceholder = strUsuarioPlaceHolder;
    
    NSAttributedString *strPasswordPlaceHolder = [[NSAttributedString alloc] initWithString:@"contraseña" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    _txbPassword.attributedPlaceholder = strPasswordPlaceHolder;
    
}
- (IBAction)Login:(id)sender {
    if ([self validate])
    {
        [LoadingView showLoadingView:@"Logging in..."
                          parentView:self.view
                           backColor:YES];
        [self processLogin];
       
    }
}
#pragma mark Web Service Handling
-(void)processLogin
{
    RequestManager* rm = [RequestManager sharedInstance];
    ASIHTTPRequest* request = [rm prepareRequestToLogin:_txbUsuario.text andPassw:_txbPassword.text];
    [request setDelegate:self];
    request.tag = 1;//opteeniendo los upcomings events
    [request startAsynchronous];
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    [LoadingView hideLoadingView:self.navigationController.view];
    [[GestorV getGV] ShowError:@"Network error..." vistaControlador:self.navigationController];
    
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    int codeStatus =  [request responseStatusCode];
    if (codeStatus==200) {
        NSString * response = [request responseString];
        SBJsonParser* myParser = [[SBJsonParser alloc] init];
        NSMutableDictionary* responseDictionary = [myParser objectWithString:response];
        if ([responseDictionary isKindOfClass:[NSNull class]] || responseDictionary == nil)
        {
            [LoadingView hideLoadingView:self.navigationController.view];
            [[GestorV getGV] ShowError:@"Server internal error" vistaControlador:self.navigationController];
            return;
        }

        if (request.tag==1) {
            //todo correcto
            int   errorLogin = [[responseDictionary valueForKey:@"error"] boolValue];
            if(errorLogin == 0)
            {
                NSMutableDictionary * dicUsuario = [responseDictionary valueForKey:@"usuario"];
                [GestorV getGV].isLogguedUser = YES;
                NSString * token = [responseDictionary valueForKey:@"token"];
                
                [GestorV getGV].token = token;
                [GestorV getGV].uid = [dicUsuario valueForKey:@"_id"];
                [GestorV getGV].rolId = [[dicUsuario valueForKey:@"ids_roles"] firstObject];
                Usuario * usuario = [Usuario new];
                [usuario fromDictionary:dicUsuario];
                [GestorV getGV].user = usuario;
                [self ObtenerRol:token];
                
            }
            else
            {
                [LoadingView hideLoadingView:self.navigationController.view];
                [[GestorV getGV] ShowError:@"Usuario o contraseña incorrectos" vistaControlador:self];
            }
            //[((AppDelegate *)[UIApplication sharedApplication].delegate) showHome:self];*/
        }
        else if(request.tag == 2)
        {
            NSArray * arreglo = (NSArray *)responseDictionary;
            NSString * rol = @"";
            NSString * rolId = [GestorV getGV].rolId;
            for (int i  =0 ; i<arreglo.count; i++) {
                NSDictionary * dic =  [arreglo objectAtIndex:i];
                NSString * idRolUsuario= [dic valueForKey:@"_id"];
                if ([idRolUsuario isEqualToString:rolId]) {
                    rol =  [[dic valueForKey:@"name"] uppercaseString];
                    [GestorV getGV].rol = rol;
                    break;
                }
            }
            
            
            
            [LoadingView hideLoadingView:self.navigationController.view];
            [((AppDelegate *)[UIApplication sharedApplication].delegate) showHome:self];
            
        }
        
    }
    else
    {
        [LoadingView hideLoadingView:self.navigationController.view];
        [[GestorV getGV] ShowError:@"Network failed" vistaControlador:self.navigationController];
        //error de conexion
    }
}
-(void)ObtenerRol:(NSString *)token
{
    RequestManager* rm = [RequestManager sharedInstance];
    ASIHTTPRequest* request = [rm prepareRequestToGetRoles:token];
    [request setDelegate:self];
    request.tag = 2;//opteeniendo los upcomings events
    [request startAsynchronous];
}

-(BOOL)validate
{
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
