<a id="readme-top"></a>

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/iulian-b/fox-conky">
    <img src="assets/logo.png" alt="Logo" width="640" height="640">
  </a>

  <h3 align="center">ƒøx-conky</h3>

  <p align="center">
    Conky widget configration files for ƒøχglove
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details open>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#about">About</a></li>
    <li><a href="#requirements">Requirements</a></li>
    <li><a href="#installation">Installation</a></li>
    <li><a href="#modules">Modules</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#special-thanks">Special Thanks</a></li>
  </ol>
</details>


<!-- ABOUT THE PROJECT -->
## About
(PIC OF PC)
[![Product Name Screen Shot][product-screenshot]](https://example.com)


Use the `BLANK_README.md` to get started.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- REQUIREMENTS -->
### Requirements

* [conky](https://github.com/brndnmtthws/conky/wiki/Installation#installing-prebuilt-binaries)
* [Hack Nerd Font](https://www.nerdfonts.com/font-downloads) (or any other Nerd font)
* [SF-Pro font](https://github.com/sahibjotsaggu/San-Francisco-Pro-Fonts) (optional)
  

<!-- INSTALLATION -->
### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/iulian-b/fox-conky/tree/main
   cd fox-conky
   ```
2. Move the configuration file to your conky config folder  
   ```sh
   mkdir ~/.config/conky/foxglove
   mv config.conf ~/.config/conky/foxglove
   ```
   The conky configuration folder might be located somewhere else on your system, or not be there at all.

   You can theoretically place the configuration file anywhere on your drive, as long as you specify it's location when starting conky, but it's best practice to keep all custom conky configurations in an identifiable folder.  
3. Start conky
   ```sh
   conky --config='~/.config/foxglove/config.conf'
   ```
4. (Optional) Autostart conky
   You should consult your DE/WM wiki on how to atostart programs and scripts. I have listed below the autostart procedure on some envirovements

   * Niri
   ```sh
   # in ~/.config/niri/config.kdl
   spawn-sh-at-startup "conky --config='~/.conky/foxglove/config.conf'"
   ```
   * Hyperland
   ```sh
   # in ~/.config/hypr/hyperland.conf
   exec-once = $terminal -e conky --config='~/.conky/foxglove/config.conf'
   ```
   * BSPWM
   ```sh
   # in ~/.config/bspwm/bspwmrc
   run conky --config='~/.config/conky/foxglove/config.conf'
   ```
   * KDE Plasma
   ```
   System settings -> Autostart -> +Add New - Application -> conky
   Edit conky entry -> Application tab -> Arguments: --daemonize --pause=1 --config=~/.conky/foxglove/config.conf
   ```
   * Generic autostart script
   ```sh
   #!/bin/sh

   if [ "$DESKTOP_SESSION" = "<NAME OF YOUR SESSION>" ]; then 
     sleep 20s
     killall conky
     cd "$HOME/.config/conky/foxglove"
     conky -c "$HOME/.config/conky/foxglove/config.conf" &
     exit 0
   fi
   ```


<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- MODULES -->
## Modules

<details>
  <summary>Clock</summary>
  <ul>
    <li>Clock (HH:MM)</li>
    <li>Date (DD.MM.YYYY) | Time (d)</li>
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
    <li><a href="https://wttr.in">wttr.in</a> forecasts</li>
  </ul>
</details>

<details>
  <summary>Network</summary>
  <ul>
    <li>Network interface</li>
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
    <li>Core 01-24 graphs</li>
    <li>Core 00 | Core 00 graph</li>
    <li>Temp</li>
    <li>CPU usage graph</li>
  </ul>
</details>

<details>
  <summary>GPU</summary>
  <ul>
    <li>Name | Frequency</li>
    <li>Usage | Driver</li>
    <li>Edge Temp | Fan RPM</li>
    <li>Memory Temp | Memory Frequency</li>
    <li>Junction Temp | Power Draw</li>
    <li>Usage graph</li>
  </ul>
</details>

<details>
  <summary>Storage</summary>
  <ul>
    <li>Internal disks partitions | Graph | Usage</li>
    <li>External disks partitions | Graph | Usage</li>
  </ul>
</details>

<details>
  <summary>Usage</summary>
  <ul>
    <li>Uptime</li>
    <li>Memory Graph | Usage</li>
    <li>Processes running | Load average</li>
    <li>Top 3 running processes by CPU load</li>
    <li>Top 3 running processes by Memory load</li>
    <li>Top 3 running processes by I/O load</li>
  </ul>
</details>

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- SPECIAL-THANKS -->
## Special Thanks

* [Catppuccin](https://github.com/catppuccin/conky)
* [Best README Template](https://github.com/othneildrew/Best-README-Template/tree/main)
* [Font Awesome](https://fontawesome.com)
* [SF Pro Fonts](https://github.com/sahibjotsaggu/San-Francisco-Pro-Fonts)
<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[product-screenshot]: images/screenshot.png
