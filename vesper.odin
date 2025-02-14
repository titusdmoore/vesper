package main

import "core:fmt"
import "cli"
import "network"
import "base:runtime"
import "core:mem"
import "core:bytes"

main :: proc() {
	// Because I have the memory of a goldfish, to run everything, odin run . -- test -c
	// cli.parse_args()
	// network.startup()
	dg: network.Datagram(network.TestingDatagram)
	dg.header = network.Header {
		version = 1,
		type = network.DatagramType.Test,
		source_ip = [8]u8{1, 1, 1, 1, 0, 0, 0, 0},
		source_port = network.PORT,
		inet_version = network.INET_Version.AF_INET,
		payload_length = len(mem.any_to_bytes(dg.body))
	}
	dg.body.message = "hello, world"
	dg_bytes := network.build_datagram(dg)	
	fmt.println(dg_bytes)
	fmt.println(len(dg_bytes))
	fmt.println(size_of(network.Datagram(network.TestingDatagram)))
	// fmt.println(transmute([]u8)dg)
	test_dg := transmute(^network.Datagram(network.TestingDatagram))bytes.ptr_from_bytes(dg_bytes)
	fmt.println(test_dg^)
	fmt.println(size_of(network.TestingDatagram))
	// header_len := size_of(network.Header)
	// header_bytes := bytes[:header_len]
	// rebuilt_header := transmute(network.Header)header_bytes[:]
}

