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

import AppKit.NSWindowController

final class XiWindowController: NSWindowController {
    let editedIndicator = "•"
    let debugIndicator = "[Debug]"
    
    override func windowTitle(forDocumentDisplayName displayName: String) -> String {
        var windowTitle = ""
        
        // If there is more than one tab AND the document in question has unsaved changes then show an edited indicator.
        // When there is only one tab the edited indicator is already built into the macOS close (red circle) button.
        if NSDocumentController.shared.documents.count > 1, document?.hasUnautosavedChanges ?? false {
            // Note the trailing space.
            windowTitle += "\(editedIndicator) "
        }
        
        #if DEBUG
            // Note the trailing space.
            windowTitle += "\(debugIndicator) "
        #endif
        
        windowTitle += displayName
        
        return windowTitle
    }
}
