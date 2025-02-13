package network 

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
    magic_number: u16 `0xDCCC`,
    version: u8,
    type: DatagramType,
    source_ip: [8]u8,
    source_port: u16,
    inet_version: INET_Version,
    payload_length: u8,
}

DiscoverHost :: struct {
    // Host Resolved indicates whether this is the response message, with the host value being meaningful
    host_resolved: bool,
    resolved_host: [8]u8,
    using Header,
}