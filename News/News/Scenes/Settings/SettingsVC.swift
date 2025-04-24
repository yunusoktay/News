//
//  SettingsVC.swift
//  News
//
//  Created by Yunus Oktay on 19.02.2025.
//

import UIKit
import SnapKit

protocol SettingsOutputProtocol: AnyObject {
    func applyThemeStyle(index: Int)
    func openURL(_ url: URL)
}

class SettingsVC: UIViewController {

    // MARK: - Properties
    private let viewModel = SettingsVM()

    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "SETTINGS"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .label
        return label
    }()

    private let settingsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    // Theme Section
    private let themeView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 12
        return view
    }()

    private let themeIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle.lefthalf.filled")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let themeLabel: UILabel = {
        let label = UILabel()
        label.text = "App Theme"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()

    private lazy var themeSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Light", "Dark"])
        segmentedControl.selectedSegmentIndex = traitCollection.userInterfaceStyle == .dark ? 1 : 0
        segmentedControl.addTarget(self, action: #selector(themeChanged(_:)), for: .valueChanged)
        return segmentedControl
    }()

    // Notification Section
    private let notificationView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 12
        return view
    }()

    private let notificationIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "bell.fill")
        imageView.tintColor = .systemRed
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let notificationLabel: UILabel = {
        let label = UILabel()
        label.text = "Notifications"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()

    private lazy var notificationSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = true
        switchControl.addTarget(self, action: #selector(notificationSwitchChanged(_:)), for: .valueChanged)
        return switchControl
    }()

    // Rate Us Section
    private let rateView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 12
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        return view
    }()

    private let rateIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let rateLabel: UILabel = {
        let label = UILabel()
        label.text = "Rate Us"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()

    private let chevronImageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // Legal Section
    private let legalView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 12
        return view
    }()

    private let privacyView: UIView = {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        return view
    }()

    private let privacyIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "lock.fill")
        imageView.tintColor = .systemGreen
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let privacyLabel: UILabel = {
        let label = UILabel()
        label.text = "Privacy Policy"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()

    private let chevronImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()

    private let termsView: UIView = {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        return view
    }()

    private let termsIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "doc.text.fill")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let termsLabel: UILabel = {
        let label = UILabel()
        label.text = "Terms of Use"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()

    private let chevronImageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.outputDelegate = self
        viewModel.inputDelegate = viewModel
        setupUI()
        setupGestures()
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground

        // Add subviews
        view.addSubview(titleLabel)
        view.addSubview(settingsStackView)

        // Add sections to stack view
        settingsStackView.addArrangedSubview(themeView)
        settingsStackView.addArrangedSubview(notificationView)
        settingsStackView.addArrangedSubview(rateView)
        settingsStackView.addArrangedSubview(legalView)

        // Theme section
        themeView.addSubview(themeIconImageView)
        themeView.addSubview(themeLabel)
        themeView.addSubview(themeSegmentedControl)

        // Notification section
        notificationView.addSubview(notificationIconImageView)
        notificationView.addSubview(notificationLabel)
        notificationView.addSubview(notificationSwitch)

        // Rate section
        rateView.addSubview(rateIconImageView)
        rateView.addSubview(rateLabel)
        rateView.addSubview(chevronImageView1)

        // Legal section
        legalView.addSubview(privacyView)
        legalView.addSubview(separatorView)
        legalView.addSubview(termsView)

        privacyView.addSubview(privacyIconImageView)
        privacyView.addSubview(privacyLabel)
        privacyView.addSubview(chevronImageView2)

        termsView.addSubview(termsIconImageView)
        termsView.addSubview(termsLabel)
        termsView.addSubview(chevronImageView3)

        // Set constraints
        setupConstraints()
    }

    // swiftlint:disable function_body_length
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(16)
        }

        settingsStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

        // Theme section
        themeView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }

        themeIconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(24)
        }

        themeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(themeIconImageView.snp.trailing).offset(16)
        }

        themeSegmentedControl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(120)
        }

        // Notification section
        notificationView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }

        notificationIconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(24)
        }

        notificationLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(notificationIconImageView.snp.trailing).offset(16)
        }

        notificationSwitch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        }

        // Rate section
        rateView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }

        rateIconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(24)
        }

        rateLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(rateIconImageView.snp.trailing).offset(16)
        }

        chevronImageView1.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(8)
            make.height.equalTo(16)
        }

        // Legal section
        legalView.snp.makeConstraints { make in
            make.height.equalTo(112) // Two rows
        }

        privacyView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(56)
        }

        separatorView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(56)
            make.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.centerY.equalToSuperview()
        }

        termsView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(56)
        }

        privacyIconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(24)
        }

        privacyLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(privacyIconImageView.snp.trailing).offset(16)
        }

        chevronImageView2.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(8)
            make.height.equalTo(16)
        }

        termsIconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(24)
        }

        termsLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(termsIconImageView.snp.trailing).offset(16)
        }

        chevronImageView3.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(8)
            make.height.equalTo(16)
        }
    }
    // swiftlint:disable function_body_length

    private func setupGestures() {
        let rateTapGesture = UITapGestureRecognizer(target: self, action: #selector(rateUsTapped))
        rateView.addGestureRecognizer(rateTapGesture)

        let privacyTapGesture = UITapGestureRecognizer(target: self, action: #selector(privacyPolicyTapped))
        privacyView.addGestureRecognizer(privacyTapGesture)

        let termsTapGesture = UITapGestureRecognizer(target: self, action: #selector(termsOfUseTapped))
        termsView.addGestureRecognizer(termsTapGesture)
    }

    // MARK: - Actions
    @objc private func themeChanged(_ sender: UISegmentedControl) {
        viewModel.inputDelegate?.changeTheme(to: sender.selectedSegmentIndex)
    }

    @objc private func notificationSwitchChanged(_ sender: UISwitch) {
        viewModel.inputDelegate?.toogleNotifications(isOn: sender.isOn)
    }

    @objc private func rateUsTapped() {
        viewModel.inputDelegate?.requestRateApp()
    }

    @objc private func privacyPolicyTapped() {
        viewModel.inputDelegate?.requestPrivacyPolicy()
    }

    @objc private func termsOfUseTapped() {
        viewModel.inputDelegate?.requestTermsOfUse()
    }
}

extension SettingsVC: SettingsOutputProtocol {
    func applyThemeStyle(index: Int) {
        let style: UIUserInterfaceStyle = (index == 0) ? .light : .dark
        guard let windowScene = view.window?.windowScene else { return }
        windowScene.windows.forEach { window in
            window.overrideUserInterfaceStyle = style
        }
    }

    func openURL(_ url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
