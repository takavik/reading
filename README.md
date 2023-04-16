## Raspberry Pi setup
* Configure software source
```sh
sed -e "s|http://deb.debian.org/debian|https://mirrors.sjtug.sjtu.edu.cn/debian|"                           \
    -e "s|http://security.debian.org/debian-security|https://mirrors.sjtug.sjtu.edu.cn/debian-security|"    \
    /etc/apt/sources.list > /etc/apt/sources.list.d/sjtu.list 
sed "s|http://archive.raspberrypi.org/debian|https://mirrors.sjtug.sjtu.edu.cn/raspberrypi/debian|"         \
    /etc/apt/sources.list.d/raspi.list >> /etc/apt/sources.list.d/sjtu.list 
```

* Install Racket, Wolfram Engine
```sh
sudo apt update
sudo apt install -y racket wolframscript wolfram-engine emacs code firefox-esr
```

* GNOME
```sh
sudo tasksel install gnome-desktop
```

* Remove unwanted
```sh
sudo apt purge --autoremove -y lx* libreoffice* code-the-classics claws-mail greenfoot-unbundled            \
  mu-editor thonny geany sense-emu-tools smartsim nano dillo vlc iagno lightsoff four-in-a-row              \
  gnome-robots pegsolitaire gnome-2048 hitori gnome-klotski gnome-mines gnome-mahjongg gnome-sudoku         \
  quadrapassel swell-foop gnome-tetravex gnome-taquin aisleriot five-or-more gnome-chess gnome-weather      \
  ibus synaptic tali nm-connection-editor network-manager-gnome qt* arandr realvnc* rp-prefapps rhythmbox   \ 
  gnome-music totem 
```

* Visual Studio Code - Refer to [official instructions](https://code.visualstudio.com/docs/setup/linux)