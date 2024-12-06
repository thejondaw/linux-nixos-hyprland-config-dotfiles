# Гайд по установке NixOS с Hyprland

## Подготовка к установке

1. Скачайте и установите базовую версию NixOS с официального сайта.

2. После базовой установки, временно установите ripgrep и fish:

```shell
nix-shell -p ripgrep fish --run fish
```

*Примечание: Можно использовать классический bash и grep без установки fish и ripgrep.*

## Основные шаги настройки

### 1. Проверка конфигурации

Выполните команду для поиска мест, требующих настройки:

```shell
rg --hidden FIXME
```

Измените/добавьте строки в соответствии с вашим устройством:

- разделы
- swap
- периферийные устройства
- файловые системы

### 2. Настройка USBGuard 

⚠️ **ВАЖНО**: Настройте USBGuard в файле `nixos/usb.nix`

По умолчанию USBGuard блокирует все USB-устройства, что может привести к отключению:

- встроенной камеры
- bluetooth
- wifi
- других USB-устройств

Для настройки:

1. Установите пакет usbutils
2. Используйте команду `lsusb` для получения списка всех подключенных устройств
3. Добавьте доверенные USB-устройства в конфигурацию

```shell
# После установки системы, получи список ВСЕХ устройств:
lsusb > usb_devices.txt
```

*Альтернативно: можно отключить USBGuard, установив `services.usbguard.enable = false`*

### 3. Настройка LUKS (при использовании шифрования диска)

Если используете шифрование диска с LUKS и хотите использовать зашифрованный swap:

1. Включите swap на LUKS
2. Скопируйте автоматически сгенерированный блок кода:

```nix
boot.initrd.luks.devices."luks-UUID".device = "/dev/disk/by-uuid/ТВОЙ-UUID";
```

в один из файлов:

- nixos/swap.nix
- nixos/hardware-configuration.nix
- nixos/configuration.nix

### 4. Настройка пользователя и хоста

1. Для изменения имени пользователя:

```shell
rg --hidden 'xnm'
```

2. Для изменения имени хоста:

```shell
rg --hidden 'isitreal-laptop'
```

⚠️ **ВАЖНО**: 

- Убедитесь, что имя пользователя совпадает с установленным при инсталляции
- Измените git настройки в файлах:
  - home/.gitconfig
  - home/projects/.gitconfig.personal
  - home/work/.gitconfig.work

### 5. Включение поддержки flakes

1. Включите поддержку flakes в системе

```nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

2. Выполните:

```shell
sudo nixos-rebuild switch
```

### 6. Копирование конфигурационных файлов

1. Домашняя директория:
   - Скопируйте все файлы из `home` в ваш `$HOME`

2. Системная конфигурация:
   - Скопируйте все файлы из `nixos` в `/etc/nixos/` (с sudo правами)

⚠️ **ВАЖНО**: 

- Проверьте `system.stateVersion` в configuration.nix
- Убедитесь, что все файлы в /etc/nixos принадлежат root:

```shell
sudo chown -R root:root /etc/nixos
```

### 7. Сборка системы

Выполните одну из команд:

```shell
sudo nixos-rebuild switch --flake /etc/nixos#nixos --update-input nixpkgs --update-input rust-overlay --commit-lock-file --upgrade

# Or
nswitchu
```

или

```shell
nswitchu
```

## Пост-установка

### 1. Настройка GNOME

```shell
dconf load / < home/.config/gnome_settings_backup.dconf
```

### 2. Установка словарей для Qutebrowser

```shell
$(find $(nix-store --query --outputs $(which qutebrowser)) -iname '*dictcli.py*' | head -1) install en-US hi-IN
```

### 3. Применение темы Catppuccin

1. Для браузеров:
   - Установите Stylus Extension
   - Импортируйте `home/.config/stylus-catppuccin.json`

2. Для Cool-Retro-Term:
   - Запустите Cool-Retro-Term
   - Настройки -> Import
   - Выберите `home/.config/cool-retro-term-style.json`
   - Загрузите профиль "catppuccin-theme"

### 4. Завершение настройки

1. Войдите в свои аккаунты
2. Настройте графические приложения по вашему вкусу

После выполнения всех шагов у вас будет полностью настроенная система.
