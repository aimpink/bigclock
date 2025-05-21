# Clock Application - Developer Documentation

## Overview

This is a minimalist web-based clock application that displays the current time in a 12-hour format. The application is designed to be responsive, adjusting the clock size based on the viewport dimensions, and includes wake lock functionality to prevent the screen from sleeping when the clock is active.

## Features

- Real-time clock display in 12-hour format (HH:MM:SS AM/PM)
- Responsive design that adjusts font size based on viewport width
- Screen wake lock functionality to keep the screen on while the clock is displayed
- Progressive Web App (PWA) support
- Dark theme with customizable styling

## File Structure

The application consists of the following files:

- `index.html` (the main HTML file provided in this documentation)
- `pwa.js` (service worker script for PWA functionality, referenced but not included)
- `manifest.json` (PWA manifest file, referenced but not included)
- `favicon.svg` and `favicon.ico` (icon files, referenced but not included)

## Technical Components

### HTML Structure

The HTML is minimalistic, containing:
- Meta tags for proper mobile display and PWA support
- A simple container div for the clock display
- A span element with ID "clocktext" that contains the actual time

### CSS Styling

The application uses inline CSS for styling with these key elements:
- Dark background (`#000000`)
- Light gray text color (`#D0D0D0`)
- Sans-serif bold font
- Table-cell display for vertical and horizontal centering

### JavaScript Functionality

The JavaScript code handles four primary functions:

1. **Time Display** (`updateClock` function)
   - Updates the clock text every second
   - Uses 12-hour time format with AM/PM indicator
   - Calculates the timeout to ensure updates occur precisely at second boundaries

2. **Responsive Font Sizing** (`updateTextSize` function)
   - Dynamically adjusts the font size based on window width
   - Uses an iterative approach to find the optimal font size
   - Targets approximately 90% of screen width

3. **Wake Lock Management**
   - Prevents the device screen from turning off
   - Uses the Wake Lock API (when available)
   - Acquires lock on page load, releases on unload

4. **Event Handlers**
   - Listens for window resize to adjust the font size
   - Listens for page load/unload to manage wake lock

## API Usage

### Wake Lock API

The application uses the Wake Lock API to keep the device screen awake:

```javascript
wakeLock = await navigator.wakeLock.request('screen');
```

This is a relatively new browser API and may not be supported in all browsers. The code includes fallback handling for browsers that don't support this feature.

## Customization

### Visual Customization

To modify the appearance of the clock:

1. **Background Color**: Change the `background` property in the `html` CSS rule
2. **Text Color**: Modify the `color` property in the `#clocktext` CSS rule
3. **Font**: Adjust the `font-family` and `font-weight` properties in the `#clocktext` CSS rule

### Layout Customization

1. **Clock Size**: Modify the `targetWidth` variable in the `updateTextSize` function to change the relative size of the clock display (default is 0.9 or 90% of viewport width)
2. **Vertical Position**: Adjust the `vertical-align` property in the `#clock-container` CSS rule

## Progressive Web App Integration

The application includes basic PWA support:
- References a manifest file (`manifest.json`)
- Includes a service worker script (`pwa.js`)
- Sets theme color for browser UI integration
- Provides favicon assets

These files need to be created separately to enable full PWA functionality.

## Browser Compatibility

The application should work in all modern browsers with the following considerations:
- The Wake Lock API is not supported in all browsers
- CSS table-cell display is widely supported but may have minor differences across browsers
- Font rendering may vary slightly between platforms

## Maintenance Considerations

### Code Optimization

The current implementation uses an iterative approach for font sizing that typically converges quickly but has a safety limit of 10 iterations. This could be optimized further if needed.

### Future Enhancements

Potential improvements could include:
- Adding date display
- User configurable appearance (light/dark mode)
- Time format options (12/24 hour)
- Alarm functionality
- Better offline support through service worker implementation

## License and Attribution

The code includes a copyright notice indicating it is proprietary and confidential property of Alan Impink. Any modifications, distribution, or copying requires written consent from the author.

Contact information for permissions: aimpink@yahoo.com
