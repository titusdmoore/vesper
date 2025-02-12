package cli

import "core:fmt"
import "core:os"
import "core:strings"
import "core:thread"

import "../node"
import "../network"
// Commands
// Add Node
// fails on non-init
// Init
// Creates .vesper dir
// Watch Dir
// Adds path to parent .vesper, fails on non init

Commands :: enum {
	// Initializes directory with files needs to start tracking other nodes, and files. NOTE: does not track any files yet. Sets up service.
	Init,
	WatchDir,
	AddNode,
	UDPTest,
	Reset,
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
		case .Reset:
			reset()
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
		case strings.compare(arg_command, "reset") == 0: 
			return Commands.Reset, true
		case:
			return Commands.Invalid, false
	}
}

test :: proc() {
	t := thread.create(node.client)
	if len(os.args) >= 3 && strings.compare(os.args[2], "-c") == 0 {
		thread.start(t)
	}

	network.server()

	thread.join(t)
	thread.destroy(t)
}

init :: proc() {
	if !os.is_dir(".vesper") {
		mkdir_err := os.make_directory(".vesper"); if mkdir_err != nil {
			fmt.println("Unable to make dir")
		}
		
		handle, err := os.open(".vesper/hosts", os.O_APPEND); if err != nil {

		}
		defer os.close(handle)

		return
	}

	fmt.println("Directory already setup with vesper")
}

reset :: proc() {
	if os.is_dir(".vesper") {
		os.remove_directory(".vesper")
	}
}