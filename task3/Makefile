CC = gcc
CFLAGS = -Wall -pedantic 
BIN = udpserver.exe udpclient.exe

all: clean $(BIN)

%.exe: %.c
	@echo "Building $@...."
	@$(CC) $(CFLAGS) -o $@ $<

clean:
	@echo "Cleaning..."
	@rm -fv *.exe
