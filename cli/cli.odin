package cli

import "core:fmt"
import "core:os"
import "core:strings"
import "core:thread"

import "../node"
import "../server"
// Commands
// Add Node
// fails on non-init
// Init
// Creates .vesper dir
// Watch Dir
// Adds path to parent .vesper, fails on non init

Commands :: enum {
	Init,
	WatchDir,
	AddNode,
	UDPTest,
	Invalid,
}

parse_args :: proc() -> bool {
	if len(os.args) < 2 {
		fmt.println("Command Usage: vesper <command-name> <arguments>")
		return false
	}

	cmd, cmd_found := parse_command(os.args[1]); if !cmd_found {
		return false
	}

	#partial switch cmd {
		case .UDPTest:
			test()
		case .Init:
			init()
	}

	return strings.compare(os.args[1], "test") == 0
}

parse_command :: proc(arg_command: string) -> (Commands, bool) {
	switch {
		case strings.compare(arg_command, "init") == 0: 
			return Commands.Init, true
		case strings.compare(arg_command, "watch") == 0: 
			return Commands.WatchDir, true
		case strings.compare(arg_command, "add-node") == 0: 
			return Commands.AddNode, true
		case strings.compare(arg_command, "test") == 0: 
			return Commands.UDPTest, true
		case:
			return Commands.Invalid, false
	}
}

test :: proc() {
	t := thread.create(node.client)
	if len(os.args) >= 3 && strings.compare(os.args[2], "-c") == 0 {
		thread.start(t)
	}

	server.server()

	thread.join(t)
	thread.destroy(t)
}

init :: proc() {

}