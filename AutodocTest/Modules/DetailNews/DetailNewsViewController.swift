//
//  DetailNewsViewController.swift
//  AutodocTest
//
//  Created by Гарик on 13.02.2025.
//

import UIKit
import Combine

final class DetailNewsViewController: UIViewController {
    
    // MARK: - Private Properties

    /// Заголовок новости
    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = .zero
        return label
    }()
    
    /// Категория новости
    private let newsCategoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    /// Дата публикации новости
    private let newsDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .gray
        return label
    }()
    
    /// Описание новости
    private let newsDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = .zero
        return label
    }()
    
    /// Картинка новости
    private let newsImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    /// Кнопка для перехода на `WKWebView` для полного ознакомления со статьей
    private let readMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.readMoreButtonTitle, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(readMoreButtonTapped), for: .touchUpInside)
        return button
    }()
    
    /// `StackView` для заголовка, категории и даты новости
    private let labelStackView = UIStackView()
    
    /// Хранилище подписок
    private var subscriptions = Set<AnyCancellable>()
    
    /// Вью модель
    private let viewModel: DetailNewsViewModelProtocol
    
    // MARK: - Init

    init(viewModel: DetailNewsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        subscriptions.removeAll()
    }
    
    // MARK: - Public Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupConstraints()
        bind()
    }
    
    // MARK: - Private Methods
    
    /// Конфигурация вьюшек
    private func configureView() {
        title = Constants.title
        view.backgroundColor = .white
        
        labelStackView.addArrangedSubview(newsTitleLabel)
        labelStackView.addArrangedSubview(newsCategoryLabel)
        labelStackView.addArrangedSubview(newsDateLabel)

        labelStackView.axis = .vertical
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.spacing = 8
        
        view.addSubview(labelStackView)
        view.addSubview(newsImageView)
        view.addSubview(newsDescriptionLabel)
        view.addSubview(readMoreButton)
    }
    
    /// Установка констреинтов
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.inset),
            labelStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.inset),
            labelStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.inset),
            
            newsImageView.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: Constants.inset),
            newsImageView.centerXAnchor.constraint(equalTo: labelStackView.centerXAnchor),
            newsImageView.widthAnchor.constraint(equalToConstant: view.frame.width - Constants.inset * 2),
            newsImageView.heightAnchor.constraint(equalToConstant: view.frame.height / 4),
            
            newsDescriptionLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: Constants.inset),
            newsDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.inset),
            newsDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.inset),
            
            readMoreButton.topAnchor.constraint(equalTo: newsDescriptionLabel.bottomAnchor, constant: 5),
            readMoreButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.inset),
            readMoreButton.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    /// Привязка к обновлению данных
    /// Каждый раз при публикации нового значения во вью модели, мы обновляем вью
    private func bind() {
        viewModel.newsSubject
            .sink { [weak self] news in
                self?.setupValue(news: news)
            }
            .store(in: &subscriptions)
    }
    
    /// Установка значений
    /// - Parameters: Модель новости
    private func setupValue(news: NewsListCellModel) {
        newsTitleLabel.text = news.title
        newsDateLabel.text = Constants.publicationDateText + news.publishedDate
        newsDescriptionLabel.text = news.description
        newsCategoryLabel.text = Constants.categoryText + news.categoryType
        guard let data = news.imageData else {return}
        newsImageView.image = UIImage(data: data)
    }
    
    /// Обработка нажатия на кнопку `"Прочитать полностью..."`
    @objc
    private func readMoreButtonTapped() {
        viewModel.openNewsForWebView()
    }
}

// MARK: - Extension "Constants"

private extension DetailNewsViewController {
    enum Constants {
        static let inset = 15.0
        static let title = "Детальная информация"
        static let categoryText = "Категория: "
        static let publicationDateText = "Дата публикации: "
        static let readMoreButtonTitle = "Прочитать полностью..."
    }
}
