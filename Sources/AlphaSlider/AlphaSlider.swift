#if canImport(UIKit)
import UIKit
import CoreImage

@available(iOS 10.0, *)
@IBDesignable open class AlphaSlider: UISlider {
    
    @IBInspectable var color : UIColor? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    private var background : UIImage?

    init(frame: CGRect, color: UIColor = .black) {
        super.init(frame: frame)
        setup(color)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup(.black)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup(.black)
    }
    
    private func setup(_ color: UIColor) {
        self.color = color
        self.maximumTrackTintColor = .clear
        self.minimumTrackTintColor = .clear
        self.tintColor = .clear
        
        self.maximumValue = 1.0
        self.minimumValue = 0.0
        
        let context = CIContext()
        let scale = UIScreen.main.scale
        let filter = CIFilter(name: "CICheckerboardGenerator", parameters: ["inputColor0" : CIColor.white, "inputColor1" : CIColor.gray, "inputCenter" : CIVector(x: 0, y: 0), "inputWidth" : 5*scale])
        
        guard let outputImage = filter?.outputImage else { return }
        guard let image = context.createCGImage(outputImage, from: CGRect(x: bounds.minX * scale, y: bounds.minY * scale, width: (bounds.width) * scale, height: bounds.height * scale)) else { return }
        
        background = UIImage(cgImage: image, scale: scale, orientation: .up)
        setNeedsDisplay()
    }
    
    open override func tintColorDidChange() {
        self.maximumTrackTintColor = .clear
        self.minimumTrackTintColor = .clear
        self.tintColor = .clear
    }
    
    open override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: CGRect(x: 5, y: 0, width: rect.width-10, height: rect.height), cornerRadius: rect.height/2)
        
        let context = UIGraphicsGetCurrentContext()!
        let colors = [color!.withAlphaComponent(0).cgColor, color!.cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        context.addPath(path.cgPath)
        context.clip()
        
        if let bg = background {
            bg.draw(at: .zero)
        }
        
        let colorLocations: [CGFloat] = [0.0, 1.0]
        let gradient = CGGradient(colorsSpace: colorSpace,
                                       colors: colors as CFArray,
                                    locations: colorLocations)!
        
        let startPoint = CGPoint(x: 5, y: 0)
        let endPoint = CGPoint(x: bounds.width-20, y: 0)
        context.drawLinearGradient(gradient,
                            start: startPoint,
                              end: endPoint,
                              options: [.drawsAfterEndLocation])
        
        context.setStrokeColor(UIColor.init(white: 0, alpha: 0.2).cgColor)
        path.lineWidth = 1
        path.stroke()
        
    }
}
#endif
