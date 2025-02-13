//
//  NewsListViewController.swift
//  AutodocTest
//
//  Created by Гарик on 10.02.2025.
//

import UIKit
import Combine

/// Контроллер со списком новостей
final class NewsListViewController: UIViewController {
    
    // MARK: - Private Properties
    
    /// Вью модель экрана
    private let viewModel: NewsListViewModelProtocol
    
    /// Сторейдж с подписками
    private var subscriptions = Set<AnyCancellable>()
    
    /// Вью коллекции
    private let collectionView: UICollectionView = {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(UIDevice.isIPad ? 0.5 : 1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(UIDevice.isIPad ? 0.3 : 0.4)
        )
        
        let group = UIDevice.isIPad ?
        NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item]) :
        NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        group.interItemSpacing = .fixed(UIDevice.isIPad ? 20 : 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
    }()
        
    /// Источник данных
    private var dataSource: UICollectionViewDiffableDataSource<Int, NewsListCellModel>?

    // MARK: - Public Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getData()
        configureView()
        setupConstraints()
        setupDataSource()
        bind()
    }
    
    // MARK: - Init

    init(viewModel: NewsListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        subscriptions.removeAll()
    }
    
    // MARK: - Private Methods

    /// Настройка вью
    private func configureView() {
        collectionView.delegate = self
        title = Constants.title
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.register(NewsListViewCell.self, forCellWithReuseIdentifier: NewsListViewCell.identifier)
    }

    /// Установка констреинтов
    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    /// Установка источника данных
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: NewsListViewCell.identifier,
                    for: indexPath
                ) as? NewsListViewCell
                cell?.setupData(model: itemIdentifier)
                return cell
            }
    }
    
    /// Обновление данных в коллекции
    /// - Parameters: Модель для обновления с новостями
    private func updateView(news: [NewsListCellModel]) {
        guard let dataSource else {return}
        var snapshot = dataSource.snapshot()
        if !snapshot.sectionIdentifiers.contains(0) {
                snapshot.appendSections([0])
        }
        snapshot.appendItems(news)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    /// Привязка к обновлению данных
    /// Каждый раз при публикации нового значения во вью модели, мы обновляем вью
    private func bind() {
        viewModel.itemsSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] news in
                self?.updateView(news: news)
            }
            .store(in: &subscriptions)
        
        viewModel.loadingStateSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loadingState in
                self?.handleLoadingState(loadingState)
            }
            .store(in: &subscriptions)
    }
    
    /// Обработчик состояния загрузки
    /// - Parameters: Состояние загрузки
    private func handleLoadingState(_ state: LoadingState) {
        switch state {
        case .isLoading:
            showActivity()
        case .loaded:
            removeActivity()
        case .error:
            removeActivity()
            showError()
        }
    }
    
    /// Показать алерт с ошибкой
    private func showError() {
        let alert = UIAlertController(title: "Что-то пошло не так", message: "Попробуйте еще раз", preferredStyle: .alert)
        let action = UIAlertAction(title: "Обновить", style: .default) { [weak self] _ in
            self?.viewModel.getData()
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    /// Показать активити индикатор
    private func showActivity() {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        activityIndicator.tag = 999
        view.addSubview(activityIndicator)
    }
    
    /// Удалить активити индикатор
    private func removeActivity() {
        view.viewWithTag(999)?.removeFromSuperview()
    }
    
}

// MARK: - Extension "Constants" 

private extension NewsListViewController {
    enum Constants {
        static let title = "Новостная лента"
    }
}

// MARK: - Extension UICollectionViewDelegate

extension NewsListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let news = dataSource?.itemIdentifier(for: indexPath) else {return}
        viewModel.openDetailNews(news: news)
    }
}


