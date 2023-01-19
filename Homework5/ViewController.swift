//
//  ViewController.swift
//  Homework5
//
//  Created by Berkay Tuncel on 18.01.2023.
//

import UIKit

struct Consts {
    static let deviceWidth = UIScreen.main.bounds.width
    static let align: CGFloat = 16
    static let spacing: CGFloat = 12
    static let allClear: String = "AC"
    static let clear: String = "C"
}

final class ViewController: UIViewController {
    
    @IBOutlet var stackViewHeights: [NSLayoutConstraint]!
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet weak var calculationLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    private var buttonHeight = CGFloat()
    
    private var calculator = Calculator(total: 0, tempNumb: 0, plusPressed: false, plusJustPressed: false, equalJustPressed: false, dotPressed: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonHeight = (Consts.deviceWidth - (2 * Consts.align) - (3 * Consts.spacing)) / 4
        
        configureStackViewHeights()
        configureButtonsRadius()
    }
    
    @IBAction func numPressed(_ sender: UIButton) {
        if calculator.plusJustPressed == true {
            refreshCalculationLabel(number: "\(sender.tag)")
            setPlusButtonJustPressed(isPressed: false)
        } else if calculator.equalJustPressed == true {
            calculatorAllClear()
            refreshCalculationLabel(number: "\(sender.tag)")
        } else {
            refreshCalculationLabel(number: "\(calculationLabel.text!)\(sender.tag)")
        }
        calculator.equalJustPressed = false
        clearButtonSetLabel(str: Consts.clear)
    }
    
    @IBAction func operationPressed(_ sender: UIButton) {
        
        guard var temp = Double(calculationLabel.text!) else { return }
        
        switch sender.tag {
        case -1: // +/-
            temp *= -1
            refreshCalculationLabel(number: "\(temp)")
        case 0: // AC
            if calculator.plusPressed == true && temp != 0 {
                clearButtonSetLabel(str: Consts.allClear)
                calculator.total = 0
                setPlusButtonJustPressed(isPressed: true)
            } else {
                calculatorAllClear()
            }
            calculator.plusPressed = false
            calculator.dotPressed = false
            refreshCalculationLabel(number: "\(calculator.total)")
        case 1: // +
            if calculator.plusPressed == true {
                calculator.total += temp
                calculator.tempNumb = temp
                refreshCalculationLabel(number: "\(calculator.total)")
            } else {
                calculator.total = temp
                calculator.tempNumb = temp
                calculator.plusPressed = true
            }
            setPlusButtonJustPressed(isPressed: true)
            calculator.dotPressed = false
        case 2: // =
            if calculator.plusPressed == true {
                calculator.total += temp
                calculator.tempNumb = temp
            } else {
                calculator.total = temp + calculator.tempNumb
            }
            calculator.equalJustPressed = true
            calculator.plusPressed = false
            setPlusButtonJustPressed(isPressed: false)
            refreshCalculationLabel(number: "\(calculator.total)")
            calculator.dotPressed = false
        case 3: // .
            if calculator.dotPressed == true { return }
            
            calculator.dotPressed = true
            
            if calculator.plusJustPressed == true {
                setPlusButtonJustPressed(isPressed: false)
            } else if calculator.equalJustPressed == true {
                calculatorAllClear()
            } else {
                calculationLabel.text = "\(calculationLabel.text!)."
                break
            }
            calculationLabel.text = "0."
        default:
            break
        }
    }
}

extension ViewController {
    
    func refreshCalculationLabel(number: String) {
        guard let temp = Double(number) else { return }
        let temp2 = Int(temp)
        if abs(temp) > abs(Double(temp2)) {
            let roundedValue = round(temp * 1000) / 1000.0
            calculationLabel.text = "\(roundedValue)"
        } else {
            calculationLabel.text = "\(temp2)"
        }
    }
    
    func clearButtonSetLabel(str: String) {
        clearButton.titleLabel?.text = str
        clearButton.titleLabel?.textAlignment = .center
    }
    
    func setPlusButtonJustPressed(isPressed: Bool) {
        calculator.plusJustPressed = isPressed
        if isPressed {
            plusButton.tintColor = UIColor(named: "primaryOperationColor")
            plusButton.backgroundColor = UIColor(named: "primaryColor")
        } else {
            plusButton.tintColor = UIColor(named: "primaryColor")
            plusButton.backgroundColor = UIColor(named: "primaryOperationColor")
        }
    }
    
    func calculatorAllClear() {
        calculator.total = 0
        calculator.plusPressed = false
        setPlusButtonJustPressed(isPressed: false)
        calculator.equalJustPressed = false
        calculator.dotPressed = false
    }
    
    func configureStackViewHeights() {
        for stackViewHeight in stackViewHeights {
            stackViewHeight.constant = buttonHeight
        }
    }
    
    func configureButtonsRadius() {
        for button in buttons {
            button.layer.cornerRadius = buttonHeight / 2
            button.clipsToBounds = true
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
