import libwebp
import Foundation
import CoreGraphics

@inlinable public func CGImageCreateWithWebPData(_ data: Data) -> CGImage? {
  data.withUnsafeBytes({ (ptr: UnsafeRawBufferPointer) -> CGImage? in
    let bytes = ptr.baseAddress!.assumingMemoryBound(to: UInt8.self)
    var features = WebPBitstreamFeatures()
    guard WebPGetFeatures(bytes, ptr.count, &features) == VP8_STATUS_OK else { return nil }
    guard let bgra = WebPDecodeBGRA(bytes, ptr.count, &features.width, &features.height) else { return nil }
    guard let dataProvider = CGDataProvider.init(dataInfo: nil, data: bgra, size: Int(features.width * 4 * features.height), releaseData: { (info, ptr, flag) in WebPFree(UnsafeMutableRawPointer(mutating: ptr)) }) else {
      WebPFree(bgra)
      return nil
    }
    return CGImage(
      width: Int(features.width),
      height: Int(features.height),
      bitsPerComponent: 8,
      bitsPerPixel: 32,
      bytesPerRow: Int(features.width * 4),
      space: CGColorSpaceCreateDeviceRGB(),
      bitmapInfo: CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.first.rawValue),
      provider: dataProvider,
      decode: nil,
      shouldInterpolate: true,
      intent: CGColorRenderingIntent.defaultIntent
    )
  })
}

#if canImport(UIKit)
import class UIKit.UIImage
extension UIImage {
  @inlinable public convenience init?(webp data: Data) {
    guard let cg = CGImageCreateWithWebPData(data) else { return nil }
    self.init(cgImage: cg)
  }
}
#endif

#if canImport(Cocoa)
import class Cocoa.NSImage
extension NSImage {
  @inlinable public convenience init?(webp data: Data) {
    guard let cg = CGImageCreateWithWebPData(data) else { return nil }
    self.init(cgImage: cg, size: NSSize(width: cg.width, height: cg.height))
  }
}
#endif
