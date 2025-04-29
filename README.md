# JohmaOS

## 使い方

### 環境  wsl2 + ubuntu 24.04 LTS + qemu-system-x86_64

### ディレクトリ構成

- (HOME-USER)~$
  -  (DIR) third_party
     - (DIR) ovmf
       - (FILE) RELEASEX64_OVMF.fd
  - (DIR) mnt
    - (DIR) EFI
      - (DIR) BOOT
        - (FILE) BOOTX64.EFI


### wsl2の設定

``` /etc/wsl.conf ```　に以下コードを追加してwslを再起動

```

[automount]
options = "metadata,umask=22,fmask=11"

```

これでmake allが使用できる。

### 必要コマンド

``` 
qemu-system-x86_64 -bios third_party/ovmf/RELEASEX64_OVMF.fd -drive format=raw,file=fat:rw:mnt,media=disk -serial stdio -serial file:serial.log -d int -D qemu_log.txt

```