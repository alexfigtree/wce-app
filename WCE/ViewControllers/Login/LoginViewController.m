//
//  LoginViewController.m
//  WCE
//
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImage *image = [UIImage imageNamed:@"WCE_LogoWhite.png"];
    [[[self navigationController] navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
	[[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Default.png"]]];
    
    //followed nathan barry's tutorial http://nathanbarry.com/designing-buttons-ios5/
    //to create these buttons
    UIImage *bg = [[UIImage imageNamed:@"button-bg.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
 
    [login setBackgroundImage:bg forState:UIControlStateNormal];
    [changePass setBackgroundImage:bg forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
    //[self.navigationController setNavigationBarHidden:YES];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
	
	// retrieve the password
	BOOL hasSetPassword = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasSetPassword"];
	if(!hasSetPassword)
		_password = @"12345";
	else
	{
		_password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
        NSLog(@"Password is: %@", _password);		//[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:TRUE] forKey:@"hasSetPassword"];
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if([[segue identifier] isEqualToString:@"pushChangePassword"])
	{
		ChangePassViewController *vc = (ChangePassViewController *)[segue destinationViewController];
		[vc setOldPasswordToCheck:_password];
		[vc setDelegate:self];
	}
}

- (void)didDismissViewController:(ChangePassViewController *)viewController
{
	_password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushLocationView:(id)sender
{
    
    if ([self.passcodeField.text isEqualToString:_password]) // We compare it to the string "12345"
    {
        self.passcodeField.text = @""; // Erase the passcode entered in the text field
		
		// Remeber that the user has logged in
		[[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"loggedIn"];
		[[NSUserDefaults standardUserDefaults] synchronize];

		
		[_delegate willDismissPresentedViewController];
		[self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        self.passcodeField.text = @""; // Erase the passcode entered in the text field
        
        // Copied this right off a website, it just creates an alert box that tells you that the passcode you entered was wrong
        UIAlertView *incorrectCodeMessage = [[UIAlertView alloc] initWithTitle:@"Incorrect Passcode" message:@"Try entering your passcode again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        // Actually shows the alert message
        [incorrectCodeMessage show];
    }
    
}
@end
