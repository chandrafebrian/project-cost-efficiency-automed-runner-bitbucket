package fungsi

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/joho/godotenv"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

func StatusChecking() {

	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}

	awskey := os.Getenv("AWS_ACCESS_KEY_ID")
	awsregion := os.Getenv("AWS_DEFAULT_REGION")
	awssecret := os.Getenv("AWS_SECRET_ACCESS_KEY")

	e := echo.New()

	e.Use(middleware.Logger())
	e.Use(middleware.Recover())

	e.GET("/", func(c echo.Context) error {
		return c.HTML(http.StatusOK, "Succeed Connecting !!")

	})

	e.GET("/health", func(c echo.Context) error {
		return c.JSON(http.StatusOK, struct{ Status string }{Status: "OK"})
	})

	httpPort := os.Getenv("PORT")
	if httpPort == "" {
		httpPort = "8080"
	}

	e.Logger.Fatal(e.Start(":" + httpPort))

	fmt.Println(awskey)
	fmt.Println(awsregion)
	fmt.Println(awssecret)
}
