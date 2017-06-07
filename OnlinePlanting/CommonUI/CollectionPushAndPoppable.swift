
import Foundation
import UIKit

protocol CollectionPushAndPoppable {
    var sourceCell: UICollectionViewCell? { get }
    var collectionView: UICollectionView? { get }
    var view: UIView! { get }
}

protocol TablePushAndPoppable {
    var sourceCell: UITableViewCell? { get }
    var view: UIView! { get }
}
