Red/System[
	Title: "socket.reds" 
	Author: "Boleslav Brezovsky" 
	Date: 7-9-2013
	About: "LibC sockets"
]

#include %user.reds 
#include %substring.reds 


#define size_t! 	integer!
#define ssize_t! 	integer!
#define socklen_t! 	integer!

#define IFNAMSIZ        16
#define IFALIASZ        256

;======================================

#define	SOCK_STREAM		1		; stream socket
#define	SOCK_DGRAM		2		; datagram socket
#define	SOCK_RAW		3		; raw-protocol interface
#define	SOCK_RDM		4		; reliably-delivered message
#define	SOCK_SEQPACKET	5		; sequenced packet stream 

; "Socket"-level control message types:

#define	SCM_RIGHTS		01		; rw: access rights (array of int)
#define SCM_CREDENTIALS 02		; rw: struct ucred
#define SCM_SECURITY	03		; rw: security label

ucred!: alias struct! [
	pid 	[integer!]
	uid 	[integer!]
	gid 	[integer!]
]

; Supported address families.
#define AF_UNSPEC		0
#define AF_UNIX			1	; Unix domain sockets 		
#define AF_LOCAL		1	; POSIX name for AF_UNIX	
#define AF_INET			2	; Internet IP Protocol 	
#define AF_AX25			3	; Amateur Radio AX.25 		
#define AF_IPX			4	; Novell IPX 			
#define AF_APPLETALK	5	; AppleTalk DDP 		
#define AF_NETROM		6	; Amateur Radio NET/ROM 	
#define AF_BRIDGE		7	; Multiprotocol bridge 	
#define AF_ATMPVC		8	; ATM PVCs			
#define AF_X25			9	; Reserved for X.25 project 	
#define AF_INET6		10	; IP version 6			
#define AF_ROSE			11	; Amateur Radio X.25 PLP	
#define AF_DECnet		12	; Reserved for DECnet project	
#define AF_NETBEUI		13	; Reserved for 802.2LLC project
#define AF_SECURITY		14	; Security callback pseudo AF 
#define AF_KEY			15  ; PF_KEY key management API 
#define AF_NETLINK		16
#define AF_ROUTE	AF_NETLINK ; Alias to emulate 4.4BSD 
#define AF_PACKET		17	; Packet family		
#define AF_ASH			18	; Ash				
#define AF_ECONET		19	; Acorn Econet			
#define AF_ATMSVC		20	; ATM SVCs			
#define AF_RDS			21	; RDS sockets 			
#define AF_SNA			22	; Linux SNA Project (nutters!) 
#define AF_IRDA			23	; IRDA sockets			
#define AF_PPPOX		24	; PPPoX sockets		
#define AF_WANPIPE		25	; Wanpipe API Sockets 
#define AF_LLC			26	; Linux LLC			
#define AF_CAN			29	; Controller Area Network      
#define AF_TIPC			30	; TIPC sockets			
#define AF_BLUETOOTH	31	; Bluetooth sockets 		
#define AF_IUCV			32	; IUCV sockets			
#define AF_RXRPC		33	; RxRPC sockets 		
#define AF_ISDN			34	; mISDN sockets 		
#define AF_PHONET		35	; Phonet sockets		
#define AF_IEEE802154	36	; IEEE802154 sockets		
#define AF_CAIF			37	; CAIF sockets			
#define AF_ALG			38	; Algorithm sockets		
#define AF_NFC			39	; NFC sockets			
#define AF_MAX			40	; For now.. 

