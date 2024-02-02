#include "header.h"

int main (int argc, char** argv){
	struct sockaddr_in serveraddr;
	char * color_metacymb;
	int n, sockfd, addrlen = sizeof(serveraddr);
	fd_set input_set;
	dgram message, response;
	message.magic1 = 0xffeeddcc; 
	response.magic1 = 0xffeeddcc;
	message.magic2 = 0x98765432;
	response.magic2 = 0x98765432;

	if (argc != 3) {
        fprintf(stderr, "usage: %s <name> <color number>\n", argv[0]);
        exit(1);
    }

    char* cli_name = argv[1];
	message.color = atoi(argv[2]);

	if (strlen(cli_name)>32){
		fprintf(stderr,"client name's max size is 32 characters");
        exit(1);  
	}

	strncpy(message.name, cli_name, 32);

	if ((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0){
		error("error calling socket");
	}
	
	memset(&serveraddr, 0, addrlen); 
	serveraddr.sin_family = AF_INET;
	serveraddr.sin_port = htons(2023);
	serveraddr.sin_addr.s_addr = inet_addr("0.0.0.0");

	while (true){
		FD_ZERO(&input_set);
		FD_SET(0, &input_set);
		FD_SET(sockfd, &input_set);
		
		if (select(FD_SETSIZE,&input_set,NULL,NULL,NULL)<0){
			error("ERROR in select");
		}

		if (FD_ISSET(sockfd, &input_set)){
			n = recvfrom(sockfd, &response, BUFSIZE, 0, (struct sockaddr *) &serveraddr, (socklen_t *) &addrlen);
       		if (n < 0)
            	error("ERROR in recvfrom");
			color_metacymb = getcolor_metasymb(response.color);
			fprintf(stdout, "%s(%s) \033[0m%s",color_metacymb,response.name,response.msg);
		}

		if (FD_ISSET(0, &input_set)){
			fgets(message.msg,BUFSIZE,stdin);
			sendto(sockfd,&message,sizeof(message),0,(struct sockaddr *) &serveraddr, addrlen);
		}
	}

    return 0;
}
