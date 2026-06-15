//
//  AppStyle.swift
//  interviewTrainer
//
//  Created by Codex on 6/15/26.
//

import SwiftUI

enum AppFeatureFlags {
    static let isEasterEggEnabled = true
}

enum AppStyle {
    static let screenPadding: CGFloat = 20
    static let sectionSpacing: CGFloat = 20
    static let cardSpacing: CGFloat = 12
    static let cardCornerRadius: CGFloat = 16
    static let rowCornerRadius: CGFloat = 12

    static var screenBackground: Color {
        Color(.systemGroupedBackground)
    }

    static var rowBackground: Color {
        Color(.secondarySystemGroupedBackground)
    }

    static var subtleBorder: Color {
        Color(.separator).opacity(0.18)
    }
}

struct AppStatCard: View {
    let title: String
    let value: String
    let systemImage: String
    var color: Color = .blue

    var body: some View {
        VStack(alignment: .leading, spacing: AppStyle.cardSpacing) {
            Image(systemName: systemImage)
                .font(.title3)
                .foregroundStyle(color)

            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)

                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color(.separator).opacity(0.2), lineWidth: 1)
        }
    }
}

struct AppActionRow: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let color: Color
    var showsChevron = true

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(color.opacity(0.14))

                Image(systemName: systemImage)
                    .font(.headline)
                    .foregroundStyle(color)
            }
            .frame(width: 44, height: 44)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)

                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer()

            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.tertiary)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 56, alignment: .leading)
        .padding(12)
        .background(AppStyle.rowBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppStyle.rowCornerRadius, style: .continuous))
    }
}

extension View {
    func appCard() -> some View {
        self
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: AppStyle.cardCornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: AppStyle.cardCornerRadius, style: .continuous)
                    .stroke(AppStyle.subtleBorder, lineWidth: 1)
            }
    }
}
