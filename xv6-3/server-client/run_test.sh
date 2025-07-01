#!/bin/bash

# 检查参数
if [ "$#" -ne 2 ]; then
    echo "用法: $0 <线程数 n> <速率参数 λc>"
    exit 1
fi

N_THREADS=$1
LAMBDA_C=$2
SESSION_NAME="cs_test_session"

# 1. 编译项目
echo "正在编译项目..."
make clean && make
if [ $? -ne 0 ]; then
    echo "编译失败，请检查代码。"
    exit 1
fi

# 2. 检查tmux是否在运行，如果是，则先杀掉旧会话
tmux has-session -t $SESSION_NAME 2>/dev/null
if [ $? -eq 0 ]; then
    echo "发现已存在的tmux会话 '$SESSION_NAME'，正在关闭..."
    tmux kill-session -t $SESSION_NAME
fi

# 3. 创建并配置新的tmux会话
echo "正在启动tmux会话 '$SESSION_NAME'..."
# 创建新会话，但不立即附着
tmux new-session -d -s $SESSION_NAME -n "Server/Client"

# 垂直分割窗口
tmux split-window -v -t $SESSION_NAME

# 在上方面板（pane 0）启动server
tmux send-keys -t $SESSION_NAME:0.0 './server' C-m

# 在下方面板（pane 1）启动client
# sleep 1是为了确保server有足够的时间创建好FIFO
tmux send-keys -t $SESSION_NAME:0.1 'sleep 1; ./client '"$N_THREADS"' '"$LAMBDA_C" C-m

# 4. 给出操作提示
echo "========================================================"
echo "测试环境已启动！"
echo "请使用以下命令进入tmux会话进行观察："
echo
echo "  tmux attach -t $SESSION_NAME"
echo
echo "在tmux中:"
echo "  - 上方是Server，下方是Client。"
echo "  - 使用 'tail -f data.txt' 在另一个终端查看实时日志。"
echo "  - 按 Ctrl+b 然后按 d 可以临时退出tmux会话（会话在后台继续运行）。"
echo "  - 要完全结束测试，请在Server窗口按 Ctrl+C，然后执行以下命令关闭会话："
echo "    tmux kill-session -t $SESSION_NAME"
echo "========================================================"