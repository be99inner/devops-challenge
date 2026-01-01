package server

import (
	"application/internal/handlers"
	"application/pkg/s3"
	"github.com/ansrivas/fiberprometheus/v2"
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/logger"
	"github.com/swaggo/fiber-swagger"
	"io"
)

func SetupServer(s3Client *s3.Client, logWriter io.Writer) *fiber.App {
	app := fiber.New()

	// Logger middleware
	app.Use(logger.New(logger.Config{
		Output: logWriter,
	}))

	// Prometheus metrics
	prometheus := fiberprometheus.New("s3-file-manager")
	prometheus.RegisterAt(app, "/metrics")
	app.Use(prometheus.Middleware)

	// Handlers
	fileHandler := handlers.NewFileHandler(s3Client)

	// Routes
	app.Get("/files", fileHandler.ListFiles)
	app.Post("/upload", fileHandler.UploadFile)
	app.Delete("/files/:key", fileHandler.DeleteFile)
	app.Get("/health", func(c *fiber.Ctx) error {
		return c.SendString("OK")
	})

	// Swagger
	app.Get("/swagger/*", fiberSwagger.WrapHandler)

	return app
}
