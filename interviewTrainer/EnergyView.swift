//
//  EnergyView.swift
//  interviewTrainer
//
//  Created by Moonsik Kong on 6/13/26.
//

import SwiftUI
import UIKit

struct EnergyView: View {
    private let imageURLs = EnergyImageLoader.loadImageURLs()

    var body: some View {
        Group {
            if imageURLs.isEmpty {
                ContentUnavailableView(
                    "No Energy Images",
                    systemImage: "photo",
                    description: Text("Add photos to the EnergyImages folder.")
                )
            } else {
                GeometryReader { proxy in
                    TabView {
                        ForEach(imageURLs, id: \.self) { url in
                            if let image = UIImage(contentsOfFile: url.path) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(
                                        width: proxy.size.width,
                                        height: proxy.size.height
                                    )
                                    .padding()
                            } else {
                                ContentUnavailableView(
                                    "Image Could Not Load",
                                    systemImage: "exclamationmark.triangle",
                                    description: Text(url.lastPathComponent)
                                )
                            }
                        }
                    }
                    .tabViewStyle(.page)
                }
            }
        }
        .navigationTitle("Energy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private enum EnergyImageLoader {
    private static let folderName = "EnergyImages"
    private static let supportedExtensions = ["HEIC", "heic", "JPG", "jpg", "JPEG", "jpeg", "PNG", "png"]

    static func loadImageURLs(bundle: Bundle = .main) -> [URL] {
        let urls = supportedExtensions.flatMap { fileExtension in
            bundle.urls(forResourcesWithExtension: fileExtension, subdirectory: folderName) ?? []
        }

        return urls.sorted {
            $0.lastPathComponent.localizedStandardCompare($1.lastPathComponent) == .orderedAscending
        }
    }
}

#Preview {
    NavigationStack {
        EnergyView()
    }
}
