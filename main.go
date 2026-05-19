package main

import (
	"flag"
	"fmt"
	"log"

	"github.com/gofiber/fiber/v3"
	"github.com/jessevdk/go-flags"
)

type Option struct {
	Port string `short:"p" long:"port" default:"3000"`
}

func green(str string) string {
	return fmt.Sprintf("\x1b[32m%s\x1b[0m\n", str)
}

func main() {
	var opt Option
	_, err := flags.Parse(&opt)
	if err != nil {
		flag.PrintDefaults()
		return
	}

	// Port
	port := opt.Port

	// Initialize a new Fiber app
	app := fiber.New()

	// Define a route for the GET method on the root path '/'
	app.Get("/", func(c fiber.Ctx) error {
		// Send a string response to the client
		return c.SendString("Hello, Go Web 👋!")
	})

	// Start the server
	fmt.Printf("Go Web listening on %s", green(port))
	log.Fatal(app.Listen("0.0.0.0:"+port, fiber.ListenConfig{
		DisableStartupMessage: true,
	}))
}
