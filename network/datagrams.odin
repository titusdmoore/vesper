package network 

import "core:fmt"
import "base:runtime"

DatagramType :: enum u8 {
    DiscoverHost = 0x01,
    HostSyncReq = 0x02,
    HostSyncRes = 0x03,
    Heartbeat = 0x04,
}

INET_Version :: enum u8 {
    AF_INET = 4,
    AF_INET6 = 6, 
}

Header :: struct {
    magic_number: u16 `vesper-value: "0xDCCC"`,
    version: u8,
    type: DatagramType,
    source_ip: [8]u8,
    source_port: u16,
    inet_version: INET_Version,
    payload_length: u8,
}

Datagram :: struct($T: typeid) {
    using header: Header,

    body: T 
}

TestingDatagram :: struct {
    message: string
}

DiscoverHost :: struct {
    // Host Resolved indicates whether this is the response message, with the host value being meaningful
    host_resolved: bool,
    resolved_host: [8]u8,
}

build_datagram :: proc(datagram: $T/Datagram) -> []u8 {
    fmt.println("Hello, World!")
    s := "hello"
    return transmute([]u8)s
}