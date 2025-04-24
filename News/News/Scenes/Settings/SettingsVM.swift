//
//  SettingsVM.swift
//  News
//
//  Created by Yunus Oktay on 24.04.2025.
//

import Foundation

protocol SettingsInputProtocol: AnyObject {
    func changeTheme(to index: Int)
    func toogleNotifications(isOn: Bool)
    func requestRateApp()
    func requestPrivacyPolicy()
    func requestTermsOfUse()
}

class SettingsVM {
    weak var inputDelegate: SettingsInputProtocol?
    weak var outputDelegate: SettingsOutputProtocol?

    private enum UserDefaultsKeys {
        static let themeIndex = "settingsThemeIndex"
        static let notificationEnabled = "settingsNotificationsEnabled"
    }

    init() {
        inputDelegate = self
    }

    private func registerDefaultSettings() {
        let defaults: [String: Any] = [
            UserDefaultsKeys.themeIndex: 0,
            UserDefaultsKeys.notificationEnabled: true
        ]
        UserDefaults.standard.register(defaults: defaults)
    }

    private var themeIndex: Int {
        UserDefaults.standard.integer(forKey: UserDefaultsKeys.themeIndex)
    }

    private var isNotificationsEnabled: Bool {
        UserDefaults.standard.bool(forKey: UserDefaultsKeys.notificationEnabled)
    }

    private var rateUsURL: URL? {
        URL(string: "itms-apps://itunes.apple.com/app/idYOUR_APP_ID?action=write-review")
    }

    private var privacyPolicyURL: URL? {
        URL(string: "https://www.yunusoktay.com")
    }

    private var termsOfUseURL: URL? {
        URL(string: "https://www.apple.com")
    }
}

// MARK: - SettingsInputProtocol

extension SettingsVM: SettingsInputProtocol {
    func changeTheme(to index: Int) {
        UserDefaults.standard.set(index, forKey: UserDefaultsKeys.themeIndex)
        outputDelegate?.applyThemeStyle(index: index)
    }

    func toogleNotifications(isOn: Bool) {
        UserDefaults.standard.set(isOn, forKey: UserDefaultsKeys.notificationEnabled)
    }

    func requestRateApp() {
        if let url = rateUsURL {
            outputDelegate?.openURL(url)
        }
    }

    func requestPrivacyPolicy() {
        if let url = privacyPolicyURL {
            outputDelegate?.openURL(url)
        }
    }

    func requestTermsOfUse() {
        if let url = termsOfUseURL {
            outputDelegate?.openURL(url)
        }
    }
}
