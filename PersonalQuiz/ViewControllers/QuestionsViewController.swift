//
//  ViewController.swift
//  PersonalQuiz
//
//  Created by Vasichko Anna on 07.11.2022.
//

import UIKit

class QuestionsViewController: UIViewController {
    
    //MARK: - IBOtlets
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var questionProgressView: UIProgressView!
    
    @IBOutlet var singleStackView: UIStackView!
    @IBOutlet var singleButtons: [UIButton]!
    
    @IBOutlet var multipleStackView: UIStackView!
    @IBOutlet var multipleLabels: [UILabel]!
    @IBOutlet var multipleSwitches: [UISwitch]!
    
    @IBOutlet var rangedStackView: UIStackView!
    @IBOutlet var rangedLabels: [UILabel]!
    @IBOutlet var rangedSlider: UISlider! {
        didSet { // настройки слайдера, метод срабатывает при изменении значения слайдера
            let answerCount = Float(currentAnswers.count - 1) // максимальное количество ответов
            rangedSlider.maximumValue = answerCount // максимальное значение для слайдера
            rangedSlider.value = answerCount / 2 // текущее значение для того чтоб бегунок отображался по середине
        }
    }
    
    // MARK: - Private Properties
    private let questions = Question.getQuestions()
    private var questionIndex = 0 // свойство под индекс для массива с вопросами
    private var answersChosen: [Answer] = [] // массив с ответами пользователя, будет наполняться выбранными ответами
    private var currentAnswers: [Answer] {
        questions[questionIndex].answers // вычисляемое св-во, которое хранит в себе ответы
    }
    // questions[questionIndex].answers
    //questions -массив
    //questionIndex] - индекс вопроса
    //answers - ответ вопроса
    // вызывая метод ShowSingleStack мы передает его в негоБ после чего метод showCurrentAnswers вызываем в UIБ после чего обновляется интерфейс
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    //MARK: - IBActions
    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) { // кнопки первого вопроса
        guard let buttonIndex = singleButtons.firstIndex(of: sender) else { return } // фиксация индекса выбранной кнопки
        let currentAnswer = currentAnswers[buttonIndex]
        answersChosen.append(currentAnswer) // определение текущего вопроса по индексу чтобы добавить в массив
        
        goToNextQuestion()
    }
    
    
    @IBAction func multipleAnswerButtonPressed() { // кнопка ответить второго вопроса
        for (multipleSwitch, answer) in zip(multipleSwitches, currentAnswers) { // установка соответствия
            if multipleSwitch.isOn { // если свитч Вкл - в  массив answersChosen добавляется ответ
                answersChosen.append(answer)
            }
        }
        goToNextQuestion() // переход к следующему вопросу
    }
    
    
    @IBAction func rangedButtonPressed() { // кнопка ответить третьего вопроса
        let index = lrintf(rangedSlider.value) // текущее значение слайдера, lrintf - метод для округления числа из Флоат в Инт
        answersChosen.append(currentAnswers[index]) // помещаем элемент из currentAnswers по индексу
        
        goToNextQuestion() // метод по обновлению интерфейса
    }
}

//MARK: - Navigation
extension QuestionsViewController {
    private func goToNextQuestion() { // вызывается из метода кнопки
        questionIndex += 1 // увеличение индекса вопроса и обновлять интерфейс
        
        if questionIndex < questions.count {
            updateUI()
            return
        }
        
        performSegue(withIdentifier: "showResult", sender: nil) // переход к результату
    }
}

// MARK: - Private Methods
extension QuestionsViewController {
    
    private func updateUI() { // метод по установке интерфейса
        // Hide stacks - скрывание стеков
        for stackView in [singleStackView, multipleStackView, rangedStackView] { // перебираем стеки в массиве созданном тут же
            stackView?.isHidden = true // скрываем все стеки и через свойство stackView скрываем
        }
        
        // Get current question - св-во для текущих вопросов и ответов, прогресса
        let currentQuestion = questions[questionIndex] // сво-во с массивом и элементомс индексом созданно м в private finc
        
        // Set current question for question label - отображение вопроса в лейбле
        questionLabel.text = currentQuestion.title // вопрос по индексу в лейбле
        
        // Calculate progress - прогресс для прогресс вью, делим номер вопроса на количество оборачиваем в float тк они в int, profressView принимает float
        
        let totalProgress = Float(questionIndex) / Float(questions.count)
        
        // Set progress for questionProgressView - прогресс через метод setProgress передаем прогресс
        questionProgressView.setProgress(totalProgress, animated: true)
        
        // Set navigation title - номер вопроса в title NavigationBar
        title = "Вопрос № \(questionIndex + 1) из \(questions.count)"
        // questions.count - общее количество вопросов
        
        // Show stacks corresponding to question type
        showCurrentAnswers(for: currentQuestion.responseType) // вызов метода showCurrentAnswers по отображению интерфейсов
        
    }
    
    private func showCurrentAnswers(for type: ResponseType) {
        switch type { // для отображения соответсвующего вопроса у стек, где ResponseType - это перечисление с типами вопросов
        case .single: showSingleStack(with: currentAnswers) // showSingleStack - ф-ция, (with: currentAnswers) - массив с ответами, который создается выше, currentAnswers содержит ответы для каждого вопроса
        case .multiple: showMultipleStack(with: currentAnswers)
        case .ranged: showRangedStack(with: currentAnswers)
        }
    }
    
    private func showSingleStack(with answers: [Answer]) { // для первого вопроса - ответы в тексте кнопок
        singleStackView.isHidden = false // отображение стека
        
        for (button, answer) in zip(singleButtons, answers) { // button, answer - константы каждого элемента массива перебарем кортеж с массивами через zip
            button.setTitle(answer.title, for: .normal) // для каждой кнопки присваиваем заголовок каждого ответа
            
        }
    }
    // св-ва в кортеже и массивы в кортеже (button, answer) in zip(singleButtons, answers)
    // ф-ция zip создает последовательность пар построенную из двух передаваемых в нее последовательность
    
    
    // метод второго вопроса
    private func showMultipleStack(with answers: [Answer]) {
        multipleStackView.isHidden = false //отображение второго вопроса
        
        for (label, answer) in zip(multipleLabels, answers) { // отображения ответов в лейбле
            label.text = answer.title // присвоение значения лейблов (только отображение), после чего вызывается в кейсе для вопроса
        }
    }
    
    private func showRangedStack(with answers: [Answer]) { // отображение последнего ответа
        rangedStackView.isHidden = false
        
        rangedLabels.first?.text = answers.first?.title // обращение к первому элементу массива rangedLabels и помещаем туда answers.first?.title
        rangedLabels.last?.text = answers.last?.title // последний элемент, тк всего два элемента
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // передача данных в RVC
        if segue.identifier == "showResult" {
            let resultsViewController = segue.destination as! ResultViewController
            resultsViewController.responses = answersChosen
        }
    }
    
}

