package network

import "base:runtime"
import "core:bytes"
import "core:fmt"
import "core:mem"

DatagramType :: enum u8 {
	DiscoverHost = 0x01,
	HostSyncReq  = 0x02,
	HostSyncRes  = 0x03,
	Heartbeat    = 0x04,
	Test         = 0xff,
}

INET_Version :: enum u8 {
	AF_INET  = 4,
	AF_INET6 = 6,
}

Header :: struct #packed {
	magic_number:   u16 `vesper-value: "0xDCCC"`,
	version:        u8,
	type:           DatagramType,
	source_ip:      [8]u8,
	source_port:    u16,
	inet_version:   INET_Version,
	payload_length: uint,
}

Datagram :: struct($T: typeid) #packed {
	using header: Header,
	body:         T,
}

TestingDatagram :: struct #packed {
	message_size: uint,
	respond:      bool,
}

// Process as I plan it. 
InitializeFileTransferDatagram :: struct #packed {
	file_name_size: uint,
	expiration:     uint,
	file_size:      uint,
	transfer_id:    u32,
	checksum:       [256]u8,
	packet_count:   uint,
}

FileTransferPacketDatagram :: struct #packed {
	transfer_id:          u32,
	packet_size:          uint,
	file_packet_order_id: uint,
}

DiscoverHost :: struct {
	// Host Resolved indicates whether this is the response message, with the host value being meaningful
	host_resolved: bool,
	resolved_host: [8]u8,
}

build_datagram :: proc(datagram: $T/Datagram, additional_bytes: ..[]u8) -> []u8 {
	full_message: [dynamic]u8
	append(&full_message, ..mem.any_to_bytes(datagram))

	for bytes in additional_bytes {
		append(&full_message, ..bytes)
	}

	return full_message[:]
}

try_parse_test_request :: proc(raw_bytes: []u8) -> (^Datagram(TestingDatagram), []u8) {
	dg := transmute(^Datagram(TestingDatagram))bytes.ptr_from_bytes(raw_bytes)

	return dg, raw_bytes[size_of(Datagram(TestingDatagram)):][:dg.body.message_size]
}

parse_bytes :: proc(datagram_bytes: []u8, $T: typeid) -> ^T {
	/* As I thought this through, I am not sure I need to really do anything with the header since 
    the intended call of this function would be in a message recieved handler, which would need 
    to parse the header there and send me a type. If I can't match to type, error out */

	// Get header
	// Parse header for request type
	// Get Datagram from request type
	// Return Datagram


	// As a dump implementation with zero safe-guards
	return transmute(^T)bytes.ptr_from_bytes(datagram_bytes)
}

// serialize_bytes_to_datagram :: proc()
