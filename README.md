# Disney Living Room Devices - Roku Engineering Assignment

This is a Roku SceneGraph application developed as part of the Disney Living Room Devices Engineering take-home assignment. It displays a "Home" and "Details" screen populated from Disney+ style JSON data and supports focus-based navigation using the Roku remote.

## Features

- Fetches and displays home screen content from Disney+ style APIs.
- Uses the `1.78` aspect ratio images for display.
- Focused tiles scale up for visual emphasis.
- Compatible with all current Roku device models.
- Supports remote navigation (`up`/`down`/`left`/`right`/`OK`).
- Clean layout that displays multiples rows of data.
- Displays tiles gathered from the ref set data.
- Allows for interaction or selection of a tile by displaying a "Details" screen that contains data for the selected tile.
- Incorporates animations for visual aesthetics.
- Includes Disney magic.

## Requirements
- Roku device on the same network.
- (Optional) [BrightScript VS Code Extension](https://marketplace.visualstudio.com/items?itemName=RokuCommunity.brightscript)

## Data APIs
The following APIs allow for the population of rows and tile content dynamically.
- Home Page Data:  
  `https://cd-static.bamgrid.com/dp-117731241344/home.json`

- Ref Set Data:  
  `https://cd-static.bamgrid.com/dp-117731241344/sets/<refId>.json`

---

## How To Side-Load The App

### Option 1: Using Roku Web Developer Interface (Manual Method)

1. #### Enable Developer Mode on your Roku device
   - Press the following sequence on your remote:
     `Home` x3 → `Up` x2 → `Right` → `Left` → `Right` → `Left` → `Right`
   - Note down the developer web console IP address shown on screen.
     - This can also be found within: `Home → Settings → Network → About → IP address`

2. #### Package the Project
    - Download the included ZIP.
    - Or:
      - Clone this repository:  
          ```
          git clone https://github.com/stregea/living_room_devices.git
          ```
      - Zip the contents of the repo’s root directory.

3. #### Side-load the App
   - Open a browser and go to: `http://<ROKU_DEVICE_IP>`.
   - Log in (default username is `rokudev`, password was set during developer mode setup).
   - Upload your ZIP package and click `Install`.

---

### Option 2: Using VS Code + BrightScript Extension

1. #### Install the VS Code BrightScript Extension:
    - [BrightScript VS Code Extension](https://marketplace.visualstudio.com/items?itemName=RokuCommunity.brightscript)

2. #### Clone the repository
   ```
   git clone https://github.com/stregea/living_room_devices.git
   ```

3. #### Run the project
   ##### Method 1: 
   - Press `Cmd + Shift + D` (Mac) or `Ctrl + Shift + D` (Windows).
   - Press the green play button.
   - Enter your Roku's IP address and your password when prompted.

   ##### Method 2:
    - Within`.vscode/settings.json`, modify the following properties:
      - From 
        ```json
        {
          "host": "${promptForHost}",
          "password": "${promptForPassword}",
        }
        ```
        to
        ```json
        {
          "host": "<ROKU_DEVICE_IP>",
          "password": "<your_password>",
        }
        ```
      - Press `Cmd + Shift + D` (Mac) or `Ctrl + Shift + D` (Windows).
      - Press the green play button.

---

## Extras

- [Roku Developer Documentation](https://developer.roku.com/docs/developer-program/getting-started/roku-dev-prog.md)
- [Roku Reference Documentation](https://developer.roku.com/docs/references/references-overview.md)