//
//  ViewController.swift
//  SwiftCalc
//
//  Created by Zach Zeleznick on 9/20/16.
//  Copyright © 2016 zzeleznick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Width and Height of Screen for Layout
    var w: CGFloat!
    var h: CGFloat!
    

    // IMPORTANT: Do NOT modify the name or class of resultLabel.
    //            We will be using the result label to run autograded tests.
    // MARK: The label to display our calculations
    var resultLabel = UILabel()
    
    // TODO: This looks like a good place to add some data structures.
    //       One data structure is initialized below for reference.
    var operators: [String] = []
    var numbers: [String] = []
    var expectNum: Bool = true
    
    func cleanSlate() {
        operators = []
        numbers = []
        expectNum = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        w = view.bounds.size.width
        h = view.bounds.size.height
        navigationItem.title = "Calculator"
        // IMPORTANT: Do NOT modify the accessibilityValue of resultLabel.
        //            We will be using the result label to run autograded tests.
        resultLabel.accessibilityValue = "resultLabel"
        makeButtons()
        // Do any additional setup here.
        cleanSlate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TODO: Ensure that resultLabel gets updated.
    //       Modify this one or create your own.
    func updateResultLabel(_ content: String) {
        
        if content.characters.count > 7 {
            let index = content.index(content.startIndex, offsetBy: 7)
            resultLabel.text = content.substring(to: index)
        } else {
            resultLabel.text = content
        }
    }
    
    
    // TODO: A calculate method with no parameters, scary!
    //       Modify this one or create your own.
    func calculate() -> String {
        if numbers.count == 1 {
            return numbers[0]
        }
        var i = 1
        var retVal = numbers[0]
        for op in operators {
            if let a = Int(retVal), let b = Int(numbers[i]) {
                retVal = intCalculate(a: a, b: b, operation: op)
            } else {
                retVal = calculate(p_a: retVal, p_b: numbers[i], operation: op)
            }
            i += 1
        }
        return retVal
    }
    
    // TODO: A simple calculate method for integers.
    //       Modify this one or create your own.
    func intCalculate(a: Int, b:Int, operation: String) -> String {
        print("Calculation requested for \(a) \(operation) \(b)")
        switch operation {
            case "+":
                return String(a + b)
            case "*":
                return String(a * b)
            case "/":
                if a % b != 0 {
                    return calculate(p_a: String(a), p_b: String(b), operation: operation)
                }
                return String(a / b)
            case "-":
                return String(a - b)
            default:
                return String(a % b)
        }
    }
    
    // TODO: A general calculate method for doubles
    //       Modify this one or create your own.
    func calculate(p_a: String, p_b:String, operation: String) -> String {
        let a = Double(p_a)!
        let b = Double(p_b)!
        print("Calculation requested for \(a) \(operation) \(b)")
        switch operation {
        case "+":
            return String(a + b)
        case "*":
            return String(a * b)
        case "/":
            return String(a / b)
        case "-":
            return String(a - b)
        default:
            return String(a / b)
        }
    }
    
    // REQUIRED: The responder to a number button being pressed.
    func numberPressed(_ sender: CustomButton) {
        guard Int(sender.content) != nil else { return }
        
        print("The number \(sender.content) was pressed")
        
        
        if expectNum {
            numbers.append(sender.content)
            expectNum = false
        } else {
            numbers[numbers.count - 1] += sender.content
        }
        updateResultLabel(numbers[numbers.count - 1])
    }
    
    // REQUIRED: The responder to an operator button being pressed.
    func operatorPressed(_ sender: CustomButton) {
        print("The operator \(sender.content) was pressed")
        
        if sender.content == "C" {
            updateResultLabel("0")
            cleanSlate()
        }
        
        if expectNum {
            return
        }
        
        switch sender.content {
            case "+/-":
                var c = numbers[numbers.count - 1]
                if (c[c.startIndex] == "-") {
                    numbers[numbers.count - 1].remove(at: c.startIndex)
                } else {
                    print("fdsa")
                    numbers[numbers.count - 1].insert("-", at: c.startIndex)
                }
                updateResultLabel(numbers[numbers.count - 1])
            default:
                let r = calculate()
                updateResultLabel(r)
                cleanSlate()
                numbers.append(r)
                if sender.content != "=" {
                    operators.append(sender.content)
                } else {
                    expectNum = false
                }
        }
    }
    
    // REQUIRED: The responder to a number or operator button being pressed.
    func buttonPressed(_ sender: CustomButton) {
        print("The button \(sender.content) was pressed")
        switch sender.content {
            case ".":
                if expectNum {
                    numbers.append("0")
                    expectNum = false
                }
                numbers[numbers.count - 1] += "."
                updateResultLabel(numbers[numbers.count - 1])
            case "0":
                if expectNum {
                    numbers.append("0")
                    expectNum = false
                }
                numbers[numbers.count - 1] += "0"
                updateResultLabel(numbers[numbers.count - 1])
            default:
                print("lul")
        }
    }
    
    // IMPORTANT: Do NOT change any of the code below.
    //            We will be using these buttons to run autograded tests.
    
    func makeButtons() {
        // MARK: Adds buttons
        let digits = (1..<10).map({
            return String($0)
        })
        let operators = ["/", "*", "-", "+", "="]
        let others = ["C", "+/-", "%"]
        let special = ["0", "."]
        
        let displayContainer = UIView()
        view.addUIElement(displayContainer, frame: CGRect(x: 0, y: 0, width: w, height: 160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }
        displayContainer.addUIElement(resultLabel, text: "0", frame: CGRect(x: 70, y: 70, width: w-70, height: 90)) {
            element in
            guard let label = element as? UILabel else { return }
            label.textColor = UIColor.white
            label.font = UIFont(name: label.font.fontName, size: 60)
            label.textAlignment = NSTextAlignment.right
        }
        
        let calcContainer = UIView()
        view.addUIElement(calcContainer, frame: CGRect(x: 0, y: 160, width: w, height: h-160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }

        let margin: CGFloat = 1.0
        let buttonWidth: CGFloat = w / 4.0
        let buttonHeight: CGFloat = 100.0
        
        // MARK: Top Row
        for (i, el) in others.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Second Row 3x3
        for (i, digit) in digits.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: digit), text: digit,
            frame: CGRect(x: x, y: y+101.0, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(numberPressed), for: .touchUpInside)
            }
        }
        // MARK: Vertical Column of Operators
        for (i, el) in operators.enumerated() {
            let x = (CGFloat(3) + 1.0) * margin + (CGFloat(3) * buttonWidth)
            let y = (CGFloat(i) + 1.0) * margin + (CGFloat(i) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.backgroundColor = UIColor.orange
                button.setTitleColor(UIColor.white, for: .normal)
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Last Row for big 0 and .
        for (i, el) in special.enumerated() {
            let myWidth = buttonWidth * (CGFloat((i+1)%2) + 1.0) + margin * (CGFloat((i+1)%2))
            let x = (CGFloat(2*i) + 1.0) * margin + buttonWidth * (CGFloat(i*2))
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: 405, width: myWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            }
        }
    }

}
