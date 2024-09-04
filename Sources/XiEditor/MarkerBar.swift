// Copyright 2018 The xi-editor Authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Cocoa

class Marker {
    let line: Int
    let color: NSColor

    init(_ line: Int, color: NSColor) {
        self.line = line
        self.color = color
    }
}

class MarkerBar: NSScroller {
    var markers: [Marker] = []
    var backgroundColor: NSColor = NSColor.red
    let markerLayer = CAShapeLayer()
    var overlayScrollerLayer: CALayer?
    weak var markerDelegate: MarkerDelegate?

    override func viewWillDraw() {
        super.viewWillDraw()

        if (overlayScrollerLayer == nil) {
            overlayScrollerLayer = self.layer!.sublayers!.last
            overlayScrollerLayer?.addObserver(self, forKeyPath: "opacity", options: .new, context: nil)
            self.layer!.addSublayer(markerLayer)
        }
    }

    deinit {
        overlayScrollerLayer?.removeObserver(self, forKeyPath: "opacity")
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "opacity" {
            markerLayer.opacity = change![NSKeyValueChangeKey.newKey] as! Float
        }
    }

    static let markerHeight: CGFloat = 1.0

    override class var isCompatibleWithOverlayScrollers: Bool {
        return true
    }

    override func drawKnob() {
        drawMarkers()
        super.drawKnob()
    }

    func setMarker(_ items: [Marker]) {
        markers = items
        drawMarkers()
    }

    private func drawMarkers() {
        guard let markerBarHeight = layer?.bounds.height,
            let maxScrollerWidth = layer?.bounds.width,
            let totalLines = (markerDelegate as? EditViewController)?.lines.height,
            let width = overlayScrollerLayer?.bounds.width else { return; }

        let path = CGMutablePath()

        for marker in markers {
            markerLayer.fillColor = marker.color.cgColor

            let x = maxScrollerWidth - width
            let y = ((CGFloat(marker.line) - 0.5) / CGFloat(totalLines)) * markerBarHeight

            path.addRect(CGRect(x: x, y: y, width: width, height: MarkerBar.markerHeight))
            path.closeSubpath()
        }

        markerLayer.path = path
    }
}
