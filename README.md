<a id="readme-top"></a>

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/iulian-b/fox-conky">
    <img src="assets/logo.png" alt="Logo" width="640">
  </a>

  <h3 align="center">ƒøx-conky v2</h3>

  <p align="center">
    Conky widget configuration files for ƒøχglove
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details open>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#about">About</a></li>
    <li><a href="#whats-new-in-v2">What's new in v2</a></li>
    <li><a href="#requirements">Requirements</a></li>
    <li><a href="#installation">Installation</a></li>
    <li><a href="#customization">Customization</a></li>
    <li><a href="#modules">Modules</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#special-thanks">Special Thanks</a></li>
  </ol>
</details>


<!-- ABOUT THE PROJECT -->
## About

<div align="center">
  <img src="assets/demo.png" alt="ƒøx-conky running on a vertical side panel" width="640">
</div>

ƒøx-conky is a tall, single-column system monitor for [conky](https://github.com/brndnmtthws/conky), built to fill a vertical 1920px side screen. It  the [Catppuccin](https://github.com/catppuccin/conky) palette (Teal, Peach, Maroon) and Nerd Font icons.

V2 NEW: Most sections are now driven by small shell scripts that read live data from `sysfs`, `lsblk`, NetworkManager and MPRIS, which adapt the widget to the machine it runs on (instead of being hardcoded to mine).

<details>
  <summary>Preview</summary>
  <br />

  > [!NOTE]
  > Some of the data shown in this video is statically set (for example the public IP addresses), to avoid doxxing. On your machine every value is read live.
  
  <video src="https://github.com/user-attachments/assets/1651f91d-35e2-4cc3-bd05-1fc583dff7e6" controls muted width="100%"></video>

  If the video doesn't play above, [open `assets/demo.mp4` directly](assets/demo.mp4).
</details>

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- WHATS NEW -->
## What's new in v2

* **Live, dynamic data:** the startup workaround script that wrote values to a file once at login is gone. Every section now reads its data live while conky runs.
* **Weather:** wttr.in emoji are swapped for filled Nerd Font weather icons (with a monochrome Noto Emoji fallback for anything else), and sunrise and sunset times are shown in the header.
* **Media:** a new *Now Playing* section shows the player, track, artist and position of whatever MPRIS player is playing. It disappears entirely when nothing is playing. Useful when a fullscreen program (ex. a game) covers your music widget.
* **Network:** the interface name is replaced by icons for Wi-Fi, Ethernet or no internet, next to the active connection's name. The public IP is now refreshed hourly instead of every second.
* **CPU:** temperature is now read directly from the `k10temp` sensor instead of calling `sensors` every second.
* **GPU:**
  * The GPU is **auto-detected** (the card with the most VRAM, so the discrete GPU wins on laptops and APU systems).
  * The name is read from libdrm's `amdgpu.ids`, falling back to `lspci`.
  * New VRAM used/total line, with memory clock now on its own line.
  * The fan has replaced the redundant usage line, and the Mesa version is shown as the driver.
* **Storage:**
  * Basically redone the entire section from scratch, since i was never happy with it. 
  * Disk read and write speeds with graphs, matching the network section.
  * Partitions are discovered automatically and grouped into *Internal Linux*, *Internal Windows*, *External Drive* and *External USB*. Empty categories show as offline.
* **Tuning:** Same as before, shows the P-State driver, EPP and real core boost state, the 3D V-Cache mode (X3D CPUs only), the I/O scheduler of the root disk and the active [LACT](https://github.com/ilya-zlobintsev/LACT) GPU profile, but now done with a better script which follows v2 guidelines. Lines that don't apply to your hardware are hidden, and non-AMD CPUs fallback to the cpufreq driver and governor.
* **Usage:** new swap / zram bar under memory.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- REQUIREMENTS -->
## Requirements

* [conky](https://github.com/brndnmtthws/conky/wiki/Installation#installing-prebuilt-binaries) (obviously) 1.19 or newer (runs through XWayland on Wayland sessions)
* [Hack Nerd Font](https://www.nerdfonts.com/font-downloads)
* [SF-Pro font](https://github.com/sahibjotsaggu/San-Francisco-Pro-Fonts) for the clock (optional, you can use whatever you prefer)
* `curl` for weather and the public IP
* NetworkManager (`nmcli`) for the network icon and connection name. Alternatives (systemd-network, netplan, etc.) require a re-write of the network script to function.
* `util-linux` (`lsblk`, `findmnt`) for storage and tuning

Optional, the related lines are hidden or empty without them:

* [playerctl](https://github.com/altdesktop/playerctl) for the Media section
* [Noto Emoji](https://fonts.google.com/noto/specimen/Noto+Emoji) (monochrome, e.g. `ttf-noto-emoji-monochrome` on Arch based distros) for weather symbols without a Nerd Font icon
* [LACT](https://github.com/ilya-zlobintsev/LACT) for the GPU profile in Tuning

> [!NOTE]
> The GPU section reads AMD `amdgpu` sysfs files, and the CPU temperature uses the `k10temp` sensor. On Intel or NVIDIA hardware those lines will be empty.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- INSTALLATION -->
## Installation

1. Clone the repo into `~/.conky/fox-conky`
   ```sh
   git clone https://github.com/iulian-b/fox-conky.git ~/.conky/fox-conky
   cd ~/.conky/fox-conky
   chmod +x *.sh
   ```
   The config calls its helper scripts from `~/.conky/fox-conky/`. If you want to keep it somewhere else, remember to replace the paths in `config.conf` or they won't run:
   ```sh
   sed -i 's|~/.conky/fox-conky|~/your/path|g' config.conf
   ```
2. Start conky
   ```sh
   conky --config="$HOME/.conky/fox-conky/config.conf"
   ```
3. (Optional) Autostart conky

   Consult your DE/WM wiki on how to autostart programs and scripts. Below is the autostart procedure for some environments.

   * Niri
   ```kdl
   // in ~/.config/niri/config.kdl
   spawn-sh-at-startup "conky --config=$HOME/.conky/fox-conky/config.conf"
   ```
   * Hyprland
   ```sh
   # in ~/.config/hypr/hyprland.conf
   exec-once = conky --config=$HOME/.conky/fox-conky/config.conf
   ```
   * BSPWM
   ```sh
   # in ~/.config/bspwm/bspwmrc
   conky --config="$HOME/.conky/fox-conky/config.conf" &
   ```
   * KDE Plasma
   ```
   System settings -> Autostart -> +Add New -> Application -> conky
   Edit conky entry -> Application tab -> Arguments: --daemonize --pause=1 --config=~/.conky/fox-conky/config.conf
   ```
   * Generic autostart script
   ```sh
   #!/bin/sh

   if [ "$DESKTOP_SESSION" = "<NAME OF YOUR SESSION>" ]; then
     sleep 20s
     killall conky
     conky --config="$HOME/.conky/fox-conky/config.conf" &
     exit 0
   fi
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- CUSTOMIZATION -->
## Customization

* **Weather locations:** edit the `weather.sh <Location>` lines and the `wttr.in/<Location>` sunrise/sunset call in the WEATHER section of `config.conf`.
* **Colors:** `color1`, `color2` and `color3` at the top of `config.conf`.
* **Size and position:** `alignment`, `gap_x`, `gap_y`, `maximum_width` and `minimum_height`. The defaults fit a 1920px-tall vertical screen.
* **Tuning:** this section is tailored to my system. If it shows nothing useful on yours, remove it from `config.conf`.
* Comments for *each* section of the config file where added in v2, detailing what they display and what can be/should me customized. Refer to those for more in-depth details. 

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- MODULES -->
## Modules

<details>
  <summary>Clock</summary>
  <ul>
    <li>Clock (HH:MM)</li>
    <li>Date (DD.MM.YYYY) | Day</li>
  </ul>
</details>

<details>
  <summary>ID</summary>
  <ul>
    <li>user@hostname</li>
    <li>Kernel | Architecture</li>
  </ul>
</details>

<details>
  <summary>Weather</summary>
  <ul>
    <li>Sunrise | Sunset</li>
    <li><a href="https://wttr.in">wttr.in</a> forecasts for multiple locations, with Nerd Font weather icons</li>
  </ul>
</details>

<details>
  <summary>Media</summary>
  <ul>
    <li>Player | Position / Length</li>
    <li>Title</li>
    <li>Artist</li>
    <li>Only shown while a player is playing</li>
  </ul>
</details>

<details>
  <summary>Network</summary>
  <ul>
    <li>Connection name | Wi-Fi / Ethernet / Offline icon</li>
    <li>Private IP</li>
    <li>Public IP</li>
    <li>Upload and Download | Speeds</li>
    <li>Upload and Download | Total</li>
    <li>Upload and Download | Graph</li>
  </ul>
</details>

<details>
  <summary>CPU</summary>
  <ul>
    <li>Name | Frequency</li>
    <li>Core 01-N graphs (manually change based on the number of cores on your CPU)</li>
    <li>Usage | Usage bar</li>
    <li>Temp</li>
    <li>CPU usage graph</li>
  </ul>
</details>

<details>
  <summary>GPU</summary>
  <ul>
    <li>Name (auto-detected) | Frequency</li>
    <li>Fan RPM | Driver (Mesa version)</li>
    <li>Edge Temp | Memory Frequency</li>
    <li>Memory Temp | VRAM used / total</li>
    <li>Junction Temp | Power Draw</li>
    <li>Usage graph</li>
  </ul>
</details>

<details>
  <summary>Storage</summary>
  <ul>
    <li>Read | Write speeds</li>
    <li>Read | Write graphs</li>
    <li>*(change these entries below to your liking)*</li>
    <li>Internal Linux partitions | Usage bar | Used / Total</li>
    <li>Internal Windows partitions | Usage bar | Used / Total</li>
    <li>*(these shold now auto-detect work better in v2)*</li>
    <li>External Drive partitions | Usage bar | Used / Total</li>
    <li>External USB partitions | Usage bar | Used / Total</li>
  </ul>
</details>

<details>
  <summary>Tuning (optional)</summary>
  <ul>
    <li>P-State driver (or CPU driver)</li>
    <li>P-State EPP (or CPU governor)</li>
    <li>Core boost</li>
    <li>3D V-Cache optimizer mode (X3D CPUs only)</li>
    <li>I/O scheduler of the root disk</li>
    <li>LACT GPU profile</li>
  </ul>
</details>

<details>
  <summary>Usage</summary>
  <ul>
    <li>Uptime</li>
    <li>Memory bar | Usage</li>
    <li>Swap / zram bar | Usage</li>
    <li>Processes running | Load average</li>
    <li>Top 3 running processes (by CPU load)</li>
    <li>Top 3 running processes (by Memory load)</li>
    <li>Top 3 running processes (by I/O load)</li>
  </ul>
</details>

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- LICENSE -->
## License

Distributed under the MIT License. See [`LICENSE`](LICENSE) for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- SPECIAL-THANKS -->
## Special Thanks

* [Catppuccin](https://github.com/catppuccin/conky)
* [Best README Template](https://github.com/othneildrew/Best-README-Template/tree/main)
* [Nerd Fonts](https://www.nerdfonts.com)
* [SF Pro Fonts](https://github.com/sahibjotsaggu/San-Francisco-Pro-Fonts)
* [wttr.in](https://github.com/chubin/wttr.in)

<p align="right">(<a href="#readme-top">back to top</a>)</p>
