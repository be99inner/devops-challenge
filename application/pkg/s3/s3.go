package s3

import (
	"bytes"
	"io"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
)

type Client struct {
	s3Client *s3.S3
	bucket   string
}

func NewClient(endpoint, region, accessKey, secretKey, bucket string) (*Client, error) {
	config := &aws.Config{
		Region:           aws.String(region),
		Endpoint:         aws.String(endpoint),
		S3ForcePathStyle: aws.Bool(true),
	}

	// Use static credentials if provided, otherwise rely on default AWS credential chain (IAM roles, env vars, etc.)
	if accessKey != "" && secretKey != "" {
		config.Credentials = credentials.NewStaticCredentials(accessKey, secretKey, "")
	}

	sess, err := session.NewSession(config)
	if err != nil {
		return nil, err
	}
	return &Client{
		s3Client: s3.New(sess),
		bucket:   bucket,
	}, nil
}

func (c *Client) ListFiles() ([]string, error) {
	input := &s3.ListObjectsInput{
		Bucket: &c.bucket,
	}
	result, err := c.s3Client.ListObjects(input)
	if err != nil {
		return nil, err
	}
	var files []string
	for _, obj := range result.Contents {
		files = append(files, *obj.Key)
	}
	return files, nil
}

func (c *Client) UploadFile(key string, body io.Reader) error {
	data, err := io.ReadAll(body)
	if err != nil {
		return err
	}
	_, err = c.s3Client.PutObject(&s3.PutObjectInput{
		Bucket: &c.bucket,
		Key:    aws.String(key),
		Body:   bytes.NewReader(data),
	})
	return err
}

func (c *Client) DeleteFile(key string) error {
	_, err := c.s3Client.DeleteObject(&s3.DeleteObjectInput{
		Bucket: &c.bucket,
		Key:    &key,
	})
	return err
}

func (c *Client) UploadToBucket(bucket, key string, body io.Reader) error {
	data, err := io.ReadAll(body)
	if err != nil {
		return err
	}
	_, err = c.s3Client.PutObject(&s3.PutObjectInput{
		Bucket: &bucket,
		Key:    aws.String(key),
		Body:   bytes.NewReader(data),
	})
	return err
}
