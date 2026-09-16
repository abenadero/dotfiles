#Instalación arch base

## Post-instalación arch
sudo pacman -S flatpak waybar fastfetch hyprpaper man micro firefox 7zip unzip
sudo pacman -S hyprtoolkit hyprpolkitagent hyprutils hyprwire hyprlang hyprshot hyprlock
sudo pacman -S --needed base-devel git stow btop
sudo pacman -S pavucontrol dmidecode nvmi-cli

## Instalar AUR
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

## Cambiar teclado a espanyol
Colocar en ~/.config/hypr/hyprland.lua

hl.config({
    input = {
        kb_layout = "es",
    },
})

## Instalar locales
locale -a 
sudo vim /etc/locale.gen
sudo locale-gen

## Evitar parpadeo de teclado en hardware antiguo
hl.config({
    cursor = {
        no_hardware_cursors = 1,
    }
})

## Instalar fuentes
mkdir -p ~/.local/share/fonts
cp /ruta/a/las/fuentes/*.ttf ~/.local/share/fonts/
fc-cache -fv

## Binding fullscreen
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen()

## Binding wofi
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu .. " --show drun"))

## Arrancar programas al inicio
hl.on("hyprland.start", function () 
    hl.exec_cmd(terminal)
--    hl.exec_cmd("nm-applet")
    hl.exec_cmd("waybar & hyprpaper")
end)

## Cambiar terminal por defecto en Dolphin
Crear fichero esperado por Dolphin:

## Configurar red
Herramientas para ethernet:
sudo pacman -S ethtool
sudo pacman -S nmap
sudo networkctl reconfigure enp10s0

NetworkManager:
sudo pacman -S networkmanager networkmanager-dmenu
sudo mkdir -p /etc/NetworkManager/conf.d
sudo micro /etc/NetworkManager/conf.d/wifi_backend.conf

[device]
wifi.backend=iwd

sudo systemctl disable systemd-networkd.service
sudo systemctl disable systemd-networkd-wait-online.service
sudo systemctl disable iwd.service

sudo systemctl enable NetworkManager.service

`~/.config/kdeglobals`

Y en él escribir:
 
[General]
TerminalApplication=kitty
TerminalService=kitty.desktop

## Instalar fuentes
mkdir -p ~/.local/share/fonts
unzip ~/Descargas/FireCode.zip -d ~/.local/share/fonts/
fc-cache -fv
fc-list : family | sort -u

## Cambiar a tema oscuro
sudo pacman -S nwg-look
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

(Dolphin en modo breeze dark)
sudo pacman -S qt6ct breeze
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
qt6ct

## Cursor catppuccin
yay -S catppuccin-cursors-mocha
ls /usr/share/icons | grep -i catppuccin

En hyprland.lua:

hl.env("XCURSOR_THEME", "catppuccin-mocha-light-cursors")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "catppuccin-mocha-light-cursors")

## Instalar Steam
Habilitar repositorio multilib
sudo micro /etc/pacman.conf
sudo pacman -Syu

sudo pacman -S steam 
Elegir -> lib32-vulkan-intel

## Paquetes extra
yt-dlp

## Clave SSH
ssh-keygen -t ed25519 -C abenadero.dev@protonmail.com
eval "$(ssh-agent -s)"
cat ~/.ssh/id_ed25519.pub
