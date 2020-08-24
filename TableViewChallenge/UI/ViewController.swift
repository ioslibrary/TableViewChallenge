
import UIKit

// This protocol is implemented when we get response from server
protocol APIResponseProtocol:class {
    func didReceiveResponse()
    func errorHandler(error: ProductAPIError)
}

class ViewController: UIViewController {

    // Cell Reuse Identifier
    private static let cellIdentifier = "cellId"
    // View Model
    private lazy var productVM = ProductViewModel()

    // Initilisation tableview with estamated height for cell
    private var tableView: UITableView = {
        let tableview = UITableView()
        tableview.isHidden = true
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.backgroundColor = .white
        tableview.estimatedRowHeight = 100
        tableview.rowHeight = UITableView.automaticDimension
        tableview.allowsSelection = false
        tableview.register(ProductCell.self, forCellReuseIdentifier: cellIdentifier)
        return tableview
    }()

    // MARK: View Controller Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Product POC"
        self.productVM.delegate = self
        self.setupUI()
    }

    // Add table view and it's Constraints to main view
    private func setupUI() {
        view.addSubview(tableView) // Adding tableview in controller view
        setTableLayout()
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        // Add Refresh Control to Table View
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        tableView.refreshControl?.tintColor = UIColor.appThemeColor
        // call the api to fetch all the products from server
        self.productVM.fetchProducts()
        IndicatorView.shared.showProgressView()
    }

    // Adding autolayout constraints on table View
    private func setTableLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    @objc private func refreshAction(_ sender: Any) {
        // call the api to fetch all the latest products from server
        self.productVM.fetchProducts()
    }
}

// MARK: Table View Data Source
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.cellIdentifier, for: indexPath) as? ProductCell else { return UITableViewCell() }
        let currentLastItem = self.productVM.product(at: indexPath.row)
        cell.product = currentLastItem
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productVM.numberOfProducts()
    }
}

// MARK: API response
extension ViewController: APIResponseProtocol {
    func errorHandler(error: ProductAPIError) {
        DispatchQueue.main.async {
            IndicatorView.shared.hideProgressView()
            self.tableView.refreshControl?.endRefreshing()
            UIAlertController.showAlertMessage(withTitle: "Error", withMessage: error.localizedDescription)
        }
    }

    func didReceiveResponse() {
        DispatchQueue.main.async {
            IndicatorView.shared.hideProgressView()
            self.navigationController?.navigationBar.topItem?.title = self.productVM.getTitle()
            self.tableView.isHidden = false
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}

