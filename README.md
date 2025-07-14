# Disney Living Room Devices - Roku Engineering Assignment

This is a Roku SceneGraph application developed as part of the Disney Living Room Devices Engineering take-home assignment. 
It displays a **Home** and **Details** screen populated from Disney+ style JSON data, and supports focus-based 
navigation using the Roku remote.


## Features

- Fetches and displays home screen content from Disney+ style APIs.
- Uses the `1.78` aspect ratio images for display.
- Focused tiles scale up for visual emphasis.
- Compatible with all current Roku device models.
- Supports remote navigation (`↑ ↓ ← → OK`).
- Clean layout that displays multiples rows of content.
- Displays tiles gathered from the `refId` set data.
- Allows for interaction or selection of a tile by displaying a "Details" screen that contains data for said tile.
- Incorporates animations for visual aesthetics.
- Includes a touch of Disney magic.

## Requirements
- Roku device on the same network.
- (Optional) [BrightScript VS Code Extension](https://marketplace.visualstudio.com/items?itemName=RokuCommunity.brightscript)

## Data APIs
This app pulls dynamic content from the following endpoints:

- Home Page Data:  
  `https://cd-static.bamgrid.com/dp-117731241344/home.json`

- Ref Set Data:  
  `https://cd-static.bamgrid.com/dp-117731241344/sets/<refId>.json`

---

## How To Side-Load The App

### Option 1: Using Roku Web Developer Interface (Manual Method)

1. **Enable Developer Mode**
   - Press the following sequence on your remote:
     `Home` x3 → `Up` x2 → `Right` → `Left` → `Right` → `Left` → `Right`
   - Note the IP address shown on screen.
     - You can also find it in: `Home → Settings → Network → About → IP address`

2. **Package the Project**
    - Option A: [Download the included ZIP](https://github.com/stregea/living_room_devices/blob/main/living_room_devices.zip).
    - Option B: Clone and zip it yourself:
        ```
        git clone https://github.com/stregea/living_room_devices.git
        ```
      Then zip the contents of the root directory.

3. **Side-load the App**
   - Open a browser and go to: `http://<ROKU_DEVICE_IP>`.
   - Log in using:
     - **Username:** `rokudev`
     - **Password:** the one set during developer setup.
   - Upload the ZIP file and click `Install`.

---

### Option 2: Visual Studio Code + BrightScript Extension

1. **Install the VS Code BrightScript Extension**
    - [BrightScript VS Code Extension](https://marketplace.visualstudio.com/items?itemName=RokuCommunity.brightscript)

2. **Clone the repository**
   ```
   git clone https://github.com/stregea/living_room_devices.git
   ```

3. **Run the project**

   **Method A: Prompted Mode**
   - Press `Cmd + Shift + D` (Mac) or `Ctrl + Shift + D` (Windows).
   - Press the green ▶️ button.
   - Enter your Roku IP and password when prompted.

   **Method B: Configure Settings Manually**
    - Within`.vscode/settings.json`, modify the following properties:
      - From 
        ```json
        {
          "host": "${promptForHost}",
          "password": "${promptForPassword}",
        }
        ```
        To
        ```json
        {
          "host": "<ROKU_DEVICE_IP>",
          "password": "<your_password>",
        }
        ```
      - Save the file
      - Press `Cmd + Shift + D` (Mac) or `Ctrl + Shift + D` (Windows).
      - Press the green ▶️ button.

---

## Additional Resources

- [Roku Developer Documentation](https://developer.roku.com/docs/developer-program/getting-started/roku-dev-prog.md)
- [Roku Reference Documentation](https://developer.roku.com/docs/references/references-overview.md)