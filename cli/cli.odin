package cli 

import "core:os"
import "core:fmt"
import "core:strings"
// Commands
// Add Node
    // fails on non-init
// Init
    // Creates .vesper dir
// Watch Dir
    // Adds path to parent .vesper, fails on non init

parse_args :: proc() -> bool {
    if len(os.args) < 2 {
        fmt.println("Command Usage: vesper <command-name> <arguments> ...")
        return false
    }

    return strings.compare(os.args[1], "test") == 0
}