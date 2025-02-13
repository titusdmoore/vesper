package main

import "core:fmt"
import "cli"
import "network"
import "network/sockets"

main :: proc() {
	// Because I have the memory of a goldfish, to run everything, odin run . -- test -c
	// cli.parse_args()
	network.startup()
	sockets.get_sockname()
}

