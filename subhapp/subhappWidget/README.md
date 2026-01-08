# Shubh Widget Extension

This directory contains the iOS Widget Extension for displaying daily panchanga on the home screen.

## Setup Instructions

To add the widget extension to your Xcode project:

1. **Open the project in Xcode**
2. **Add Widget Extension Target:**
   - File > New > Target
   - Select "Widget Extension"
   - Name: "subhappWidget"
   - Uncheck "Include Configuration App Intent" (we use static configuration)
   - Click "Finish"
   - When prompted to activate the scheme, click "Activate"

3. **Replace Generated Files:**
   - Delete the auto-generated Swift file in the widget target
   - Add `subhappWidget.swift` from this folder to the widget target
   - Ensure Assets.xcassets is included in the widget target

4. **Configure App Groups (for data sharing):**
   - Select the main app target > Signing & Capabilities
   - Add "App Groups" capability
   - Create a group: `group.com.yourteam.subhapp`
   - Add the same App Group to the widget extension target

5. **Build and Run:**
   - Select the widget scheme
   - Build (Cmd+B) to verify compilation
   - Run on a device or simulator
   - Long-press the home screen to add the widget

## Widget Features

### Small Widget
- Tithi with Telugu name
- Nakshatra
- Day energy indicator

### Medium Widget
- Date and day
- Tithi and Nakshatra with Telugu names
- Score ring
- Rahu Kalam warning

### Large Widget
- Full date header
- Score ring with rating
- Panchanga grid (Tithi, Nakshatra)
- Rahu Kalam alert box
- Energy level footer

## Timeline Updates
- Widget refreshes every hour
- Shows current day's panchanga
- Updates automatically at midnight

## Future Enhancements
- Configurable intents (select location)
- Lock screen widgets (iOS 16+)
- Interactive widgets (iOS 17+)
