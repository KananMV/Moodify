//
//  PillCustomSegmentControl.swift
//  Moodify
//
//  Created by Kenan Memmedov on 24.12.25.
//

import UIKit

final class PillSegmentedControl: UIControl {

    var items: [String] = [] { didSet { reload() } }
    private(set) var selectedIndex: Int = 0

    var onChange: ((Int) -> Void)?

    private let stack = UIStackView()
    private var buttons: [UIButton] = []
    private let indicator = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .clear
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.withAlphaComponent(0.12).cgColor
        layer.masksToBounds = true

        indicator.backgroundColor = .button
        indicator.isUserInteractionEnabled = false
        addSubview(indicator)

        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        layer.cornerCurve = .continuous

        layoutIndicator(animated: false)
    }

    private func reload() {
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()

        for (idx, title) in items.enumerated() {
            let b = UIButton(type: .system)
            b.tag = idx
            b.setTitle(title, for: .normal)
            b.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
            b.addTarget(self, action: #selector(tap(_:)), for: .touchUpInside)
            stack.addArrangedSubview(b)
            buttons.append(b)
        }

        updateButtonColors()
        setNeedsLayout()
        layoutIfNeeded()
    }

    func setSelectedIndex(_ index: Int, animated: Bool) {
        guard index >= 0, index < items.count else { return }
        selectedIndex = index
        updateButtonColors()
        layoutIndicator(animated: animated)
        onChange?(index)
        sendActions(for: .valueChanged)
    }

    @objc private func tap(_ sender: UIButton) {
        guard sender.tag != selectedIndex else { return }
        setSelectedIndex(sender.tag, animated: true)
    }

    private func updateButtonColors() {
        for (i, b) in buttons.enumerated() {
            if i == selectedIndex {
                b.setTitleColor(.white, for: .normal)
            } else {
                b.setTitleColor(UIColor.white.withAlphaComponent(0.75), for: .normal)
            }
        }
    }

    private func layoutIndicator(animated: Bool) {
        guard !buttons.isEmpty else { return }

        let innerFrame = stack.frame
        let w = innerFrame.width / CGFloat(buttons.count)
        let h = innerFrame.height

        let target = CGRect(
            x: innerFrame.minX + CGFloat(selectedIndex) * w,
            y: innerFrame.minY,
            width: w,
            height: h
        )

        let apply = {
            self.indicator.frame = target
            self.indicator.layer.cornerRadius = h / 2
            self.indicator.layer.cornerCurve = .continuous
            self.indicator.layer.masksToBounds = true
        }

        if animated {
            UIView.animate(withDuration: 0.22, delay: 0, options: [.curveEaseInOut]) { apply() }
        } else {
            apply()
        }
    }
}
