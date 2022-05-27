//
//  JGProgressHUD+.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/28.
//

import JGProgressHUD

enum HUDType {
    case success(String)

    case failure(String)
}

class LKProgressHUD {
    static let shared = LKProgressHUD()

    private init() {}

    let hud = JGProgressHUD(style: .dark)

    var view: UIView {
        guard let view = UIApplication.shared.windows.last?.rootViewController?.view else { return UIView() }
        return view
    }

    static func show(type: HUDType) {
        switch type {
        case let .success(text):

            showSuccess(text: text)

        case let .failure(text):

            showFailure(text: text)
        }
    }

    static func showSuccess(text: String = "success") {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                showSuccess(text: text)
            }
            return
        }

        shared.hud.textLabel.text = text

        shared.hud.indicatorView = JGProgressHUDSuccessIndicatorView()

        shared.hud.show(in: shared.view)

        shared.hud.dismiss(afterDelay: 1.5)
    }

    static func showFailure(text: String = "Failure") {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                showFailure(text: text)
            }

            return
        }

        shared.hud.textLabel.text = text

        shared.hud.indicatorView = JGProgressHUDErrorIndicatorView()

        shared.hud.show(in: shared.view)

        shared.hud.dismiss(afterDelay: 1.5)
    }

    static func show(text: String = "Loading") {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                show()
            }
            return
        }

        shared.hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()

        shared.hud.textLabel.text = text

        shared.hud.show(in: shared.view)
    }

    static func dismiss() {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                dismiss()
            }
            return
        }
        shared.hud.dismiss()
    }
}
