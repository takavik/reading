## Raspberry Pi setup
* Configure software source
```sh
sed -e "s|http://deb.debian.org/debian|https://mirrors.sjtug.sjtu.edu.cn/debian|" \
    -e "s|http://security.debian.org/debian-security|https://mirrors.sjtug.sjtu.edu.cn/debian-security|" \
    /etc/apt/sources.list > /etc/apt/sources.list.d/sjtu.list 
sed "s|http://archive.raspberrypi.org/debian|https://mirrors.sjtug.sjtu.edu.cn/raspberrypi/debian|" \
    /etc/apt/sources.list.d/raspi.list >> /etc/apt/sources.list.d/sjtu.list 
```

* Install Racket, Wolfram Engine
```sh
sudo apt update
sudo apt install -y racket wolframscript wolfram-engine emacs code firefox-esr
```

* Remove unwanted
```sh
sudo apt purge --autoremove -y 'libreoffice*' code-the-classics claws-mail chromium greenfoot-unbundled mu-editor thonny geany sense-emu-tools smartsim nano chromium-browser dillo vlc
```
