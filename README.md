# Swift Static Map

[![Build](https://github.com/fwcd/swift-static-map/actions/workflows/build.yml/badge.svg)](https://github.com/fwcd/swift-static-map/actions/workflows/build.yml)
[![Docs](https://github.com/fwcd/swift-static-map/actions/workflows/docs.yml/badge.svg)](https://fwcd.github.io/swift-static-map/documentation/staticmap)

A small library for generating static maps directly from [OpenStreetMap](https://www.openstreetmap.org) tiles.

The implementation is based on a port of [danielalvsaaker](https://github.com/danielalvsaaker)'s [`staticmap`](https://github.com/danielalvsaaker/staticmap) library for Rust.

## Examples

### Simple Map

```swift
StaticMap(center: .init(latitude: 51.5, longitude: 0))
```

![Simple Map](Images/SimpleMap.png)
