//
//  ViewController.swift
//  FlickrDemo
//
//  Created by apple on 2020/5/21.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

protocol FatchValueDelegate {
    
    func fetchInputText(_ text: String)
    func fetchNumber(_ text: String)
}

class ViewController: UIViewController {

    //搜尋的輸入框
    @IBOutlet weak var inputTextField: UITextField!
    //每頁要呈現的數量的輸入框
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var delegate : FatchValueDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeButtonColor), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
    }
    
    func setup(){
        
        inputTextField.placeholder = "欲搜尋內容"
        numberTextField.placeholder = "每頁呈現數量"
        searchButton.setTitle("搜尋", for: [])
        searchButton.backgroundColor = UIColor.gray
        searchButton.setTitleColor(UIColor.white, for: [])
        searchButton.isEnabled = false
        self.title = "搜尋輸入頁"
    }
    

    @IBAction func searchHandler(_ sender: UIButton) {

        if isPurnInt(string: numberTextField.text!) {
            if let controller = storyboard?.instantiateViewController(withIdentifier: "SecondVC") as? FlickrSearchCollectionViewController {
                self.delegate = controller
                self.delegate?.fetchInputText(inputTextField.text!)
                self.delegate?.fetchNumber(numberTextField.text!)
                navigationController?.pushViewController(controller, animated: true)
                
            }
        }

    }
    
    @objc func changeButtonColor(){
        
        if !self.inputTextField.text!.isEmpty && !self.numberTextField.text!.isEmpty {
            
            searchButton.backgroundColor = UIColor.blue
            searchButton.isEnabled = true
            
        } else {
            
            searchButton.backgroundColor = UIColor.gray
            searchButton.isEnabled = false
        }
    }
    
    ///判斷是否為數字
    func isPurnInt(string: String) -> Bool {
        
        let scan: Scanner = Scanner(string: string)
        
        var val:Int = 0
        
        return scan.scanInt(&val) && scan.isAtEnd
        
    }
    
}

