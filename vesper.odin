package main

import "core:fmt"
import "core:os"

main :: proc() {
    fmt.println("Welcome to the Vesper File Synchronization Service!")

    for arg in os.args {
        fmt.println(arg)
    }
}