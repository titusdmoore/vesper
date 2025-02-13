package sockets 

import "core:sys/linux"
import "core:net"
import "core:fmt"

get_sockname :: proc(socket: net.UDP_Socket) {}