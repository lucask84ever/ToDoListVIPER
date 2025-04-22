//
//  TaskTableViewCell.swift
//  ToDoListVIPER
//
//  Created by Lucas on 18/04/25.
//
import UIKit
import SnapKit
final class TaskTableViewCell: UITableViewCell {
    
    static let identifier = "TaskCell"
    var canBeSelected = true
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let createAtLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.text = "Created at: "
        return label
    }()
    
    private let completedAtLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.text = "Not completed yet"
        return label
    }()
    
    private let checkboxButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = .systemGray
        return button
    }()
    
    private let datesStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        return stack
    }()
    
    private let relativeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }()
    
    private var task: Task?
    var checkboxTapped: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupView()
        checkboxButton.addTarget(self, action: #selector(didTapCheckbox), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("Hahaha não.")
    }
    
    func configure(with task: Task, canBeSelected: Bool = true) {
        self.task = task
        self.canBeSelected = canBeSelected
        titleLabel.text = task.title
        createAtLabel.text = "Created at: \(relativeFormatter.localizedString(for: task.createdAt, relativeTo: Date()))"

        if let completedAt = task.completedAt {
            completedAtLabel.isHidden = false
            completedAtLabel.text = "Completed at: \(relativeFormatter.localizedString(for: completedAt, relativeTo: Date()))"
        } else {
            completedAtLabel.isHidden = true
        }

        let imageName = task.isDone ? "checkmark.circle.fill" : "circle"
        checkboxButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    @objc private func didTapCheckbox() {
        if canBeSelected {
            UIView.animate(withDuration: 0.3, animations: {
                self.cardView.alpha = 0.5
            }) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.checkboxTapped?()
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cardView.alpha = 1.0
    }
}

extension TaskTableViewCell: ViewCoding {
    func setupHierarchy() {
        contentView.addSubview(cardView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(checkboxButton)
        cardView.addSubview(datesStackView)
        datesStackView.addArrangedSubview(createAtLabel)
        datesStackView.addArrangedSubview(completedAtLabel)
    }
    
    func setupConstraints() {
        cardView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        checkboxButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.trailing.equalTo(checkboxButton.snp.leading).offset(-12)
            $0.top.equalToSuperview().inset(12)
        }
        
        datesStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.trailing.equalTo(checkboxButton.snp.leading).offset(-12)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.bottom.lessThanOrEqualToSuperview().inset(12)
        }
    }
    
    func setupAdditionalConfiguration() {
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .black

        createAtLabel.font = .systemFont(ofSize: 12)
        createAtLabel.textColor = .darkGray

        completedAtLabel.font = .systemFont(ofSize: 12)
        completedAtLabel.textColor = .gray
    }
}
