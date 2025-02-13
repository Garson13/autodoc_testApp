//
//  WebViewController.swift
//  AutodocTest
//
//  Created by Гарик on 13.02.2025.
//

import UIKit
import WebKit

/// Контроллер с `WKWebView` вместо стандратного `view`
/// Объект является базовым и можно его переиспользовать в другой части или наследоваться, добавляя попутно функционал
class WebViewController: UIViewController {
    
    // MARK: - Private Properties

    /// Сам `WebView`
    private let webView = WKWebView()

    /// Ссылка, на которую нужно перейти в веб вью
    /// Передайте в инициализаторе
    private let url: URL
    
    /// Тайтл экрана, опциональный, так как может его не быть
    private let newsTitle: String?
    
    // MARK: - Init

    init(url: URL, newsTitle: String?) {
        self.url = url
        self.newsTitle = newsTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods

    override func loadView() {
        super.loadView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = newsTitle
        openURL()
    }
    
    // MARK: - Private Methods

    /// Открыть `URL` в `WKWebView`
    private func openURL() {
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
}
