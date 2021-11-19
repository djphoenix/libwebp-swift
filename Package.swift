// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "WebP",
  products: [
    .library(name: "WebP", targets: ["WebP"]),
  ],
  targets: [
    .target(
      name: "libwebp",
      path: "Sources/libwebp/src",
      exclude: [
        "libwebp.pc.in",
        "libwebp.rc",
        "libwebpdecoder.pc.in",
        "libwebpdecoder.rc",
        "Makefile.am",

        "dec/Makefile.am",
        "demux/libwebpdemux.pc.in",
        "demux/libwebpdemux.rc",
        "demux/Makefile.am",
        "dsp/Makefile.am",
        "enc/Makefile.am",
        "mux/libwebpmux.pc.in",
        "mux/libwebpmux.rc",
        "mux/Makefile.am",
        "utils/Makefile.am",
      ],
      publicHeadersPath: "webp",
      cSettings: [
        .headerSearchPath(".."),
        .headerSearchPath("."),
      ]
    ),
    .target(name: "WebP", dependencies: ["libwebp"]),
    .testTarget(name: "WebPTests", dependencies: ["WebP"]),
  ]
)

