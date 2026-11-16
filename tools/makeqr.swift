// Uso: swift tools/makeqr.swift <url> <output-base>   -> <base>.png (1200px) + <base>.svg
import Foundation
import CoreImage
import AppKit

let args = CommandLine.arguments
guard args.count == 3 else { print("uso: makeqr.swift <url> <output-base>"); exit(1) }
let url = args[1], base = args[2]

let f = CIFilter(name: "CIQRCodeGenerator")!
f.setValue(url.data(using: .utf8), forKey: "inputMessage")
f.setValue("M", forKey: "inputCorrectionLevel")
let img = f.outputImage!            // 1px per modulo, include quiet zone di 1 modulo
let ctx = CIContext()
let cg = ctx.createCGImage(img, from: img.extent)!
let n = cg.width
let rep = NSBitmapImageRep(cgImage: cg)

// leggi la matrice
var dark = [[Bool]](repeating: [Bool](repeating: false, count: n), count: n)
for y in 0..<n { for x in 0..<n {
    let c = rep.colorAt(x: x, y: y)!.usingColorSpace(.deviceGray)!
    dark[y][x] = c.whiteComponent < 0.5
}}

// SVG con quiet zone di 4 moduli
let q = 4, size = n + 2*q
var path = ""
for y in 0..<n { for x in 0..<n where dark[y][x] { path += "M\(x+q) \(y+q)h1v1h-1z" } }
let svg = """
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 \(size) \(size)" shape-rendering="crispEdges">
<rect width="\(size)" height="\(size)" fill="#fff"/><path fill="#000" d="\(path)"/></svg>
"""
try! svg.write(toFile: base + ".svg", atomically: true, encoding: .utf8)

// PNG ~1200px, moduli interi
let scale = max(1, 1200 / size), px = size * scale
let out = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: px, pixelsHigh: px, bitsPerSample: 8,
    samplesPerPixel: 1, hasAlpha: false, isPlanar: false, colorSpaceName: .deviceWhite, bytesPerRow: px, bitsPerPixel: 8)!
let p = out.bitmapData!
for i in 0..<(px*px) { p[i] = 255 }
for y in 0..<n { for x in 0..<n where dark[y][x] {
    for dy in 0..<scale { for dx in 0..<scale { p[((y+q)*scale+dy)*px + (x+q)*scale+dx] = 0 } }
}}
try! out.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: base + ".png"))
print("ok \(n-2)x\(n-2) moduli -> \(base).png (\(px)px), \(base).svg")
