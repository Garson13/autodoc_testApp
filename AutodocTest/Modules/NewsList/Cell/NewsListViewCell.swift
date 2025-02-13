//
//  NewsListViewCell.swift
//  AutodocTest
//
//  Created by Гарик on 10.02.2025.
//

import UIKit

/// Ячейка для отображения списка новстей (Новостная лента)
final class NewsListViewCell: UICollectionViewCell {
    
    // MARK: - Public Properties

    /// Идентификатор ячейки
    static let identifier = "NewsListCell"
    
    // MARK: - Private Properties
    
    /// Вью с картинкой статьи
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    /// Заголовок статьи
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    /// Дата публикации статьи
    private let postDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12, weight: .light)
        return label
    }()
    
    /// Контейнер для всех вьюшек
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Public Methods
    
    /// Подготовка ячейки для переиспользования
    override func prepareForReuse() {
        titleLabel.text = nil
        postDateLabel.text = nil
        postImageView.image = nil
    }
    
    // MARK: - Private Methods
    
    /// Настройка вьюшек
    private func configureView() {
        let views = [
            postImageView,
            titleLabel,
            postDateLabel
        ]
        
        views.forEach {
            containerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        contentView.addSubview(containerView)
        
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true
        
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowRadius = 6
        contentView.layer.shadowOffset = CGSize(width: 1, height: 1)

    }

    /// Установка констреинтов
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            
            postImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            postImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            postImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.7),
            
            titleLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            
            postDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            postDateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            postDateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)
        ])
    }
    
    /// Установки данных в элементы ячейки
    ///  - Parameters:
    ///   - model: Готовая модель данных для отображения
    func setupData(model: NewsListCellModel) {
        postImageView.image = UIImage(data: model.imageData ?? Data())
        postDateLabel.text = Constants.datePublicationText + model.publishedDate
        titleLabel.text = model.title
    }
}

// MARK: - Extension "Constants"

private extension NewsListViewCell {
    enum Constants {
        static let datePublicationText = "Дата публикации: "
    }
}
