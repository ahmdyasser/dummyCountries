import SwiftUI

class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 100 // Maximum number of images to cache
    }
    
    func set(_ image: UIImage, for url: String) {
        cache.setObject(image, forKey: url as NSString)
    }
    
    func get(for url: String) -> UIImage? {
        cache.object(forKey: url as NSString)
    }
}

struct CachedAsyncImage: View {
    let url: String
    @State private var image: UIImage?
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                ProgressView()
                    .task {
                        await loadImage()
                    }
            }
        }
    }
    
    private func loadImage() async {
        // Check cache first
        if let cachedImage = ImageCache.shared.get(for: url) {
            image = cachedImage
            return
        }
        
        // Download if not cached
        guard let imageUrl = URL(string: url),
              let (data, _) = try? await URLSession.shared.data(from: imageUrl),
              let downloadedImage = UIImage(data: data) else {
            return
        }
        
        // Cache the downloaded image
        ImageCache.shared.set(downloadedImage, for: url)
        image = downloadedImage
    }
} 