; Protocol families, same as address families. 
#define PF_UNSPEC	AF_UNSPEC
#define PF_UNIX		AF_UNIX
#define PF_LOCAL	AF_LOCAL
#define PF_INET		AF_INET
#define PF_AX25		AF_AX25
#define PF_IPX		AF_IPX
#define PF_APPLETALK	AF_APPLETALK
#define	PF_NETROM	AF_NETROM
#define PF_BRIDGE	AF_BRIDGE
#define PF_ATMPVC	AF_ATMPVC
#define PF_X25		AF_X25
#define PF_INET6	AF_INET6
#define PF_ROSE		AF_ROSE
#define PF_DECnet	AF_DECnet
#define PF_NETBEUI	AF_NETBEUI
#define PF_SECURITY	AF_SECURITY
#define PF_KEY		AF_KEY
#define PF_NETLINK	AF_NETLINK
#define PF_ROUTE	AF_ROUTE
#define PF_PACKET	AF_PACKET
#define PF_ASH		AF_ASH
#define PF_ECONET	AF_ECONET
#define PF_ATMSVC	AF_ATMSVC
#define PF_RDS		AF_RDS
#define PF_SNA		AF_SNA
#define PF_IRDA		AF_IRDA
#define PF_PPPOX	AF_PPPOX
#define PF_WANPIPE	AF_WANPIPE
#define PF_LLC		AF_LLC
#define PF_CAN		AF_CAN
#define PF_TIPC		AF_TIPC
#define PF_BLUETOOTH	AF_BLUETOOTH
#define PF_IUCV		AF_IUCV
#define PF_RXRPC	AF_RXRPC
#define PF_ISDN		AF_ISDN
#define PF_PHONET	AF_PHONET
#define PF_IEEE802154	AF_IEEE802154
#define PF_CAIF		AF_CAIF
#define PF_ALG		AF_ALG
#define PF_NFC		AF_NFC
#define PF_MAX		AF_MAX

; Maximum queue length specifiable by listen.  
#define SOMAXCONN	128

; Flags we can use with send/ and recv. 
;   Added those for 1003.1g not all are supported yet
 
 
#define MSG_OOB			1
#define MSG_PEEK		2
#define MSG_DONTROUTE	4
#define MSG_TRYHARD     4       ; Synonym for MSG_DONTROUTE for DECnet 
#define MSG_CTRUNC		8
#define MSG_PROBE		10h		; Do not send. Only probe path f.e. for MTU 
#define MSG_TRUNC		20h
#define MSG_DONTWAIT	40h		; Nonblocking io		 
#define MSG_EOR         80h		; End of record 
#define MSG_WAITALL		0100h	; Wait for a full request 
#define MSG_FIN         0200h
#define MSG_SYN			0400h
#define MSG_CONFIRM		0800h	; Confirm path validity 
#define MSG_RST			1000h
#define MSG_ERRQUEUE	2000h	; Fetch message from error queue 
#define MSG_NOSIGNAL	4000h	; Do not generate SIGPIPE 
#define MSG_MORE		8000h	; Sender will send more 
#define MSG_WAITFORONE	00010000h	; recvmmsg(): block until 1+ packets avail 
#define MSG_SENDPAGE_NOTLAST 00020000h ; sendpage() internal : not the last page 
#define MSG_EOF         MSG_FIN

#define MSG_CMSG_CLOEXEC 40000000h	; Set close_on_exit for file descriptor received through SCM_RIGHTS 

; TODO: What is this...
#define MSG_CMSG_COMPAT	80000000h	; This message needs 32 bit fixups 

;#define MSG_CMSG_COMPAT	0		; We never have 32 bit fixups 



; Setsockoptions(2) level. Thanks to BSD these must match IPPROTO_xxx 
#define SOL_IP		0
; #define SOL_ICMP	1	No-no-no! Due to Linux :-) we cannot use SOL_ICMP=1 
#define SOL_TCP		6
#define SOL_UDP		17
#define SOL_IPV6	41
#define SOL_ICMPV6	58
#define SOL_SCTP	132
#define SOL_UDPLITE	136     ; UDP-Lite (RFC 3828) 
#define SOL_RAW		255
#define SOL_IPX		256
#define SOL_AX25	257
#define SOL_ATALK	258
#define SOL_NETROM	259
#define SOL_ROSE	260
#define SOL_DECNET	261
#define	SOL_X25		262
#define SOL_PACKET	263
#define SOL_ATM		264	; ATM layer (cell level) 
#define SOL_AAL		265	; ATM Adaption Layer (packet level) 
#define SOL_IRDA    266
#define SOL_NETBEUI	267
#define SOL_LLC		268
#define SOL_DCCP	269
#define SOL_NETLINK	270
#define SOL_TIPC	271
#define SOL_RXRPC	272
#define SOL_PPPOL2TP	273
#define SOL_BLUETOOTH	274
#define SOL_PNPIPE	275
#define SOL_RDS		276
#define SOL_IUCV	277
#define SOL_CAIF	278
#define SOL_ALG		279

