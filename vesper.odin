package main

import "core:fmt"
import "cli"
import "network"
import "base:runtime"

main :: proc() {
	// Because I have the memory of a goldfish, to run everything, odin run . -- test -c
	// cli.parse_args()
	// network.startup()
	dg: network.Datagram(network.TestingDatagram)
	dg.body.message = "hello, world"
	network.build_datagram(dg)	

	fmt.println("# struct_field_tags");
	Foo :: struct {
		x: int    `tag1`,
		y: string `tag2`,
		z: bool, // no tag
	}
	f: Foo;
	ti := runtime.type_info_base(type_info_of(Foo));
	s := ti.variant.(runtime.Type_Info_Struct);
	fmt.println(s);
	// for i in s.names {
	// 	if tag := s.tags[i]; tag != "" {
	// 		fmt.printf("\t%s: %T `%s`,\n", s.names[i], s.types[i], tag);
	// 	} else {
	// 		fmt.printf("\t%s: %T,\n", s.names[i], s.types[i]);
	// 	}
	// }
	// fmt.println("}");
}

