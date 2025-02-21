package main

import "core:fmt"
import "cli"
import "network"
import "base:runtime"
import "core:mem"
import "core:bytes"

main :: proc() {
	// Because I have the memory of a goldfish, to run everything, odin run . -- test -c
// 	cli.parse_args()
	bytes_raw := []u8{ 204, 220, 1, 255, 1, 1, 1, 1, 0, 0, 0, 0, 71, 8, 4, 0, 17, 0, 0, 0, 0, 0, 0, 0, 253, 225, 68, 0, 0, 0, 0, 0, 15, 0, 0, 0, 0, 0, 0, 0, 1 }
	fmt.println("Len", len(bytes_raw))
	dg := transmute(^network.Datagram(network.TestingDatagram))bytes.ptr_from_bytes(bytes_raw)
	fmt.println(dg)
}

