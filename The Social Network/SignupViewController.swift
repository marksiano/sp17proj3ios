//
//  SignupViewController.swift
//  MDBSocials
//
//  Created by Mark Siano on 2/22/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignupViewController: UIViewController {
    
    var firstnameField: CustomTextField!
    var lastnameField: CustomTextField!
    var usernameField: CustomTextField!
    var passwordField: CustomTextField!
    var emailField: CustomTextField!
    
    var back: UIButton!
    
    var roundedView: UIView!
    
    var width: CGFloat = 0.0
    var height: Int = 0
    var spacing: CGFloat = 0.0
    
    var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        
        initRoundedView()
        initBackButton()
        initSignupButton()
        
        usernameField.addTarget(self, action: #selector(textEntered), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textEntered), for: .editingChanged)
        firstnameField.addTarget(self, action: #selector(textEntered), for: .editingChanged)
        lastnameField.addTarget(self, action: #selector(textEntered), for: .editingChanged)
        emailField.addTarget(self, action: #selector(textEntered), for: .editingChanged)
    }
    
    //Enter this user into the database
    func createUser(userName: String, firstName: String, lastName: String, email: String) {
        let dbRef = FIRDatabase.database().reference()
        
        let info : [String : AnyObject] = ["username" : userName as AnyObject, "firstname" : firstName as AnyObject, "lastname" : lastName as AnyObject, "email" : email as AnyObject]
        dbRef.child("Users").childByAutoId().setValue(info)
    }
    
    /* Adds initialized username and password fields to rounded view */
    func initRoundedView() {
        /* width: 70% of screen
         height: 80 px
         */
        width = view.frame.width * 0.7
        height = 80
        spacing = (view.frame.width - width) / 2    //spacing on either side of the view
        roundedView = UIView(frame: CGRect(x: spacing, y: (view.frame.height / 2) - CGFloat(height) * 1.6, width: width, height: CGFloat((height / 2) * 5)))
        
        firstnameField = CustomTextField(frame: CGRect(x: 0 - 1, y: 0, width: Int(roundedView.frame.width) + 2, height: height / 2))
        lastnameField = CustomTextField(frame: CGRect(x: 0 - 1, y: height / 2, width: Int(roundedView.frame.width) + 2, height: height / 2))
        emailField = CustomTextField(frame: CGRect(x: 0 - 1, y: (height / 2) * 2, width: Int(roundedView.frame.width) + 2, height: height / 2))
        usernameField = CustomTextField(frame: CGRect(x: 0 - 1, y: (height / 2) * 3, width: Int(roundedView.frame.width) + 2, height: height / 2))
        passwordField = CustomTextField(frame: CGRect(x: 0 - 1, y: (height / 2) * 4, width: Int(roundedView.frame.width) + 2, height: height / 2))
        
        passwordField.layer.borderColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0).cgColor
        
        usernameField.placeholder = "Username"
        passwordField.placeholder = "Password"
        firstnameField.placeholder = "First Name"
        lastnameField.placeholder = "Last Name"
        emailField.placeholder = "Email Address"
        
        usernameField.layer.masksToBounds = true
        passwordField.layer.masksToBounds = true
        firstnameField.layer.masksToBounds = true
        lastnameField.layer.masksToBounds = true
        emailField.layer.masksToBounds = true
        
        usernameField.font = UIFont(name: "Roboto-Regular", size: 14.0)
        passwordField.font = UIFont(name: "Roboto-Regular", size: 14.0)
        firstnameField.font = UIFont(name: "Roboto-Regular", size: 14.0)
        lastnameField.font = UIFont(name: "Roboto-Regular", size: 14.0)
        emailField.font = UIFont(name: "Roboto-Regular", size: 14.0)
        
        emailField.keyboardType = UIKeyboardType.emailAddress
        passwordField.isSecureTextEntry = true  //Makes it a password field
        
        roundedView.addSubview(firstnameField)
        roundedView.addSubview(lastnameField)
        roundedView.addSubview(emailField)
        roundedView.addSubview(usernameField)
        roundedView.addSubview(passwordField)
        
        roundedView.layer.cornerRadius = 5
        roundedView.layer.masksToBounds = true
        roundedView.layer.borderWidth = 1.0
        roundedView.layer.borderColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0).cgColor
        
        var linePath = UIBezierPath()
        
        linePath.move(to: CGPoint.init(x: 0, y: height / 2))
        linePath.addLine(to: CGPoint.init(x: Int(roundedView.frame.width), y: height / 2))
        linePath.move(to: CGPoint.init(x: 0, y: (height / 2) * 2))
        linePath.addLine(to: CGPoint.init(x: Int(roundedView.frame.width), y: (height / 2) * 2))
        linePath.move(to: CGPoint.init(x: 0, y: (height / 2) * 3))
        linePath.addLine(to: CGPoint.init(x: Int(roundedView.frame.width), y: (height / 2) * 3))
        linePath.move(to: CGPoint.init(x: 0, y: (height / 2) * 4))
        linePath.addLine(to: CGPoint.init(x: Int(roundedView.frame.width), y: (height / 2) * 4))
        linePath.close()
        linePath.stroke()
        
        var shapeLayer = CAShapeLayer()
        shapeLayer.path = linePath.cgPath
        shapeLayer.strokeColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0).cgColor
        shapeLayer.lineWidth = 1.0
        
        roundedView.layer.addSublayer(shapeLayer)
        
        view.backgroundColor = UIColor.init(red: 245/255, green: 245/255, blue: 248/255, alpha: 1.0)
        roundedView.backgroundColor = UIColor.white
        
        //usernameField.addTarget(self, action: #selector(textEntered), for: .editingChanged)
        //passwordField.addTarget(self, action: #selector(textEntered), for: .editingChanged)
        
        view.addSubview(roundedView)
    }
    
    func initBackButton() {
        let height = 40.0
        back = UIButton(frame: CGRect(x: -1, y: view.frame.maxY - CGFloat(height) + 1, width: view.frame.width + 2, height: CGFloat(height)))
        back.setTitle("Already have an account?", for: .normal)
        back.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 12.0)
        back.setTitleColor(UIColor.init(red: 150/255, green: 150/255, blue: 220/255, alpha: 1.0), for: .normal)
        back.layer.borderColor = UIColor.init(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0).cgColor
        back.layer.borderWidth = 1.0
        
        back.addTarget(self, action: #selector(backClicked), for: UIControlEvents.touchUpInside)
        
        view.addSubview(back)
    }
    
    func backClicked() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func initSignupButton() {
        let height = 40.0
        
        signupButton = UIButton(frame: CGRect(x: spacing, y: roundedView.frame.maxY + 10, width: width, height: CGFloat(height)))
        signupButton.setTitle("Sign Up!", for: .normal)
        signupButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 14.0)
        signupButton.backgroundColor = UIColor.init(red: 118/255, green: 139/255, blue: 183/255, alpha: 1.0)
        signupButton.setTitleColor(UIColor.init(red: 200/255, green: 200/255, blue: 230/255, alpha: 1.0), for: .normal)
        
        signupButton.layer.cornerRadius = 2
        
        view.addSubview(signupButton)
        
        signupButton.isEnabled = false
        
        signupButton.addTarget(self, action: #selector(signupClicked), for: UIControlEvents.touchUpInside)
    }
    
    func signupClicked() {
        //TODO: Implement this method with Firebase!
        //let profileImageData = UIImageJPEGRepresentation(UIImage.init(named: "default.png"), 0.9)
        let email = emailField.text!
        let password = passwordField.text!
        let firstname = firstnameField.text!
        let lastname = lastnameField.text!
        let username = usernameField.text!
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            if error == nil {
                let ref = FIRDatabase.database().reference().child("Users").child((FIRAuth.auth()?.currentUser?.uid)!)
                ref.setValue(["firstname": firstname, "email": email, "lastname": lastname, "username": username])
                    //self.performSegue(withIdentifier: "toFeedFromSignup", sender: self)
                    self.performSegue(withIdentifier: "toFeed", sender: self)
            }
            else {
                print(error.debugDescription)
            }
        })
    }
    
    func textEntered(sender: CustomTextField) {
        if usernameField.text != "" && passwordField.text != "" && firstnameField.text != "" && lastnameField.text != "" && passwordField.text != "" {
            if signupButton.isEnabled == false {
                UIView.transition(with: self.signupButton, duration: 0.1, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {self.signupButton.setTitleColor(UIColor.init(red: 118/255, green: 139/255, blue: 183/255, alpha: 1.0), for: .normal)}, completion: { (finished: Bool) -> () in
                    
                    // completion
                    UIView.transition(with: self.signupButton, duration: 0.1, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {self.signupButton.setTitleColor(UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0), for: .normal)}, completion: nil)
                })
                signupButton.isEnabled = true
            }
        } else {
            if signupButton.isEnabled == true {
                UIView.transition(with: self.signupButton, duration: 0.1, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {self.signupButton.setTitleColor(UIColor.init(red: 118/255, green: 139/255, blue: 183/255, alpha: 1.0), for: .normal)}, completion: { (finished: Bool) -> () in
                    
                    // completion
                    UIView.transition(with: self.signupButton, duration: 0.1, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {self.signupButton.setTitleColor(UIColor.init(red: 200/255, green: 200/255, blue: 230/255, alpha: 1.0), for: .normal)}, completion: nil)
                })
                signupButton.isEnabled = false
            }
        }
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
