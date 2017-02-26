//
//  ViewController.swift
//  MDBSocials
//
//  Created by Boris Yue on 2/20/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

struct post {
    let postedBy : String!  //userID of the poster
    let name: String!   //Name of the event
    let picture: String!    //Picture of the event
    let usersInterested : [String] = []
}

class ViewController: UIViewController {
    
    var loginButton: UIButton!
    var signupButton: UIButton!
    
    var roundedView: UIView!
    var usernameField: CustomTextField!
    var passwordField: CustomTextField!
    
    var width: CGFloat = 0.0
    var height: Int = 0
    var spacing: CGFloat = 0.0
    
    var uniqueVal: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dbRef = FIRDatabase.database().reference()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.navigationController?.isNavigationBarHidden = true
        
        //CREATE USER CODE
        /*FIRAuth.auth()?.createUser(withEmail: "test@gmail.com", password: "password123") { (user, error) in
         if error != nil {
         print(error)
         }
         }*/
        
        initRoundedView()
        initLoginButton()
        initSignupButton()
        
        var incomplete: CustomTextField!
        incomplete = CustomTextField(frame: CGRect(x: 0, y: view.frame.height / 5, width: view.frame.width, height: 80))
        incomplete.text = "NOT ALL FEATURES IMPLEMENTED YET"
        incomplete.textAlignment = NSTextAlignment.center
        view.addSubview(incomplete)
        
        
        //PostsCollection.posts = PostsCollection.getImagesArray()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    /* Adds initialized username and password fields to rounded view */
    func initRoundedView() {
        /* width: 70% of screen
         height: 80 px
         */
        width = view.frame.width * 0.7
        height = 80
        spacing = (view.frame.width - width) / 2    //spacing on either side of the view
        roundedView = UIView(frame: CGRect(x: spacing, y: (view.frame.height / 2) - CGFloat(height) * 0.8, width: width, height: CGFloat(height)))
        
        usernameField = CustomTextField(frame: CGRect(x: 0 - 1, y: 0, width: Int(roundedView.frame.width) + 2, height: height / 2))
        passwordField = CustomTextField(frame: CGRect(x: 0 - 1, y: height / 2, width: Int(roundedView.frame.width) + 2, height: height / 2))
        
        passwordField.layer.borderColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0).cgColor
        
        usernameField.placeholder = "Username"
        passwordField.placeholder = "Password"
        
        usernameField.layer.masksToBounds = true
        passwordField.layer.masksToBounds = true
        
        usernameField.font = UIFont(name: "Roboto-Regular", size: 14.0)
        passwordField.font = UIFont(name: "Roboto-Regular", size: 14.0)
        
        usernameField.textContentType = UITextContentType.emailAddress
        usernameField.keyboardType = UIKeyboardType.emailAddress
        passwordField.isSecureTextEntry = true  //Makes it a password field
        
        roundedView.addSubview(usernameField)
        roundedView.addSubview(passwordField)
        
