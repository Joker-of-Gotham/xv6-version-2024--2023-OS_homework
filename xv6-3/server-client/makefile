# Makefile for Client-Server Project

# 编译器和编译选项
CC = gcc
# CFLAGS: C编译器的标志。-g: 添加调试信息; -Wall: 开启所有警告; -O2: 优化级别2
CFLAGS = -g -Wall -O2
# LDFLAGS: 链接器的标志。
LDFLAGS =
# LIBS: 需要链接的库。-lpthread: 链接POSIX线程库; -lm: 链接数学库
LIBS = -lpthread -lm

# 源文件
CLIENT_SRC = client.c
SERVER_SRC = server.c

# 目标可执行文件
CLIENT_TARGET = client
SERVER_TARGET = server
TARGETS = $(CLIENT_TARGET) $(SERVER_TARGET)

# 默认目标：编译所有
all: $(TARGETS)

# 编译Client
$(CLIENT_TARGET): $(CLIENT_SRC) common.h
	$(CC) $(CFLAGS) -o $@ $< $(LIBS)

# 编译Server
$(SERVER_TARGET): $(SERVER_SRC) common.h
	$(CC) $(CFLAGS) -o $@ $<

# 清理目标：删除编译生成的文件
clean:
	rm -f $(TARGETS) *.o data.txt

# .PHONY 声明伪目标，防止与同名文件冲突
.PHONY: all clean