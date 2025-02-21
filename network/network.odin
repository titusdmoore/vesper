package network
// Server allows for a persistent track of files that need to be transferred. This allows us to resolve if nodes are offline when files are changed
import "core:bytes"
import "core:fmt"
import "core:mem"
import "core:net"
import "core:strings"
import "sockets"

PORT :: 2119
BUF_SIZE :: 1024

verify_and_update_hosts :: proc() {}
handle_verify_request :: proc() {}
handle_test_request :: proc(message_slice: []u8, header: ^Header, remote_skt: net.Endpoint) {
	test_dg, message := try_parse_test_request(message_slice)
	fmt.printfln("Recieved test message from remote: %v", transmute(string)message)
	fmt.println(test_dg)
}

handle_request :: proc(message_slice: []u8, remote_socket: net.Endpoint) {
	fmt.printfln("Recieved %v bytes with message", len(message_slice))
	header := transmute(^Header)bytes.ptr_from_bytes(message_slice)

	switch header.type {
	case .DiscoverHost:
	case .Heartbeat:
	case .HostSyncReq:
	case .HostSyncRes:
	case .Test:
		handle_test_request(message_slice, header, remote_socket)
	}
}

startup :: proc(initiate: bool, remote: net.Address) {
	addr_any := net.parse_address("0.0.0.0")
	// We may want dynamic ports
	skt, net_err := net.make_bound_udp_socket(addr_any, PORT);if net_err != nil {
		fmt.println("Unable to bind on UDP Socket")
	}
	defer net.close(skt)

	// Get sockname for ip logging into config
	sockets.get_sockname(skt)

	if initiate {
		ep := net.Endpoint {
			address = remote,
			port    = PORT,
		}

		dg: Datagram(TestingDatagram)
		message := "Hello from Host"
		body_struct := TestingDatagram {
			message_size = len(message),
			respond      = true,
		}

		dg.header = Header {
			// TODO: Covert over to default value
			magic_number   = 0xDCCC,
			version        = 1,
			type           = DatagramType.Test,
			source_ip      = [8]u8{1, 1, 1, 1, 0, 0, 0, 0},
			source_port    = PORT,
			inet_version   = INET_Version.AF_INET,
			payload_length = len(mem.any_to_bytes(body_struct)) + len(message),
		}
		dg.body = body_struct
		dg_bytes := build_datagram(dg, transmute([]u8)message)
		fmt.println(dg_bytes)
		fmt.println(parse_bytes(dg_bytes, Datagram(TestingDatagram)))

		written, send_err := net.send_udp(skt, dg_bytes, ep);if send_err != nil {
			fmt.println("Unable to send message to Endpoint:", ep)
			return
		}
		fmt.printfln("Wrote %v bytes to endpoint", written)
	}

	buf := make([]u8, BUF_SIZE)
	defer delete(buf)

	for {
		message: [dynamic]u8
		defer delete(message)

		// This loop handles a single request, repeatedly reading until message is done
		send_skt: net.Endpoint
		for {
			read_size, sending_skt, net_err := net.recv_udp(skt, buf);if net_err != nil {
				fmt.println("Unable to receive UDP on addr")
				return
			}

			// Note for future reference, we need to specify size of read buffer otherwise we may get bad data since we don't zero.
			append(&message, ..buf[:read_size])

			if (read_size < BUF_SIZE) {
				sending_skt = sending_skt
				break
			}
		}

		handle_request(message[:], send_skt)
	}
}

server :: proc() {
	fmt.println("Welcome to the Vesper File Synchronization Service!")

	host_skt, hc_err := net.make_bound_udp_socket(net.IP4_Loopback, PORT);if hc_err != nil {
		fmt.println("Unable to connect to host addr")
		return
	}
	defer net.close(host_skt)

	full_message := ""
	buf := make([]u8, BUF_SIZE)
	for {
		read_size, sending_skt, net_err := net.recv_udp(host_skt, buf);if net_err != nil {
			fmt.println("Unable to receive UDP on addr")
			return
		}

		fmt.println("Hello, World!")

		strings.concatenate({full_message, transmute(string)buf})

		if (read_size < BUF_SIZE) {
			break
		}
	}

	fmt.println(full_message)
}
