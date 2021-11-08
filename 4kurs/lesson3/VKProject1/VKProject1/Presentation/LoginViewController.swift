//
//  LoginViewController.swift
//  VKProject1
//
//  Created by xc553a8 on 2021-08-17.
//

import UIKit
import FirebaseAuth

final class LoginViewController: UIViewController {
    
    let session = Session.instance
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var titleImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var loginTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var loginButton: UIButton!
    @IBOutlet var constraintImage: NSLayoutConstraint!
    @IBOutlet var loginLabel: UILabel!
    @IBOutlet var backTitleImageView: UIView!
    @IBOutlet var signUPButton: UIButton!
    
    private var propertyAnimator: UIViewPropertyAnimator!
    private var handle: AuthStateDidChangeListenerHandle!
    

    override func viewDidLoad() {
        super.viewDidLoad()
         
        // Жест нажатия
        let hideKeyboardGesture = UITapGestureRecognizer(target:
        self, action: #selector(hideKeyboard))
        // Присваиваем его UIScrollVIew
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.handle = Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil{
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                self.loginTextField.text = nil
                self.passwordTextField.text = nil
                                                            
            }
            
        }
        
        // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        // Второе — когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)

        let closeAction = UIAlertAction(title: "Ok",
                                        style: .cancel) { [weak self] _ in
            guard let self = self else { return }
            self.loginTextField.text = ""
            self.passwordTextField.text = ""
        }

        alertController.addAction(closeAction)

        present(alertController, animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      

    
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Auth.auth().removeStateDidChangeListener(handle)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "loginSegue"{
            // Получаем текст логина
            let login = loginTextField.text!
            // Получаем текст-пароль
            let password = passwordTextField.text!
            
            // Проверяем, верны ли они
            if login == "admin" && password == "123456" {
                print("успешная авторизация")
                return true
            } else {
                print("Не верные логин или пароль")
                showAlert(title: "Ошибка", message: "Не верный логин и пароль")
                return false
            }
        } else {
            return true
            }
    }
    
    @IBAction  func logout(_ segue: UIStoryboardSegue) {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        } catch (let error) {
            print("Auth sign out failed: \(error)")
        }
    }
    
    @IBAction private func loginButtonPressed(_ sender: UIButton) {
        guard let email = loginTextField.text,
              let password = passwordTextField.text,
              email.count > 0,
              password.count > 0
        else {
            showAlert(title: "Error", message: "Login/password is not entered")
            return
            }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            if let error = error, user == nil{
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
            
        }
        
    }
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Register", message: "Register", preferredStyle: .alert)
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"}
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let emailField = alert.textFields?[0],
                  let passwordField = alert.textFields?[1],
                  let password = passwordField.text,
                  let email = emailField.text else { return}
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] user, error in
                if let error = error {
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                } else {
                    Auth.auth().signIn(withEmail: email, password: password)
                }
            }
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func demoButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "demoLoginSegue", sender: nil)
    }
    
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }

       // Когда клавиатура появляется
    @objc func keyboardWasShown(notification: Notification) {
    
        // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
           
        // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
       
       //Когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
    }

    @IBAction func segueToLoginController(segue: UIStoryboardSegue){
        
    }
    
    @IBAction func authVKSuccessful(segue: UIStoryboardSegue) {
        if segue.identifier == "AuthVKSuccessful"{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
                {
                self
                    .performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
}

