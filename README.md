# env-scripts
我的環境腳本

## **install_ros_team_workspace.sh**

此腳本會將 [b-robotized/ros_team_workspace](https://github.com/b-robotized/ros_team_workspace) 安裝到 `~/workspaces/ros_team_workspace`，並設定 `~/.ros_team_ws_rc` 與 `.bashrc` 自動載入 RTW shell 工具。

> 安裝完成後請保留 `~/workspaces/ros_team_workspace`。shell 設定會 source 此資料夾內的檔案。
> 若安裝時環境中已設定 `ROS_DOMAIN_ID`，腳本會同步寫入 `~/.ros_team_ws_rc`；之後也可以直接到該檔案修改 `ROS_DOMAIN_ID`。
> 腳本會註解掉預設的 `ROS_STATIC_PEERS` 固定 IP 設定，避免套用不符合當前網路的 peer。
> 安裝過程會詢問是否啟用 RTW terminal coloring；預設不啟用，可之後到 `~/.ros_team_ws_rc` 調整。

```bash
wget -qO- https://raw.githubusercontent.com/HowardWhile/env-scripts/refs/heads/develop/install_ros_team_workspace.sh | bash
```

安裝後可使用 RTW shell workflow：

```bash
source ~/.bashrc
setup-ros-workspace ~/workspaces/ros/ws_ros jazzy
```

重新開啟 terminal 後：

```bash
_ws_ros
rosdepi 
rosd
cb
```

常用 RTW alias 對應：

| Alias | 說明 | 對應指令 |
| --- | --- | --- |
| `_ws_ros` | 啟用 `ws_ros` workspace | `source ~/workspaces/ros/ws_ros/install/setup.bash` |
| `rosdepi` | 安裝目前 workspace `src` 內 packages 缺少的 rosdep dependencies | `rosdep install -r -y -i --from-paths "$ROS_WS/src` |
| `rosd` | 進入目前 workspace 的 `src` 目錄 | `cd "$ROS_WS"` |
| `cb` | build 目前 workspace | `colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_EXPORT_COMPILE_COMMANDS=ON` |

移除 RTW 安裝：

```bash
wget -qO- https://raw.githubusercontent.com/HowardWhile/env-scripts/refs/heads/develop/uninstall_ros_team_workspace.sh | bash
```



## **setup_git_diff.sh**

此腳本會在您的 `.bashrc` 中建立一個 `_diff` 指令，顯示目前的差異並且自動複製差異文字到剪貼簿。

**主要功能：**
- **全面比較**：執行指令時會先執行 `git add -N .`，讓未追蹤的檔案也會出現在 diff 差異中。
- **顯示清晰**：終端機畫面上保持標準的紅綠顏色標記方便檢視，同時自動將「去色純文字版」存入剪貼簿。
- **方便貼上**：適合將差異片段直接貼上至 Slack、Discord 或 GitHub Issues，內容乾淨且不會包含亂碼顏色代碼。

```bash
wget -qO- https://raw.githubusercontent.com/HowardWhile/env-scripts/refs/heads/develop/setup_git_diff.sh | bash
```

![image-20260613004325597](./pic/README/image-20260613004325597.png)

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
