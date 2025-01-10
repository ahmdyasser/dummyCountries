import Testing
import UIKit.UIImage
@testable import dummyCountries

struct ImageCacheTests {
    @Test
    func imageCaching() async throws {
        // Given
        let cache = ImageCache.shared
        let testImage = UIImage()
        let testUrl = "https://test.com/image.png"
        
        // When
        cache.set(testImage, for: testUrl)
        let cachedImage = cache.get(for: testUrl)
        
        // Then
        #expect(cachedImage != nil)
    }
    
    @Test
    func nonExistentImageReturnsNil() async throws {
        // Given
        let cache = ImageCache.shared
        let nonExistentUrl = "https://test.com/nonexistent.png"
        
        // When
        let cachedImage = cache.get(for: nonExistentUrl)
        
        // Then
        #expect(cachedImage == nil)
    }
} 