        roundedView.layer.cornerRadius = 3
        roundedView.layer.masksToBounds = true
        roundedView.layer.borderWidth = 1.0
        roundedView.layer.borderColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0).cgColor
        
        var shadowPath = UIBezierPath(rect: roundedView.bounds)
        roundedView.layer.masksToBounds = false;
        roundedView.layer.shadowColor = UIColor.black.cgColor;
        roundedView.layer.shadowOffset = CGSize.zero
        roundedView.layer.shadowOpacity = 0.5
        roundedView.layer.shadowPath = shadowPath.cgPath;
        
        var linePath = UIBezierPath()
        
        linePath.move(to: CGPoint.init(x: 0, y: height / 2))
        linePath.addLine(to: CGPoint.init(x: Int(roundedView.frame.width), y: height / 2))
        linePath.close()
        linePath.stroke()
        
        var shapeLayer = CAShapeLayer()
        shapeLayer.path = linePath.cgPath
        shapeLayer.strokeColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0).cgColor
        shapeLayer.lineWidth = 1.0
        
        roundedView.layer.addSublayer(shapeLayer)
        
        view.backgroundColor = UIColor.init(red: 59/255, green: 89/255, blue: 152/255, alpha: 1.0)
        roundedView.backgroundColor = UIColor.white
        
        usernameField.addTarget(self, action: #selector(textEntered), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textEntered), for: .editingChanged)
        
        view.addSubview(roundedView)
    }
    
    //INITIALIZE LOGIN BUTTON
    func initLoginButton() {
        loginButton = UIButton(frame: CGRect(x: spacing, y: roundedView.frame.maxY + 10, width: width, height: CGFloat(height / 2)))
        loginButton.setTitle("Log In", for: .normal)
        loginButton.addTarget(self, action: #selector(loginClicked), for: UIControlEvents.touchUpInside)
        loginButton.backgroundColor = UIColor.init(red: 118/255, green: 139/255, blue: 183/255, alpha: 1.0)
        loginButton.setTitleColor(UIColor.init(red: 200/255, green: 200/255, blue: 230/255, alpha: 1.0), for: .normal)
        
        loginButton.layer.cornerRadius = 3
        
        loginButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 16.0)
        
        view.addSubview(loginButton)
        
        loginButton.isEnabled = false
    }
    
    //LOGIN EVENT LISTENER
    func loginClicked() {
        FIRAuth.auth()?.signIn(withEmail: usernameField.text!, password: passwordField.text!) { (user, error) in
            if user != nil {
                print("logged in")
                self.performSegue(withIdentifier: "toFeed", sender: nil)
            } else {
                print(error)
            }
        }
        //print("Login click event received")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSignup" {
            let listVC = segue.destination as! SignupViewController
            //pokemonsToPass = pokemonsToPass.sorted{$0.name < $1.name} //sort alphabetically
            //listVC.pokemons = self.pokemonsToPass
        } else if segue.identifier == "toFeed" {
            let listVC = segue.destination as! FeedViewController
        }
    }
    
    //INITIALIZE SIGN UP BUTTON
    func initSignupButton() {
        signupButton = UIButton(frame: CGRect(x: 0, y: loginButton.frame.maxY + 20, width: view.frame.width, height: CGFloat(height / 2)))
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.addTarget(self, action: #selector(signupClicked), for: UIControlEvents.touchUpInside)
        signupButton.setTitleColor(UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0), for: .normal)
        signupButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 14.0)
        
        signupButton.addTarget(self, action: #selector(signupClicked), for: UIControlEvents.touchUpInside)
        
        view.addSubview(signupButton)
    }
    
    func signupClicked() {
        print("Sign up!")
        performSegue(withIdentifier: "toSignup", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 2
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        }
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textEntered(sender: CustomTextField) {
        if usernameField.text != "" && passwordField.text != "" {
            if loginButton.isEnabled == false {
                UIView.transition(with: self.loginButton, duration: 0.1, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {self.loginButton.setTitleColor(UIColor.init(red: 118/255, green: 139/255, blue: 183/255, alpha: 1.0), for: .normal)}, completion: { (finished: Bool) -> () in
                    
                    // completion
                    UIView.transition(with: self.loginButton, duration: 0.1, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {self.loginButton.setTitleColor(UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0), for: .normal)}, completion: nil)
                })
                loginButton.isEnabled = true
            }
        } else {
            if loginButton.isEnabled == true {
                UIView.transition(with: self.loginButton, duration: 0.1, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {self.loginButton.setTitleColor(UIColor.init(red: 118/255, green: 139/255, blue: 183/255, alpha: 1.0), for: .normal)}, completion: { (finished: Bool) -> () in
                    
                    // completion
                    UIView.transition(with: self.loginButton, duration: 0.1, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {self.loginButton.setTitleColor(UIColor.init(red: 200/255, green: 200/255, blue: 230/255, alpha: 1.0), for: .normal)}, completion: nil)
                })
                loginButton.isEnabled = false
            }
        }
    }
}

extension UITextField {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.masksToBounds = true
        self.layer.mask = mask
    }
}
