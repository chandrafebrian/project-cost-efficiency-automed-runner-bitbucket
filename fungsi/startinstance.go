package fungsi

import (
	"fmt"
	"log"
	"os/exec"

	"github.com/go-resty/resty/v2"
)

func StartInstance() {
	webhookURL := "yourwebhook-token-slack"

	client := resty.New()

	cmd := exec.Command("bash", "spawninstance.sh")

	output, err := cmd.CombinedOutput()

	if err != nil {
		fmt.Println("Error :", err)
	}

	fmt.Println("Report Create Runner :")
	fmt.Println(string(output))

	response, err := client.R().
		SetHeader("Content-Type", "application/json").
		SetBody(map[string]string{

			"text": "Start the Spotfleet Runner Instances Created Process!\n" + "Succeed!\n" + "link :\n" + "your link service on nomad or kubernetes",
		}).
		Post(webhookURL)

	if err != nil {
		log.Fatalf("Error sending message: %s", err)
	}

	if response.StatusCode() != 200 {
		log.Fatalf("Message Failed., Status code: %d", response.StatusCode())
	}

	fmt.Println("********** Finish Message sent! **********")

}
