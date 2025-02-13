package sockets 

import "core:sys/windows"
import "core:net"
import "core:fmt"


get_sockname :: proc(socket: net.UDP_Socket) {
    fmt.println("This is inside the windows version")
    addr: windows.SOCKADDR_STORAGE_LH
    addr_size: i32
    windows.getsockname(transmute(windows.SOCKET)socket, &addr, &addr_size)
    fmt.println(addr)
}