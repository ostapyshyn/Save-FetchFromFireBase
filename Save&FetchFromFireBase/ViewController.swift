//
//  ViewController.swift
//  Save&FetchFromFireBase
//
//  Created by Volodymyr Ostapyshyn on 22.11.2020.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController, GIDSignInDelegate {
    
    @IBOutlet var quoteLabel: UILabel!
    @IBOutlet var quoteTextField: UITextField!
    @IBOutlet var authorTextField: UITextField!
    
    var docRef: DocumentReference!
    var quoteListener: ListenerRegistration!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.delegate = self
        docRef = Firestore.firestore().document("sampleData/Inspiration")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        quoteListener = docRef.addSnapshotListener { (docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else { return }
            let myData = docSnapshot.data()
            let latestQuote = myData?["quote"] as? String ?? ""
            let quoteAuthor = myData?["author"] as? String ?? "(none)"
            self.quoteLabel.text = "\"\(latestQuote)\" -- \(quoteAuthor)"
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        quoteListener.remove()
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        guard let quoteText = quoteTextField.text, !quoteText.isEmpty else { return }
        guard let quoteAuthor = authorTextField.text, !quoteAuthor.isEmpty else { return }
        let dataToSave: [String: Any] = ["quote": quoteText, "author": quoteAuthor]
        docRef.setData(dataToSave) { error in
            if let error = error {
                print("Error: ", error.localizedDescription)
            } else {
                print("Data has been saved!")
            }
        }
    }
    
    @IBAction func fetchTapped(_ sender: UIButton) {
        docRef.getDocument { [self] (docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else { return }
            let myData = docSnapshot.data()
            let latestQuote = myData?["quote"] as? String ?? ""
            let quoteAuthor = myData?["author"] as? String ?? "(none)"
            self.quoteLabel.text = "\"\(latestQuote)\" -- \(quoteAuthor)"
            
        }
    }
    
    @IBAction func googleLoginTap(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(user.userID!)
        }
    }
    
    
    
    


}

