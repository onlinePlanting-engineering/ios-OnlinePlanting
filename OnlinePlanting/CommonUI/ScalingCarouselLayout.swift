
import UIKit

open class ScalingCarouselLayout: UICollectionViewFlowLayout {

    open var inset: CGFloat = 0.0
    
    func getCopyOfAttributes(_ attributes: NSArray?) -> NSArray {
        let copyArr = NSMutableArray()
        guard let attrs = attributes else { return copyArr }
        for attribute in attrs {
            if attribute is UICollectionViewLayoutAttributes {
                copyArr.add(attribute)
            }
        }
        return copyArr
    }
    

    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let arrays = getCopyOfAttributes(super.layoutAttributesForElements(in: rect) as NSArray?)
        if let width = collectionView?.bounds.size.width, let xOffset = collectionView?.contentOffset.x {
           let centerX = xOffset + width / 2.0
            for attribute in arrays {
                if attribute is UICollectionViewLayoutAttributes {
                    if let layoutAttribute = attribute as? UICollectionViewLayoutAttributes {
                    let distance = fabs(layoutAttribute.center.x - centerX)
                    let apartScale = Double(distance / width)
                    let scale = fabs(cos(apartScale * .pi/4))
                    layoutAttribute.transform = CGAffineTransform(scaleX: 1.0, y: CGFloat.init(scale))
                    }
                }
            }
        }
        return arrays as? [UICollectionViewLayoutAttributes]
    }
    
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

}
