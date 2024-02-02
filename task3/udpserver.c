#include "header.h"

int main(int argc, char **argv) {
    int clients_count = 0;
    bool k_flag = false;
    int sockfd;
    int portno; 
    struct sockaddr_in serveraddr;
    struct sockaddr_in clientaddr; 
    int addrlen = sizeof(clientaddr); 
    char *hostaddrp; 
    int hostaddrport;
    int optval = 1; 
    int n; 
    int current_id;
    dgram message;

    client* clients; /* Array with clients of this session */
    clients = (client*) malloc(100 * sizeof(client));

    if (argc != 2) {
        fprintf(stderr, "usage: %s <port>\n", argv[0]);
        exit(1);
    }
    portno = atoi(argv[1]);
    
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) 
        error("ERROR opening socket");
    
    memset(&serveraddr, 0, sizeof(serveraddr)); 
    serveraddr.sin_family = AF_INET;
    serveraddr.sin_addr.s_addr = htonl(INADDR_ANY);
    serveraddr.sin_port = htons((unsigned short)portno);

    if (bind(sockfd, (struct sockaddr *) &serveraddr, sizeof(serveraddr)) < 0) 
        error("ERROR on binding");

    setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, (const void *)&optval , sizeof(int));

    while (true) {
        n = recvfrom(sockfd, &message, BUFSIZE, 0, (struct sockaddr *) &clientaddr, (socklen_t *) &addrlen);
        if (n < 0)
            error("ERROR in recvfrom");

        if ((message.magic1 != 0xffeeddcc) or (message.magic2 != 0x98765432)){
            break;
        }
            
        for(int i = 0; i < 100; i++) { /*Is client known before?*/
            if((clients[i].sockaddr.sin_addr.s_addr == clientaddr.sin_addr.s_addr) and (clients[i].sockaddr.sin_port == clientaddr.sin_port)){
                k_flag = true;
                current_id = clients[i].id;
                break;
            }
        }

        if (k_flag == false){
            clients[clients_count].sockaddr = clientaddr;
            clients[clients_count].id = clients_count;
            current_id = clients_count;
            clients_count++;
        }

        hostaddrp = inet_ntoa(clientaddr.sin_addr);
        if (hostaddrp == NULL)
            error("ERROR on inet_ntoa\n");

        hostaddrport = htons(clientaddr.sin_port);
        if (hostaddrp == NULL)
            error("ERROR on htons\n");
        
        fprintf(stdout, "Server received %d/%d bytes datagram from %s - %s(%i) with message \"%s\"", n, BUFSIZE, message.name, hostaddrp, hostaddrport, message.msg);
        
        if (strlen(message.msg) != 0){
            for(int i = 0; i < clients_count; i++) { 
                    if(clients[i].id != current_id){
                        n = sendto(sockfd, &message, BUFSIZE, 0, (struct sockaddr *) &clients[i], addrlen);
                        if (n <= 0) 
                            error("ERROR in sendto");
                    }
            }
        }
        k_flag = false;
    }
}
