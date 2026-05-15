# env-scripts
我的環境腳本

## **setup_tmux_ubuntu.sh**

此腳本將更新套件庫、安裝 tmux 和 xclip、下載指定 Gist 中的 tmux 配置，並在 tmux 運行時重新載入配置。

此 `.tmux.conf` 配置提供：
- 啟用滑鼠模式
- 啟用反白複製文字
- 使用 <kbd>Alt</kbd>+<kbd>方向鍵</kbd>切換 pane
- 使用 <kbd>Shift</kbd>+<kbd>方向鍵</kbd>切換 window
- 將 prefix 從 <kbd>Ctrl</kbd> + <kbd>b</kbd>` 改為 `<kbd>Ctrl</kbd> + <kbd>a</kbd>
- 垂直切割視窗快捷鍵 <kbd>Ctrl</kbd> + <kbd>a</kbd> + <kbd>|</kbd>
- 水平切割視窗快捷鍵 <kbd>Ctrl</kbd> + <kbd>a</kbd> + <kbd>-</kbd>

```bash
wget -qO- https://raw.githubusercontent.com/HowardWhile/env-scripts/refs/heads/develop/setup_tmux_ubuntu.sh | bash
```

![image-20260515171258378](./pic/README/image-20260515171258378.png)





## **install_show_desktop.sh**

此腳本將安裝必要的 wmctrl 套件，並建立一個 "顯示桌面" 的桌面啟動器，讓您可以快速顯示桌面。

```bash
wget -qO- https://raw.githubusercontent.com/HowardWhile/env-scripts/refs/heads/develop/install_show_desktop.sh | bash
```

![image-20260515170956510](./pic/README/image-20260515170956510.png)





