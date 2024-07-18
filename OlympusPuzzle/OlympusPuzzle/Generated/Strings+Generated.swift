// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Onboarding {
    internal enum Title {
      /// Localizable.strings
      ///   OlympusPuzzle
      /// 
      ///   Created by Kirill Manuilenko on 18.07.24.
      internal static let first = L10n.tr("Localizable", "onboarding.title.first", fallback: "In the game Gates of Olympus: The Heavenly Devil, cast a fishing rod, when you bite, pick up the gems and take them out, watching the tension of the line. Avoid dangers!!")
      /// In the game Gates of Olympus: The Heavenly Devil, cast a fishing rod, when you bite, pick up the gems and take them out, watching the tension of the line. Avoid dangers!!
      internal static let second = L10n.tr("Localizable", "onboarding.title.second", fallback: "In the game Gates of Olympus: The Heavenly Devil, cast a fishing rod, when you bite, pick up the gems and take them out, watching the tension of the line. Avoid dangers!!")
      /// In the game Gates of Olympus: The Heavenly Devil, cast a fishing rod, when you bite, pick up the gems and take them out, watching the tension of the line. Avoid dangers!!
      internal static let third = L10n.tr("Localizable", "onboarding.title.third", fallback: "In the game Gates of Olympus: The Heavenly Devil, cast a fishing rod, when you bite, pick up the gems and take them out, watching the tension of the line. Avoid dangers!!")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
