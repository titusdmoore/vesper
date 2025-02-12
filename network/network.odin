package network 
// Server allows for a persistent track of files that need to be transferred. This allows us to resolve if nodes are offline when files are changed
import "core:fmt"
import "core:net"
import "core:strings"
// Move these to a when
// import "core:sys/linux"
import "core:sys/windows"

PORT :: 2119
BUF_SIZE :: 1024

verify_and_update_hosts :: proc() {

}

handle_verify_request :: proc() {}

get_sockname :: proc(socket: net.UDP_Socket) {
    #partial switch ODIN_OS {
        case .Windows:
            fmt.println("This is inside the windows version")
            addr: windows.SOCKADDR_STORAGE_LH
            addr_size: i32
            windows.getsockname(transmute(windows.SOCKET)socket, &addr, &addr_size)
            fmt.println(addr)
        case .Linux:
            linux.getsockname() 
    }
}

startup :: proc() {
    addr_any := net.parse_address("0.0.0.0")
    // We may want dynamic ports
    skt, net_err := net.make_bound_udp_socket(addr_any, PORT); if net_err != nil {
        fmt.println("Unable to bind on UDP Socket")
    }
    defer net.close(skt)

    // Get sockname for ip logging into config
    get_sockname(skt)

    full_message := ""
    buf := make([]u8, BUF_SIZE)
    for {
        // This loop handles a single request, repeatedly reading until message is done
        for {
            read_size, sending_skt, net_err := net.recv_udp(skt, buf); if net_err != nil {
                fmt.println("Unable to receive UDP on addr")
                return
            }

            strings.concatenate({full_message, transmute(string)buf})

            if (read_size < BUF_SIZE) {
                break
            }
        }
    }
}

server :: proc() {
    fmt.println("Welcome to the Vesper File Synchronization Service!")

    host_skt, hc_err := net.make_bound_udp_socket(net.IP4_Loopback, PORT); if hc_err != nil {
        fmt.println("Unable to connect to host addr")
        return
    }
    defer net.close(host_skt)

    full_message := ""
    buf := make([]u8, BUF_SIZE)
    for {
        read_size, sending_skt, net_err := net.recv_udp(host_skt, buf); if net_err != nil {
            fmt.println("Unable to receive UDP on addr")
            return
        }

        fmt.println("Hello, World!")

        strings.concatenate({full_message, transmute(string)buf})

        if (read_size < BUF_SIZE) {
            break
        }
    }

    fmt.println(full_message)
}