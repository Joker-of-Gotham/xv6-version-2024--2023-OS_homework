# Compiler and flags
CC = gcc
# CFLAGS: -Wall (warnings), -Wextra (more warnings), -g (debug info), -pthread (for pthreads)
CFLAGS = -Wall -Wextra -g -pthread
# LDFLAGS: -lm (for math library, log function), -pthread (sometimes needed for linking pthreads too)
LDFLAGS = -lm -pthread

# Executable targets
TARGETS = client server

# Named pipe path (must match in client.c and server.c)
FIFO_PATH = "/tmp/cs_fifo"

# Default target: build all executables
all: $(TARGETS)

# Rule to build the client executable
client: client.c
	$(CC) $(CFLAGS) client.c -o client $(LDFLAGS)

# Rule to build the server executable
server: server.c
	$(CC) $(CFLAGS) server.c -o server $(LDFLAGS)

# Clean target: remove executables and the named pipe
clean:
	rm -f $(TARGETS) $(FIFO_PATH)

# Declare phony targets (targets that don't represent files)
.PHONY: all clean client server