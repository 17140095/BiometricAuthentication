//
//  ViewController.swift
//  PhotoFrame
//
//  Created by Ali Raza on 26/01/2023.
//

import UIKit
import LocalAuthentication

class FirstVC: UIViewController {
    
    @IBOutlet weak var faceImage: UIImageView!
    @IBOutlet weak var touchImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        print("Show first")
        faceImage.isUserInteractionEnabled = true
        touchImage.isUserInteractionEnabled = true
        
        let touchTapGR = UITapGestureRecognizer(target: self, action: #selector(self.authenticate) )
        let faceTapGR = UITapGestureRecognizer(target: self, action: #selector(self.authenticate))
        
        faceImage.addGestureRecognizer(faceTapGR)
        touchImage.addGestureRecognizer(touchTapGR)
        
        self.showOnlyValidView()
        self.viewDidLayoutSubviews()
    }
   
    private func showOnlyValidView(){
        let context = LAContext()
        var error: NSError?
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if context.biometryType == .touchID {
            self.faceImage.isHidden = true
            self.touchImage.isHidden = false
        }else if context.biometryType == .faceID {
            self.faceImage.isHidden = false
            self.touchImage.isHidden = true
        }else{
            self.faceImage.isHidden = true
            self.touchImage.isHidden = true
            
            print("No Biometric available")
        }
    }

    
    @objc
    private func authenticate(){
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Identify yourself by touch id"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        print("Authentication success")
                        //self?.showAlert(title: "Success", message: "Successfully authenticate you.")
                        self?.loadSecondView()
                    }else{
                        self?.showAlert(title: "Authenticatin Failed", message: "Couldn't Identify")
                    }
                }
            }
            
        }else{
            showAlert(title: "Biometric Unavailable", message: "Your device not supported biometric authentication")
        }
    }
    
    
    private func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
        
    }
    private func loadSecondView(){
        let secondView = self.storyboard?.instantiateViewController(withIdentifier: "SecondVC") as? UIViewController
        if let next = secondView {
            next.modalPresentationStyle = .fullScreen
            self.present(next, animated: true)
        }
        
    }
}
