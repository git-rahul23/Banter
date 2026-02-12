//
//  ImageSaver.swift
//  Banter
//
//  Created by RAHUL RANA on 12/02/26.
//

import UIKit

final class ImageSaver {

    static let shared = ImageSaver()
    private init() {}

    private var imagesDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let dir = paths[0].appendingPathComponent("ChatImages", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }

    private var thumbnailsDirectory: URL {
        let dir = imagesDirectory.appendingPathComponent("Thumbnails", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }

    func saveImage(_ image: UIImage) async -> (path: String, fileSize: Int64, thumbnailPath: String?)? {
        let id = UUID().uuidString
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }

        let fileName = "\(id).jpg"
        let fileURL = imagesDirectory.appendingPathComponent(fileName)

        do {
            try data.write(to: fileURL)
            let fileSize = Int64(data.count)
            let thumbnailPath = await saveThumbnail(image, id: id)
            return (path: fileURL.path, fileSize: fileSize, thumbnailPath: thumbnailPath)
        } catch {
            return nil
        }
    }

    private func saveThumbnail(_ image: UIImage, id: String) async -> String? {
        let maxDimension: CGFloat = 200
        let scale = min(maxDimension / image.size.width, maxDimension / image.size.height, 1.0)
        let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)

        let renderer = UIGraphicsImageRenderer(size: newSize)
        let thumbnail = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }

        guard let data = thumbnail.jpegData(compressionQuality: 0.6) else { return nil }

        let fileName = "\(id)_thumb.jpg"
        let fileURL = thumbnailsDirectory.appendingPathComponent(fileName)

        do {
            try data.write(to: fileURL)
            return fileURL.path
        } catch {
            return nil
        }
    }
}