; IPX options 
#define IPX_TYPE	1

;======================================
; defines from %netinet/in.h 
;======================================


sockaddr-in!: alias struct! [
	; family 	- short! [2 bytes]
	; port 		- short! [2 bytes]
	; address 	- uint32! [4 bytes]	; it's struct actually 
	; zero 		- c-string! [8 bytes] 
	fake [integer!]
]

sockaddr-in6!: alias struct! [
	fake [integer!]
]


;/* Internet address.  */
;typedef uint32_t in_addr_t;
;struct in_addr
;  {
;    in_addr_t s_addr;
;  };


;struct sockaddr_in {
;    short            sin_family;   // e.g. AF_INET
;    unsigned short   sin_port;     // e.g. htons(3490)
;    struct in_addr   sin_addr;     // see struct in_addr, below
;    char             sin_zero[8];  // zero this if you want to
;};
;
;struct in_addr {
;    unsigned long s_addr;  // load with inet_aton()
;};

;struct sockaddr_in
;  {
;    __SOCKADDR_COMMON (sin_);
;    in_port_t sin_port;			/* Port number.  */
;    struct in_addr sin_addr;		/* Internet address.  */
;
;    /* Pad to size of `struct sockaddr'.  */
;    unsigned char sin_zero[sizeof (struct sockaddr) -
;			   __SOCKADDR_COMMON_SIZE -
;			   sizeof (in_port_t) -
;			   sizeof (struct in_addr)];
;  };

;/* Ditto, for IPv6.  */
;struct sockaddr_in6
;  {
;    __SOCKADDR_COMMON (sin6_);
;    in_port_t sin6_port;	/* Transport layer port # */
;    uint32_t sin6_flowinfo;	/* IPv6 flow information */
;    struct in6_addr sin6_addr;	/* IPv6 address */
;    uint32_t sin6_scope_id;	/* IPv6 scope-id */
;  };


;======================================

short!: alias struct! [
	lsb [byte!]
	msb [byte!]
]

sockaddr!: alias struct! [
	family 		[short!]
	data 		[c-string!]	
]

sockaddr-un!: alias struct! [
	family 		[short!]
	path 		[c-string!]	
]

if-name-index!: alias struct! [
	if-index 	[integer!]
	if-name 	[byte-ptr!]

]

