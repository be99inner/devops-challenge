package main

import (
	"fmt"
	"io"
	"log"
	"os"
	"time"

	"application/config"
	_ "application/docs"
	"application/internal/server"
	"application/pkg/s3"
)

// @title S3 File Manager API
// @version 1.0
// @description A simple API to manage files in S3/Minio bucket
// @host localhost:3000
// @BasePath /

func main() {
	cfg := config.Load()

	s3Client, err := s3.NewClient(cfg.S3Endpoint, cfg.S3Region, cfg.S3AccessKey, cfg.S3SecretKey, cfg.Bucket)
	if err != nil {
		log.Fatal(err)
	}

	// Create log file
	logFileName := fmt.Sprintf("app-%s.log", time.Now().Format("20060102-150405"))
	logFile, err := os.Create(logFileName)
	if err != nil {
		log.Fatal(err)
	}
	defer logFile.Close()

	// Set log to write to both stdout and file
	logWriter := io.MultiWriter(os.Stdout, logFile)
	log.SetOutput(logWriter)

	// Upload log file to S3 on exit
	defer func() {
		logFile.Seek(0, 0)
		err := s3Client.UploadToBucket(cfg.LogBucket, logFileName, logFile)
		if err != nil {
			log.Printf("Error uploading log to S3: %v", err)
		} else {
			log.Printf("Log uploaded to S3 bucket %s", cfg.LogBucket)
		}
	}()

	app := server.SetupServer(s3Client, logWriter)

	log.Printf("Server starting on %s", cfg.Port)
	log.Fatal(app.Listen(":" + cfg.Port))
}
