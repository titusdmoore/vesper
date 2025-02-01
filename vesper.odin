package main

import "core:fmt"
import "core:os"
import "core:net"

ADDR :: "0.0.0.0"
PORT :: 2119

main :: proc() {
    fmt.println("Welcome to the Vesper File Synchronization Service!")
    host_addr := net.parse_address(ADDR)

    host_conn, hc_err := net.make_bound_udp_socket(host_addr, PORT); if hc_err != nil {
        fmt.println("Unable to connect to host addr")
        return
    }
    defer net.close(host_conn)
    
    for arg in os.args {
        fmt.println(arg)
    }
}