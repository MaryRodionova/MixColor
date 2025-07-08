import UIKit

final class ViewController: UIViewController {

    private var activeButton: UIButton?

    private let label: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(30)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "Mix Colors"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let verticalStackView1: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let verticalStackView2: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let verticalStackView3: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let label1: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(20)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "Blue"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let button1: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Выбрать цвет", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(
            self,
            action: #selector(openColorPicker1),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let labelPlus: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(30)
        label.textAlignment = .center
        label.text = "+"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let label2: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(20)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "Red"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let button2: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Выбрать цвет", for: .normal)
        button.backgroundColor = .red
        button.addTarget(
            self,
            action: #selector(openColorPicker2),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let label3: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(20)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "Purple"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let button3: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .purple
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let languageSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["РУ", "ENG"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()

    private let buttonResult: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("=", for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(30)
        button.addTarget(self, action: #selector(resultColor), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
 
        setupUI()
        addSubviews()
        setupConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        languageSegmentedControl.addTarget(self, action: #selector(languageChanged), for: .valueChanged)
    }
}

// MARK: - UIColorPickerViewControllerDelegate

extension ViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ vc: UIColorPickerViewController) {
        let selectedColor = vc.selectedColor
        if activeButton == button1 {
            button1.backgroundColor = selectedColor
            updateLabel(label1, for: selectedColor)
        } else if activeButton == button2 {
            button2.backgroundColor = selectedColor
            updateLabel(label2, for: selectedColor)
        }
    }

    @objc
    private func openColorPicker1() {
        activeButton = button1
        let picker = UIColorPickerViewController()
        picker.delegate = self
        picker.selectedColor = button1.backgroundColor ?? .blue
        present(picker, animated: true)
    }

    @objc
    private func openColorPicker2() {
        activeButton = button2
        let picker = UIColorPickerViewController()
        picker.delegate = self
        picker.selectedColor = button2.backgroundColor ?? .red
        present(picker, animated: true)
    }

    @objc
    private func resultColor() {
        let color1 = button1.backgroundColor ?? .white
        let color2 = button2.backgroundColor ?? .white
        let mixed = mixColors(color1, color2)
        button3.backgroundColor = mixed
        updateLabel(label3, for: mixed)
    }

    @objc
    private func languageChanged() {
        updateLabel(label1, for: button1.backgroundColor ?? .blue)
        updateLabel(label2, for: button2.backgroundColor ?? .red)
        updateLabel(label3, for: button3.backgroundColor ?? .purple)
    }
    
    private func updateLabel(_ label: UILabel, for color: UIColor) {
        let isRussian = languageSegmentedControl.selectedSegmentIndex == 0
        label.text = colorName(for: color, russian: isRussian)
    }
    
    private func mixColors(_ color1: UIColor, _ color2: UIColor) -> UIColor {
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        return UIColor(red: (r1+r2)/2, green: (g1+g2)/2, blue: (b1+b2)/2, alpha: (a1+a2)/2)
    }
    
    private func colorName(for color: UIColor, russian: Bool) -> String {
        var hue: CGFloat = 0, sat: CGFloat = 0, bri: CGFloat = 0, alpha: CGFloat = 0
        guard color.getHue(&hue, saturation: &sat, brightness: &bri, alpha: &alpha) else {
            return russian ? "Цвет" : "Color"
        }

        let namedColors: [(h: CGFloat, s: CGFloat, b: CGFloat, en: String, ru: String)] = [
            // Стандартные + пастельные и приглушённые
            (0.0, 1.0, 1.0, "Red", "Красный"),
            (0.0, 0.4, 0.7, "Muted Red", "Приглушённый красный"),
            (0.03, 0.3, 1.0, "Pastel Orange", "Пастельно-оранжевый"),
            (0.08, 1.0, 1.0, "Orange", "Оранжевый"),
            (0.1, 0.2, 1.0, "Cream", "Кремовый"),
            (0.15, 1.0, 1.0, "Yellow", "Жёлтый"),
            (0.2, 0.4, 0.7, "Olive", "Оливковый"),
            (0.25, 0.6, 1.0, "Lime", "Лаймовый"),
            (0.3, 1.0, 1.0, "Green", "Зелёный"),
            (0.3, 0.3, 0.9, "Muted Green", "Приглушённый зелёный"),
            (0.42, 0.3, 1.0, "Teal", "Бирюзовый"),
            (0.5, 1.0, 1.0, "Cyan", "Голубой"),
            (0.55, 0.4, 1.0, "Pastel Cyan", "Пастельно-голубой"),
            (0.6, 1.0, 1.0, "Blue", "Синий"),
            (0.67, 0.7, 0.7, "Indigo", "Индиго"),
            (0.72, 0.5, 1.0, "Amethyst", "Аметистовый"),
            (0.78, 0.6, 1.0, "Purple", "Фиолетовый"),
            (0.82, 0.4, 0.85, "Lilac", "Сиреневый"),
            (0.9, 0.4, 1.0, "Pink", "Розовый"),
            (0.9, 0.2, 1.0, "Pastel Pink", "Пастельно-розовый"),
            (0.0, 0.0, 1.0, "White", "Белый"),
            (0.0, 0.0, 0.5, "Gray", "Серый"),
            (0.0, 0.0, 0.2, "Dark Gray", "Тёмно-серый"),
            (0.0, 0.0, 0.0, "Black", "Чёрный")
        ]

        var closestName = russian ? "Цвет" : "Color"
        var minDistance: CGFloat = .greatestFiniteMagnitude

        for named in namedColors {
            let dh = hue - named.h
            let ds = sat - named.s
            let db = bri - named.b
            let distance = sqrt(dh*dh + ds*ds + db*db)

            if distance < minDistance {
                minDistance = distance
                closestName = russian ? named.ru : named.en
            }
        }

        // Если в списке уже есть уточнение — не добавляем префикс
        let lowercaseName = closestName.lowercased()
        if lowercaseName.contains("пастел") || lowercaseName.contains("pastel") ||
            lowercaseName.contains("приглуш") || lowercaseName.contains("muted") {
            return closestName
        }

        // Добавим дополнительные префиксы по яркости/насыщенности
        var prefix = ""
        if bri > 0.85 && sat > 0.25 {
            prefix = russian ? "Светло-" : "Light "
        } else if bri < 0.35 && sat > 0.25 {
            prefix = russian ? "Тёмно-" : "Dark "
        } else if sat < 0.25 && bri > 0.6 {
            prefix = russian ? "Бледно-" : "Pale "
        }

        return prefix + closestName
    }
}


// MARK: - Setup Constraints

private extension ViewController {
    func addSubviews() {
        view.addSubview(label)
        view.addSubview(verticalStackView1)
        view.addSubview(labelPlus)
        view.addSubview(verticalStackView2)
        view.addSubview(buttonResult)
        view.addSubview(verticalStackView3)
        view.addSubview(languageSegmentedControl)
        
        verticalStackView1.addArrangedSubview(label1)
        verticalStackView1.addArrangedSubview(button1)
        
        verticalStackView2.addArrangedSubview(label2)
        verticalStackView2.addArrangedSubview(button2)
        
        verticalStackView3.addArrangedSubview(label3)
        verticalStackView3.addArrangedSubview(button3)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                verticalStackView1.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30),
                verticalStackView1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                verticalStackView1.widthAnchor.constraint(equalToConstant: 100),
                button1.heightAnchor.constraint(equalToConstant: 100),
                
                labelPlus.topAnchor.constraint(equalTo: verticalStackView1.bottomAnchor, constant: 10),
                labelPlus.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                verticalStackView2.topAnchor.constraint(equalTo: labelPlus.bottomAnchor, constant: 10),
                verticalStackView2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                verticalStackView2.widthAnchor.constraint(equalToConstant: 100),
                button2.heightAnchor.constraint(equalToConstant: 100),
                
                buttonResult.topAnchor.constraint(equalTo: verticalStackView2.bottomAnchor, constant: 15),
                buttonResult.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                buttonResult.heightAnchor.constraint(equalToConstant: 40),
                buttonResult.widthAnchor.constraint(equalToConstant: 40),
                
                verticalStackView3.topAnchor.constraint(equalTo: buttonResult.bottomAnchor, constant: 15),
                verticalStackView3.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                verticalStackView3.widthAnchor.constraint(equalToConstant: 100),
                button3.heightAnchor.constraint(equalToConstant: 100),
                
                languageSegmentedControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                languageSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                languageSegmentedControl.widthAnchor.constraint(equalToConstant: 100)
            ]
        )
    }
}
