import UIKit

final class LegendsView: UIView {
//MARK: -IBOutlet
    @IBOutlet weak var tableV: UITableView!
    
//MARK: -Property
    private let tableViewCellId = "LegendsTableViewCell"
    private let headerCellId = "LegendsHeaderView"
    private var model:ScoreModel?
//MARK: -LifeCycle
    override init(frame: CGRect){
        super.init(frame: frame)
        loadNib()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }
//MARK: -Function
    internal func configure(model:ScoreModel){
        self.model = model
        tableV.reloadData()
    }
    private func loadNib(){
        let view = Bundle.main.loadNibNamed("LegendsView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        tableViewConfigure()
    }
    private func tableViewConfigure(){
        self.tableV.delegate = self
        self.tableV.dataSource = self
        self.tableV.register(UINib(nibName: tableViewCellId, bundle: nil), forCellReuseIdentifier: tableViewCellId)
        self.tableV.register(UINib(nibName: headerCellId, bundle: nil), forHeaderFooterViewReuseIdentifier: headerCellId)
        self.tableV.estimatedRowHeight = 1
        self.tableV.sectionHeaderHeight = 35
    }
}
//MARK: -UITableViewDelegate-DataSource
extension LegendsView:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let model = self.model?.legendsModelArray else{return 0}
        return model.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard
            let view = self.tableV.dequeueReusableHeaderFooterView(withIdentifier: headerCellId) as? LegendsHeaderView,
            let model = self.model?.legendsModelArray[section]
        else{
            return UIView()
        }
        view.configure(model: model)
        return view
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = self.model?.legendsModelArray[section].metadataDic else{return 0 }
        return model.count / 2
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = self.tableV.dequeueReusableCell(withIdentifier: tableViewCellId, for: indexPath) as? LegendsTableViewCell,
                let model = self.model?.legendsModelArray[indexPath.section]
        else{
            return UITableViewCell()
        }
        cell.configure(model: model, index: indexPath.row)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }
}

