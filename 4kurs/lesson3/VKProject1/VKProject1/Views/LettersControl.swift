//
//  LettersControl.swift
//  VKProject1
//
//  Created by xc553a8 on 31.08.2021.
//

import UIKit

final class LettersControl: UIControl {

    var selectLetter: String? = nil {
        didSet {
            self.sendActions(for: .valueChanged)
        }
    }

    private var letters = [String]() {
        didSet {
            setupViews()
        }
    }

    private var buttons = [UIButton]()
    private var stackView: UIStackView!

    override func layoutSubviews() {
        super.layoutSubviews()
        setupUIView()
    }

    /// Установка букв для кнопок контрола
    func setLetters(_ letters: [String]) {
        self.letters = letters
    }
    
    // Настройка кнопок для UIStackView
    private func setupViews() {
        for letter in letters {
            let button = UIButton(type: .system)
            button.backgroundColor = .clear
            button.setTitle(letter, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.addTarget(self, action: #selector(selectedLetter(_:)), for: .touchUpInside)
            self.buttons.append(button)
        }
        stackView = UIStackView(arrangedSubviews: self.buttons)
        addSubview(stackView)
        stackView.spacing = 0
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.layer.cornerRadius = 7
    }

    // Выбранная кнопка сообщает свой индекс
    @objc private func selectedLetter(_ sender: UIButton) {
        guard let index = self.buttons.firstIndex(of: sender) else {
            return
        }
        self.selectLetter = letters[index]
    }
    
    // Установка внешнего вида контрола
   private func setupUIView() {
        stackView.frame = bounds
        stackView.layer.borderWidth = 1
        stackView.layer.backgroundColor = UIColor.white.cgColor
        stackView.alpha = 0.4
    }
}
