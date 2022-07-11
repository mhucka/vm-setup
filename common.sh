#!/bin/bash

cd ~

echo -e "\033[33;32m———————————————————————————————————————————————————\033[0m"
echo -e "\033[33;32mDoing a dist-upgrade ...\033[0m"
echo -e "\033[33;32m———————————————————————————————————————————————————\033[0m"

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get -y autoremove
sudo apt-get clean

echo -e "\033[33;32m———————————————————————————————————————————————————\033[0m"
echo -e "\033[33;32mInstalling initial software ...\033[0m"
echo -e "\033[33;32m———————————————————————————————————————————————————\033[0m"

pkgs=(alien \
      bat \
      boxes \
      build-essential \
      bzip2 \
      curl  \
      dstat \
      fswatch \
      fzf \
      ghostscript \
      git \
      git-lfs \
      gnupg \
      htop \
      imagemagick \
      jq \
      libapache2-mod-wsgi  \
      libcairo2-dev \
      liblzma-dev \
      libncursesw5 \
      libreadline-dev \
      libsqlite3-dev \
      libssl-dev \
      libxt-dev \
      manpages-dev \
      ncurses-base \
      net-tools \
      openssh-server \
      python3-dev \
      python3-pip \
      rsync \
      snapcraft \
      ssl-cert \
      tcsh \
      tk-dev \
      tree \
      ubuntu-desktop \
      wget \
      zip \
      zsh \
)

sudo apt install -y ${pkgs[@]}

wget https://github.com/dandavison/delta/releases/download/0.13.0/git-delta_0.13.0_amd64.deb
sudo apt install -y ./git-delta_0.13.0_amd64.deb
rm -f ./git-delta_0.13.0_amd64.deb

wget https://github.com/cli/cli/releases/download/v2.13.0/gh_2.13.0_linux_386.deb
sudo apt install -y ./gh_2.13.0_linux_386.deb
rm -f ./gh_2.13.0_linux_386.deb

curl https://pyenv.run | bash

# Use snap only to get the current version of Emacs, then shut down the
# service so it doesn't run daemons or auto-update things behind my back.

sudo snap install emacs --channel=beta --classic

sudo systemctl stop snapd.service
sudo systemctl mask snapd.service

echo -e "\033[33;32m———————————————————————————————————————————————————\033[0m"
echo -e "\033[33;32mGenerating SSH identity for GitHub ...\033[0m"
echo -e "\033[33;32m———————————————————————————————————————————————————\033[0m"

gh auth login --git-protocol ssh

echo -e "\033[33;32m———————————————————————————————————————————————————\033[0m"
echo -e "\033[33;32mAnswer 'yes' explicitly to the next question ...\033[0m"
echo -e "\033[33;32m———————————————————————————————————————————————————\033[0m"

/bin/rm -rf ~/system
gh repo clone mhucka/system

system/bin/makelinks

echo -e "\033[33;32m———————————————————————————————————————————————————\033[0m"
echo -e "\033[33;32mDoing additional software configuration ...\033[0m"
echo -e "\033[33;32m———————————————————————————————————————————————————\033[0m"

sudo apt remove -y gnome-power-manager pulseaudio

sudo systemctl stop cups cups-browsed
sudo systemctl disable cups cups-browsed

sudo addgroup www-data
sudo adduser $USERNAME www-data

# Make scrollbars wider.
cat >> ~/.config/gtk-3.0/gtk.css <<EOF
scrollbar slider {
    /* Size of the slider */
    min-width: 15px;
    min-height: 20px;
    border-radius: 20px;

    /* Padding around the slider */
    border: 5px solid transparent;
}
EOF

# Make clicking in the scrollbar cause scrolling by single pages.
mkdir -p ~/.config/gtk-3.0
cat >> ~/.config/gtk-3.0/settings.ini <<EOF
[Settings]
gtk-primary-button-warps-slider = false
EOF

# Set the background to a solid color.
cat >> /tmp/gnome-config.txt <<EOF
[org/gnome/desktop/background]
picture-uri='#100000'
primary-color='#300020'
EOF
dconf load /org/gnome/desktop/background:/ < /tmp/gnome-config.txt

emacs --batch --load ~/.emacs

echo -e "\033[33;32m———————————————————————————————————————————————————\033[0m"
echo -e "\033[33;32mDone. If all went well, reboot and do next step.\033[0m"
echo -e "\033[33;32m———————————————————————————————————————————————————\033[0m"
