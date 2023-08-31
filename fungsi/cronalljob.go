package fungsi

import (
	"log"
	"time"

	"github.com/robfig/cron/v3"
)

func CronAllJob() {
	create_var := cron.New(cron.WithLocation(time.UTC))
	terminate_var := cron.New(cron.WithLocation(time.UTC))

	dis_start, err2 := create_var.AddFunc("CRON_TZ=Asia/Jakarta 00 07 * * 1-5", func() {
		StartInstance()
	})

	dis_stop, err1 := terminate_var.AddFunc("CRON_TZ=Asia/Jakarta 00 19 * * 1-5", func() {
		TerminateInstances()
	})

	if err2 != nil {
		log.Fatal("Failed Create New Instances nya !!: \n", err2, dis_start) //

	}

	if err1 != nil {
		log.Fatal("Failed Terminated nya !: \n", err1, dis_stop) //

	}
	create_var.Start()
	terminate_var.Start()

	select {}
}
