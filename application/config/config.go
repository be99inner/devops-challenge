package config

import (
	"github.com/kelseyhightower/envconfig"
)

type Config struct {
	S3Endpoint  string `envconfig:"S3_ENDPOINT" default:"http://localhost:9000"`
	S3Region    string `envconfig:"S3_REGION" default:"us-east-1"`
	S3AccessKey string `envconfig:"S3_ACCESS_KEY" default:""`
	S3SecretKey string `envconfig:"S3_SECRET_KEY" default:""`
	Bucket      string `envconfig:"BUCKET" default:"test-bucket"`
	LogBucket   string `envconfig:"LOG_BUCKET" default:"log-bucket"`
	Port        string `envconfig:"PORT" default:"3000"`
}

func Load() *Config {
	var cfg Config
	envconfig.Process("", &cfg)
	return &cfg
}