#import [
	LIBC-file cdecl [
; testing stuff
		version: "gnu_get_libc_version" [
			return:			[byte!]
		]
	
		release: "gnu_get_libc_release" [
			return:			[byte!]
		]

; socket opening and closing
		socket: 	"socket" 	[
			namespace	[integer!]
			style		[integer!]
			protocol 	[integer!]
			return:		[integer!]
		]
; TODO: windows-only closesocket
	 	; int shutdown (int socket, int how)
		shutdown:	"shutdown"	[
			socket 		[integer!]
			how 		[integer!]
			return: 	[integer!]
		]
; socket addresses
		; int bind (int socket, struct sockaddr *addr, socklen_t length)
		bind:		"bind"		[
			socket 		[integer!]
			address 	[sockaddr!]
			length 		[socklen_t!]
			return:		[integer!]
		]
		; int getsockname (int socket, struct sockaddr *addr, socklen_t *length-ptr)
		get-socket-name: "getsockname" [
			socket 		[integer!]
			address 	[sockaddr!]
			length 		[int-ptr!]
			return: 	[integer!]
		]
; socket pairs
		; int socketpair (int namespace, int style, int protocol, int filedes[2])
		socketpair:	"socketpair" [
			namespace 	[integer!]
			style 		[integer!]
			protocol 	[integer!]
			filedes1 	[integer!]	; TODO: is it right?
			filedes2 	[integer!]	; TODO: is it right?
			return: 	[integer!]
		]
; socket connections 
		;  int connect (int socket, struct sockaddr *addr, socklen_t length)
		connect:	"connect" 	[
			socket 		[integer!]
			addr 	 	[sockaddr!]
			length 		[socklen_t!] ; TODO: struct sockaddr *addr
			return: 	[integer!]
		]
		; int listen (int socket, int n)
		listen: 	"listen" 	[
			socket 		[integer!]
			n 			[integer!]
			return:		[integer!]
		]
		; int accept (int socket, struct sockaddr *addr, socklen_t *length_ptr)
		accept: 	"accept" 	[
			socket 		[integer!]
			addr 		[sockaddr!]
			length-ptr 	[int-ptr!]
			return: 	[integer!]
		]
; check connected
		; int getpeername (int socket, struct sockaddr *addr, socklen_t *length-ptr)
		get-peer-name: "getpeername" [
			socket 		[integer!]
			addr 		[sockaddr!]
			length-ptr 	[int-ptr!]
			return: 	[integer!]	
		]
; data transfer
		; ssize_t send (int socket, const void *buffer, size_t size, int flags)		
		send:		"send"		[
			socket 		[integer!]
			buffer 		[int-ptr!]
			size 		[size_t!]
			flags 		[integer!]
			return:		[ssize_t!]
		]
		;ssize_t recv (int socket, void *buffer, size_t size, int flags)
		receive:	"recv" 		[
			socket 		[integer!]
			buffer 		[int-ptr!]
			size 		[size_t!]
			flags 		[integer!]
			return: 	[ssize_t!]
		]
; interface naming
		; unsigned int if_nametoindex (const char *ifname)
		if-name-to-index: "if_nametoindex" [
			if-name 	[byte-ptr!]
			return: 	[integer!]
		]
		; char * if_indextoname (unsigned int ifindex, char *ifname)		
		if-index-to-name: "if_indextoname" [
			if-index 	[integer!]
			if-name 	[byte-ptr!]
			return:		[byte-ptr!]
		]
		; struct if_nameindex * if_nameindex (void)
		if-name-index: "if_nameindex" [
			return: 	[if-name-index!]
		]
		; void if_freenameindex (struct if_nameindex *ptr)
		if-free-name-index: "if_freenameindex" [
			if-name-index [if-name-index!]
		]
	]
]


;=========================================
; test 

print ["version: '" as integer! version "': " as integer! release "." newline]

sock: socket PF_LOCAL SOCK_DGRAM 0
print ["sock:" sock newline]

; TODO: move to user.reds ?
ip-to-int: func [
	ip 			[c-string!]
	return: 	[integer!]
	/local
	spl 		[sb-string!]
	ret 		[integer!]
	i 			[integer!]
][
	spl: sb-split ip #"."
	ret: 0
	pointer: as byte-ptr! :ret 
	i: 0
	until [
		i: i + 1
		pointer/i: load-byte sb-pick spl 5 - i
		i = 4
	]
	ret
]

htonl: func [
	"Reverse integer byte order"
	value 		[integer!]
	return: 	[integer!]
	/local 
	ret 		[integer!]
	i 			[integer!]
	j 			[integer!]

][
	ret: 0
	ret-ptr: as byte-ptr! :ret 
	val-ptr: as byte-ptr! :value
	i: 0
	until [
		i: i + 1
		j: 5 - i 
		ret-ptr/i: val-ptr/j
		i = 4
	]
	ret 
]

