#include <stdio.h>
#include <stdbool.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <netdb.h>
#include <sys/types.h> 
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <iso646.h>

#define BUFSIZE 1068
#define stdout  __stdoutp

typedef struct dgram {
    uint8_t color;
    uint32_t magic1;
    char name[32];
    uint32_t magic2;
    char msg[1024];
} dgram; 

typedef struct client {
	struct sockaddr_in sockaddr;
    int id;
} client;

void error(char *msg) {
  perror(msg);
  exit(1);
}

char * getcolor_metasymb(uint8_t color){
    switch (color) {
    case 0:
        return "\033[30m";
    case 1:
        return "\033[31m";
    case 2:
        return "\033[32m";
    case 3:
        return "\033[33m";
    case 4:
        return "\033[34m";
    case 5:
        return "\033[35m";
    case 6:
        return "\033[36m";
    case 7:
        return "\033[37m";
    default:
        return "\033[0m";
    }
}

