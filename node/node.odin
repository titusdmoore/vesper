package node
// a node is a machine where files are synced to and from.
import "core:thread"
import "core:net"
import "core:strings"
import "core:fmt"
import "core:time"

client :: proc(t: ^thread.Thread) {
    fmt.println("Running client")
    time.sleep(time.Second * 2)
    fmt.println("After")

    client_skt, hc_err := net.make_unbound_udp_socket(net.Address_Family.IP4); if hc_err != nil {
        fmt.println("Unable to connect to client addr")
        return
    }

    addr_string := strings.concatenate({net.to_string(net.IP4_Loopback), ":2119"})

    host_endpoint, success := net.parse_endpoint(addr_string); if !success {
        fmt.println("Unable to parse host endpoint")
        return
    }

    message := "Hello, World"

    _, send_err := net.send_udp(client_skt, transmute([]u8)message, host_endpoint); if send_err != nil {
        fmt.println(send_err)
        return
    }
    fmt.println("Done")
}