make-sock-address: func [
	"Create sockaddr-in struct!"
	family 		[integer!]
	port 		[integer!]
	address 	[integer!]	; TODO: change to c-string and use load-ip ?
	return: 	[byte-ptr!]
	/local  
	sockaddr 	[byte-ptr!]
	ip-addr 	[int-ptr!]

][
;	This function returns pointer to fake struct!
;	Current Red/System implementation does not provide some necessary datatypes,
;	but we can easily fake that.
	sockaddr: allocate 16
	; we can safely expect that family is much lower than 256, so let's ignore second byte 
	sockaddr/1: int-to-byte family 
	; Integer! to short! (network byte order) conversion
	sockaddr/3: int-to-byte port /	256
	sockaddr/4: int-to-byte port //	256
	; Set address
	ip-addr: as int-ptr! sockaddr + 5
;	ip-addr/value: htonl address 
	sockaddr
]



make-named-socket: func [
	filename 	[c-string!]
	return: 	[integer!]
	/local 
	name 		[byte-ptr!]	; faked struct!
	sock 		[integer!]
	size 		[size_t!]
	i 			[integer!]
][
	sock: socket PF_LOCAL SOCK_DGRAM 0
	if sock < 0 [
		; TODO: Error handling
		print "socket error^/"
		return -1
	]
	; prepare size: two bytes for short! value and rest is c-string!
	size: 2 + length? filename 
	; name should be struct! but currently we can't have struct with array
	; so we will fake it
	name: allocate size 
	; first two bytes of the struct is short! type of network
	; we don't have short!, so let's continue with faking
	; we only set first byte (LSB - x86 version), there aren't so many network types
	name/1: int-to-byte AF_LOCAL
	; now copy filename to the rest of faked struct
	copy-memory name + 3 as byte-ptr! filename size? filename
	; and finaly we have our fake struct! and can bind socket 
	b: bind sock as sockaddr! name size + 1
	if b < 0 [
		; TODO: error handling
		print "bind error^/"
		return -1
	]

	i: 0
	until [
		i: i + 1
		print [as integer! name/i "."]
		i = size
	]
	print newline 

	sock 
]

make-socket: func [
	port 	[integer!] 	; actually it's uint16_t
	return: [integer!]
	/local
	sock 	[integer!]
][
	sock: socket PF_INET SOCK_STREAM 0
	if sock < 0 [
		; TODO: error handling
		print ["ERROR: creating socket"]
		return -1
	]
	name: make-sock-address AF_INET port 0 ; INADDR_ANY
	b: bind sock as sockaddr! name size? name 
	if b < 0 [
		; TODO: error handling
		print ["ERROR: binding socket"]
		return -1
	]

	0
]

;     int
;     make_socket (uint16_t port)
     {
       int sock;
       struct sockaddr_in name;
     
       /* Create the socket. */
       sock = socket (PF_INET, SOCK_STREAM, 0);
       if (sock < 0)
         {
           perror ("socket");
           exit (EXIT_FAILURE);
         }
     
       /* Give the socket a name. */
       name.sin_family = AF_INET;
       name.sin_port = htons (port);
       name.sin_addr.s_addr = htonl (INADDR_ANY);
       if (bind (sock, (struct sockaddr *) &name, sizeof (name)) < 0)
         {
           perror ("bind");
           exit (EXIT_FAILURE);
         }
     
       return sock;
     }



;-----------------------------------------

sock-ab: make-named-socket "abcd"
sock-re: make-named-socket "RedSystemSocket"
print ["ab:" sock-ab " re:" sock-re newline]


;address: declare sockaddr!
address: as sockaddr! allocate 50
length1: 0
length2: 0
ret1: get-socket-name sock-ab address :length1
ret2: get-socket-name sock-re address :length2

print ["lengths: " length1 ", " length2 newline]

t: as byte-ptr! address 
i: 0
until [
	i: i + 1
	print [as integer! t/i "."]
	i = length2
]
print newline


print [
	"===IP-TO-INT===" newline
	ip-to-int "0.0.0.255" newline
	ip-to-int "0.0.128.255" newline	
	ip-to-int "10.0.0.1" newline
	ip-to-int "192.168.1.1" newline
	"load-byte: " load-byte "65" newline
	"load-byte: " load-byte "48" newline
	"load-byte: " load-byte "56" newline
	"load-int: " load-int "3245" newline
	htonl ip-to-int "10.0.0.1" newline
]