//
//  ResultViewController.swift
//  PersonalQuiz
//
//  Created by Vasichko Anna on 10.11.2022.
//

import UIKit

class ResultViewController: UIViewController {
    
    
    @IBOutlet var resultAnswerLabel: UILabel!
    
    
    @IBOutlet var resultDefinitionLabel: UILabel!
    
    var responses: [Answer]! // св-во для ответов
    
    
    
    // 1. Избавиться от кнопки возврата назад на экране результатов
    // 2. Передать массив с ответами на экран с результатами
    // 3. Определить наиболее часто встречающийся тип животного
   // 4. Отобразить результаты в соответствии с этим животным
    
    // использовать функции высшего порядка map и sorted
    // отдельный метод для поиска результата


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        calculatePersonalityResult ()
        
    }
    
    func calculatePersonalityResult () {
        var frequencyOfAnswers: [Animal: Int] = [:] // частота ответов с типом animal и пустым сл
        let responsesType = responses.map{ $0.animal }
        
        for response in responsesType {
            frequencyOfAnswers[response] = (frequencyOfAnswers[response] ?? 0) + 1
        }
        
        let frequentAnswersSorted = frequencyOfAnswers.sorted(by:
        {(pair1, pair2) -> Bool in
            return pair1.value > pair2.value
        })
        
        let mostCommonAnswer = frequentAnswersSorted.first!.key
        resultAnswerLabel.text = "Вы \(mostCommonAnswer.rawValue)!"
        resultDefinitionLabel.text = mostCommonAnswer.definition
    }

    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true)
    }
    
    deinit{
        print("ResultVC has been delocated")
    }
    
}
