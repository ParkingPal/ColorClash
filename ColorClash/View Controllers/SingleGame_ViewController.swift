//
//  SingleGame_ViewController.swift
//  ColorClash
//
//  Created by ParkingPal on 12/5/20.
//

import UIKit
import Firebase

class SingleGame_ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var singleGameTitleLabel: CustomLabel!
    @IBOutlet weak var quickStatsTitleLabel: CustomLabel!
    @IBOutlet weak var classicButton: CustomButton!
    @IBOutlet weak var arcadeButton: CustomButton!
    @IBOutlet weak var hardcoreButton: CustomButton!
    @IBOutlet weak var statsScrollView: UIScrollView!
    @IBOutlet weak var statsPageControl: UIPageControl!
    @IBOutlet weak var quickStatsView: UIView!
    
    var headers: [String] = ["High Score", "Average Score", "Games Played"]
    let boardSize: [Int] = [4, 5, 6, 7, 8, 9, 10]
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var isStackViewLoaded = false
    var picker = UIPickerView()
    var textField = UITextField(frame: CGRect(x: 0.0, y: 0.0, width: 0, height: 0))
    var selectedSize = 0
    var docTimer = Timer()
    var statsTimer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSingleGameScoresDocument()
        setupLayout()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Josefin Sans", size: 30.0)!, NSAttributedString.Key.foregroundColor: UIColor(red: 176/255, green: 224/255, blue: 230/255, alpha: 1.0)]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        statsTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(changeStats), userInfo: nil, repeats: true)
        setupPicker()
        if isStackViewLoaded == false {
            docTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkDocumentInitilization), userInfo: nil, repeats: true)
        }
    }
    
    @objc func checkDocumentInitilization() {
        if SingleGameScoresDocument.isInitialized {
            setupScrollView()
            docTimer.invalidate()
        }
    }
    
    @objc func changeStats() {
        UIView.animate(withDuration: 0.5) {
            self.quickStatsView.alpha = 0.0
        }
        
        for v in statsScrollView.subviews {
            v.removeFromSuperview()
        }
        
        if quickStatsTitleLabel.text == "Quick Stats: Classic" {
            quickStatsTitleLabel.text = "Quick Stats: Arcade"
        } else if quickStatsTitleLabel.text == "Quick Stats: Arcade" {
            quickStatsTitleLabel.text = "Quick Stats: Hardcore"
        } else if quickStatsTitleLabel.text == "Quick Stats: Hardcore" {
            quickStatsTitleLabel.text = "Quick Stats: Classic"
        }
        
        setupScrollView()
    }
    
    func createSingleGameScoresDocument() {
        if !SingleGameScoresDocument.isInitialized {
            let db = Firestore.firestore()
            
            db.collection("SG_Scores").whereField("authID", isEqualTo: Auth.auth().currentUser!.uid)
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        for document in querySnapshot!.documents {
                            let documentCount = (querySnapshot?.documents.count)!
                            if documentCount == 1 {
                                SingleGameScoresDocument.create(docSnap: document)
                        }
                    }
                }
            }
        }
    }
    
    func setupLayout() {
        let buttonWidth = classicButton.frame.width
        let buttonHeight = classicButton.frame.height
        quickStatsView.alpha = 0.0
        singleGameTitleLabel.setupLabel(font: "aArang", size: 100.0, shadowOpacity: 0.3, shadowRadius: 5.0, shadowColor: 0.0)
        quickStatsTitleLabel.setupLabel(font: "aArang", size: 100.0, shadowOpacity: 0.3, shadowRadius: 5.0, shadowColor: 255.0)
        classicButton.setupButton(font: "Vollkorn", size: 75.0, horizontalInsets: buttonWidth/4, verticalInsets: buttonHeight, shadowOpacity: 0.3, shadowRadius: 10.0, shadowColor: 0.0)
        arcadeButton.setupButton(font: "Abingdon", size: 75.0, horizontalInsets: buttonWidth/4, verticalInsets: buttonHeight, shadowOpacity: 0.3, shadowRadius: 10.0, shadowColor: 0.0)
        hardcoreButton.setupButton(font: "aAssassinNinja", size: 75.0, horizontalInsets: buttonWidth/4, verticalInsets: buttonHeight, shadowOpacity: 0.3, shadowRadius: 10.0, shadowColor: 0.0)
        
        classicButton.addTarget(self, action: #selector(classicButtonClicked), for: .touchUpInside)
        classicButton.tag = 0
        arcadeButton.addTarget(self, action: #selector(arcadeButtonClicked), for: .touchUpInside)
        arcadeButton.tag = 1
        hardcoreButton.addTarget(self, action: #selector(hardcoreButtonClicked), for: .touchUpInside)
        hardcoreButton.tag = 2
    }
    
    func setupPicker() {
        self.view.addSubview(textField)
        picker.delegate = self
        picker.dataSource = self
        textField.inputView = picker
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissPicker))
        let continueButton = UIBarButtonItem(title: "Continue", style: .plain, target: self, action: #selector(pickerSelected))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let label = CustomLabel(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 50.0))
        label.text = "Choose a Board Size"
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        let convertLabel = UIBarButtonItem(customView: label)
        
        toolBar.setItems([doneButton, space, convertLabel, space, continueButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    @objc func pickerSelected() {
        view.endEditing(true)
        switch textField.text {
        case "0":
            performSegue(withIdentifier: "toClassic", sender: self)
        case "1":
            break
        case "2":
            performSegue(withIdentifier: "toHardcore", sender: self)
        default: break
        }
    }
    
    func setupScrollView() {
        var displayedGameType = ""
        if let range = quickStatsTitleLabel.text?.range(of: ": ") {
            displayedGameType = quickStatsTitleLabel.text![range.upperBound...].lowercased()
        }
        
        for index in 0 ..< headers.count {
            frame.origin.x = statsScrollView.frame.width * CGFloat(index)
            frame.size = statsScrollView.frame.size
            
            let stack = UIStackView(frame: frame)
            let header = CustomLabel(frame: frame)
            let score = CustomLabel(frame: frame)
            
            switch index {
            case 0:
                score.text = String(SingleGameScoresDocument.docData["\(displayedGameType)HS"] as! Int)
            case 1:
                score.text = String(((SingleGameScoresDocument.docData["\(displayedGameType)AS"] as! Double) * 10).rounded() / 10)
            case 2:
                score.text = String(SingleGameScoresDocument.docData["\(displayedGameType)GP"] as! Int)
            default:
                break
            }
            
            header.text = headers[index]
            header.setupLabel(font: "aArang", size: 20.0, shadowOpacity: 0.3, shadowRadius: 3.0, shadowColor: 255.0)
            header.textColor = UIColor(red: 0/255, green: 52/255, blue: 96/255, alpha: 1.0)
            score.setupLabel(font: "aArang", size: 60.0, shadowOpacity: 0.3, shadowRadius: 5.0, shadowColor: 255.0)
            score.textColor = UIColor(red: 0/255, green: 52/255, blue: 96/255, alpha: 1.0)
            header.textAlignment = .center
            score.textAlignment = .center
            
            stack.axis = .vertical
            stack.distribution = .fill
            stack.addArrangedSubview(header)
            stack.addArrangedSubview(score)
            
            score.heightAnchor.constraint(equalTo: header.heightAnchor, multiplier: 2.0).isActive = true
            
            self.statsScrollView.addSubview(stack)
            isStackViewLoaded = true
        }
        
        statsScrollView.contentSize = CGSize(width: (statsScrollView.frame.size.width * CGFloat(headers.count)), height: 1.0)
        statsScrollView.delegate = self
        
        UIView.animate(withDuration: 0.5) {
            self.quickStatsView.alpha = 1.0
        }
    }
    
    func setTextField(sender: CustomButton) {
        if UserDocument.docData["customTableUnlocked"] as! Bool {
            picker.selectRow(0, inComponent: 0, animated: true)
            selectedSize = boardSize[picker.selectedRow(inComponent: 0)]
            textField.text = String(sender.tag)
            textField.becomeFirstResponder()
        } else {
            selectedSize = 4
            switch sender.tag {
            case 0:
                performSegue(withIdentifier: "toClassic", sender: self)
            case 1:
                performSegue(withIdentifier: "toArcade", sender: self)
            case 2:
                performSegue(withIdentifier: "toHardcore", sender: self)
            default: break
            }
        }
    }
    
    @objc func classicButtonClicked(sender: CustomButton) {
        setTextField(sender: sender)
    }
    
    @objc func arcadeButtonClicked(sender: CustomButton) {
        setTextField(sender: sender)
    }
    
    @objc func hardcoreButtonClicked(sender: CustomButton) {
        setTextField(sender: sender)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        statsPageControl.currentPage = Int(pageNumber)
        statsTimer.invalidate()
        statsTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(changeStats), userInfo: nil, repeats: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        statsTimer.invalidate()
        
        let gameVC = segue.destination as! ViewController
        gameVC.xMax = selectedSize - 1
        gameVC.yMax = selectedSize - 1
        
        switch segue.identifier {
        case "toClassic":
            gameVC.board = Board(xMax: selectedSize - 1, yMax: selectedSize - 1, gameType: "Classic")
            break
        case "toArcade":
            gameVC.board = Board(xMax: selectedSize - 1, yMax: selectedSize - 1, gameType: "Arcade")
            break
        case "toHardcore":
            gameVC.board = Board(xMax: selectedSize - 1, yMax: selectedSize - 1, gameType: "Hardcore")
            break
        default: break
        }
    }
    
    @IBAction func unwindToSingleGameMenu(segue: UIStoryboardSegue) {
        for v in statsScrollView.subviews {
            v.removeFromSuperview()
        }
        
        setupScrollView()
    }
}

extension SingleGame_ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return boardSize.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(boardSize[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSize = boardSize[row]
    }
}
