package main

import "core:thread"
import "core:os"
import "core:strings"
import "cli"
import "server"
import "node"


main :: proc() {
    // Because I have the memory of a goldfish, to run everything, add args -- test -c
    if cli.parse_args() {
        t := thread.create(node.client)
        if len(os.args) >= 3 && strings.compare(os.args[2], "-c") == 0 {
            thread.start(t)
        }

        server.server()

        thread.join(t)
        thread.destroy(t)
    }
}