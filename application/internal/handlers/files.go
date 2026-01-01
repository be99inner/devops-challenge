package handlers

import (
	"application/pkg/s3"
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/log"
)

type FileHandler struct {
	s3Client *s3.Client
}

func NewFileHandler(s3Client *s3.Client) *FileHandler {
	return &FileHandler{s3Client: s3Client}
}

// ListFiles handles GET /files
// @Summary List files in bucket
// @Description Get list of all files in the S3 bucket
// @Tags files
// @Accept json
// @Produce json
// @Success 200 {object} map[string][]string
// @Router /files [get]
func (h *FileHandler) ListFiles(c *fiber.Ctx) error {
	log.Info("Listing files from bucket")
	files, err := h.s3Client.ListFiles()
	if err != nil {
		log.Errorf("Error listing files: %v", err)
		return c.Status(500).SendString(err.Error())
	}
	log.Infof("Successfully listed %d files", len(files))
	return c.JSON(fiber.Map{"files": files})
}

// UploadFile handles POST /upload
// @Summary Upload file to bucket
// @Description Upload a file to the S3 bucket
// @Tags files
// @Accept multipart/form-data
// @Param file formData file true "File to upload"
// @Produce json
// @Success 200 {string} string "Uploaded"
// @Router /upload [post]
func (h *FileHandler) UploadFile(c *fiber.Ctx) error {
	file, err := c.FormFile("file")
	if err != nil {
		log.Errorf("Error getting file from form: %v", err)
		return c.Status(400).SendString("File required")
	}
	log.Infof("Uploading file: %s", file.Filename)
	src, err := file.Open()
	if err != nil {
		log.Errorf("Error opening file: %v", err)
		return c.Status(500).SendString(err.Error())
	}
	defer src.Close()
	err = h.s3Client.UploadFile(file.Filename, src)
	if err != nil {
		log.Errorf("Error uploading file %s: %v", file.Filename, err)
		return c.Status(500).SendString(err.Error())
	}
	log.Infof("Successfully uploaded file: %s", file.Filename)
	return c.SendString("Uploaded")
}

// DeleteFile handles DELETE /files/{key}
// @Summary Delete file from bucket
// @Description Delete a file from the S3 bucket by key
// @Tags files
// @Param key path string true "File key"
// @Produce json
// @Success 200 {string} string "Deleted"
// @Router /files/{key} [delete]
func (h *FileHandler) DeleteFile(c *fiber.Ctx) error {
	key := c.Params("key")
	log.Infof("Deleting file: %s", key)
	err := h.s3Client.DeleteFile(key)
	if err != nil {
		log.Errorf("Error deleting file %s: %v", key, err)
		return c.Status(500).SendString(err.Error())
	}
	log.Infof("Successfully deleted file: %s", key)
	return c.SendString("Deleted")
}
