//
//  GuessNumberViewController.swift
//  GuessNumberPractice
//
//  Created by Tai Chin Huang on 2021/1/24.
//

import UIKit

class GuessNumberViewController: UIViewController {
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var chanceLabel: UILabel!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var rangeLabel: UILabel!
    @IBOutlet weak var againButton: UIButton!
    
    var questionNumber = 0 //設定問題變數
    var chanceNumber = 6 //機會次數
    var lowerBound = 0 //範圍的下限
    var upperBound = 50 //範圍的上限
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bgImageView.alpha = 0.75
        typeTextField.layer.cornerRadius = 250 / 4
        goButton.layer.cornerRadius = 80 / 2
        againButton.layer.cornerRadius = 25
        typeTextField.endEditing(true) //typeTextField再不編輯下收起鍵盤
        //        goButton.titleLabel?.adjustsFontSizeToFitWidth = true
        makeQuestion()
    }
    //生成題目變數
    func makeQuestion() {
        questionNumber = Int.random(in: 0...50)
        print(questionNumber)
        chanceLabel.text = "你有\(chanceNumber)次機會！"
        rangeLabel.text = "範圍 \(lowerBound) ~ \(upperBound)"
    }
    /*情境
     1. 等於答案
     2. 輸入數字大於答案
     2-1. 輸入數字大於範圍（提醒超出範圍）
     2-2. 若沒有則將輸入的數字設成上限值
     3. 輸入數字小於答案
     3-1. 輸入數字小於範圍（提醒超出範圍）
     3-2. 若沒有則將輸入的數字設成下限值
     */
    func checkAnswer() {
        if typeTextField.text == String(questionNumber) {
            let controller = UIAlertController(title: "答對了", message: "正確答案是\(questionNumber)", preferredStyle: .alert)
            let action = UIAlertAction(title: "Re-Play", style: .default) { (_) in
                self.playAgain()
            }
            controller.addAction(action)
            present(controller, animated: true, completion: nil)
        } else if typeTextField.text! > String(questionNumber) {
            if typeTextField.text! >= String(upperBound) {
                let controller = UIAlertController(title: "數字太大囉！", message: "請輸入範圍內的數字", preferredStyle: .alert)
                let action = UIAlertAction(title: "了解", style: .default) { (_) in
                    self.typeTextField.text = ""
                }
                controller.addAction(action)
                present(controller, animated: true, completion: nil)
            } else {
                chanceNumber -= 1
                upperBound = Int(typeTextField.text!)!
                chanceLabel.text = "你有\(chanceNumber)次機會！"
                rangeLabel.text = "範圍 \(lowerBound) ~ \(upperBound)"
                typeTextField.text = ""
            }
        } else if typeTextField.text! < String(questionNumber) {
            if typeTextField.text! <= String(lowerBound) {
                let controller = UIAlertController(title: "數字太小囉！", message: "請輸入範圍內的數字", preferredStyle: .alert)
                let action = UIAlertAction(title: "了解", style: .default) { (_) in
                    self.typeTextField.text = ""
                }
                controller.addAction(action)
                present(controller, animated: true, completion: nil)
            } else {
                chanceNumber -= 1
                lowerBound = Int(typeTextField.text!)!
                chanceLabel.text = "你有\(chanceNumber)次機會！"
                rangeLabel.text = "範圍 \(lowerBound) ~ \(upperBound)"
                typeTextField.text = ""
            }
        }
    }
    /*情境
     1. 未輸入情況
     2. 機會大於一次
     3. 機會小於一次
     */
    @IBAction func go(_ sender: UIButton) {
        if typeTextField.text == "" {
            let controller = UIAlertController(title: "請給我一個數字", message: "輸入數字才可以繼續喔！", preferredStyle: .alert)
            let action = UIAlertAction(title: "了解", style: .default, handler: nil)
            controller.addAction(action)
            present(controller, animated: true, completion: nil)
        } else if chanceNumber > 1 {
            checkAnswer()
        } else {
            let controller = UIAlertController(title: "遊戲結束", message: "正確答案是\(questionNumber)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                //將剩餘結果畫面顯示在上面
                self.chanceLabel.text = "你已經用完所有機會了！"
                self.typeTextField.text = "\(self.questionNumber)"
                self.rangeLabel.text = "沒猜中！"
                self.goButton.isUserInteractionEnabled = false
            }
            controller.addAction(okAction)
            let replayAction = UIAlertAction(title: "Re-Play", style: .default) { (_) in
                self.playAgain()
            }
            controller.addAction(replayAction)
            present(controller, animated: true, completion: nil)
        }
    }
    @IBAction func rePlay(_ sender: UIButton) {
        playAgain()
    }
    func playAgain() {
        chanceNumber = 6
        lowerBound = 0
        upperBound = 50
        makeQuestion()
        typeTextField.text = ""
        goButton.isUserInteractionEnabled = true
    }
    //點選畫面其他地方會收掉鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
