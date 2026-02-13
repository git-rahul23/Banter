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

    func downloadAndSaveImage(from url: URL) async -> (path: String, fileSize: Int64, thumbnailPath: String?)? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            return await saveImage(image)
        } catch {
            return nil
        }
    }

    func saveImage(_ image: UIImage) async -> (path: String, fileSize: Int64, thumbnailPath: String?)? {
        let id = UUID().uuidString
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }

        let fileName = "\(id).jpg"
        let fileURL = imagesDirectory.appendingPathComponent(fileName)

        do {
            try data.write(to: fileURL)
            let fileSize = Int64(data.count)
            let thumbnailRelPath = await saveThumbnail(image, id: id)
            return (path: "ChatImages/\(fileName)", fileSize: fileSize, thumbnailPath: thumbnailRelPath)
        } catch {
            return nil
        }
    }

    static func resolvedPath(_ path: String) -> String {
        if path.hasPrefix("/") {
            if FileManager.default.fileExists(atPath: path) {
                return path
            }
            // Migrate old absolute path — extract relative portion after Documents/
            if let range = path.range(of: "Documents/") {
                let relativePath = String(path[range.upperBound...])
                let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                return docs.appendingPathComponent(relativePath).path
            }
            return path
        }
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docs.appendingPathComponent(path).path
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
            return "ChatImages/Thumbnails/\(fileName)"
        } catch {
            return nil
        }
    }
}
