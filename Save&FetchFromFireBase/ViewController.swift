//
//  ViewController.swift
//  Save&FetchFromFireBase
//
//  Created by Volodymyr Ostapyshyn on 22.11.2020.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet var quoteLabel: UILabel!
    @IBOutlet var quoteTextField: UITextField!
    @IBOutlet var authorTextField: UITextField!
    
    var docRef: DocumentReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        docRef = Firestore.firestore().document("sampleData/Inspiration")
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
    


}

