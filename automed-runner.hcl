job "automate-runner" {
  datacenters =  ["production"]
  namespace = "default"
  
  
				spread {
					attribute = "${meta.node_type}"
					weight    = 100
					  target "stateful" {
						percent = 0
					  }
					  target "stateless" {
						percent = 100
					  }
				  }
				
  update {
			max_parallel      = 1
			health_check      = "checks"
			min_healthy_time  = "10s"
			healthy_deadline  = "5m"
		  }
  group "automate-runner" {
	
		constraint {
			operator  = "distinct_hosts"
			value     = "true"
		}
    count = 1
	
			scaling {
				enabled = true
				min = 1
				max = 10
		
				policy {
				  
				  cooldown = "5m"
				  evaluation_interval = "1m"
		
				  check "avg_cpu" {
					source = "prometheus"
					query = "(avg(nomad_client_allocs_cpu_total_ticks{exported_job='automate-runner',task_group='automate-runner'}) by (task,task_group,namespace) / avg(nomad_client_allocs_cpu_allocated{exported_job='automate-runner',task_group='automate-runner'}) by (task,task_group,namespace)) * 100 "
					query_window = "5m"
					strategy "target-value" {
					  target = 80
					}
		
				  }
				  check "avg_memory" {
					source = "prometheus"
					query = "(avg(nomad_client_allocs_memory_usage{exported_job='automate-runner',task_group='automate-runner'}) by (task,task_group,namespace) / avg(nomad_client_allocs_memory_allocated{exported_job='automate-runner',task_group='automate-runner'}) by (task,task_group,namespace)) * 100"
					query_window = "5m"
					strategy "target-value" {
					  target = 80
					}
				  }
				}
			  }
			
    
    network {
	  dns {
		servers = ["172.x.x.x"]
	  }
      port "automate-runner" { 
      	to = 8080
      	
      }
       
       
    }
    task "automate-runner" {
      driver = "docker"
	  kill_timeout = "15s"
	  shutdown_delay = "15s"
      
      template {
        data          = <<EOH
        AWS_ACCESS_KEY_ID=
AWS_DEFAULT_REGION=
AWS_SECRET_ACCESS_KEY=
BITBUCKET_TAG=
[DEBUG] GetToken Invoked
        EOH
        destination   = ".env"
        env           = true
      }
      
      env {
        REPO = "automate-runner"
        BUILDNUMBER = "62"
        BITBUCKET_TAG = "stg-runner-v1.0.43"
        BITBUCKET_COMMIT = "xxxxx"
      }
      config {
        image = "dkr.ecr.amazonaws.com/automate-runner:stg-runner-v1.0.43"
        
    ports = ["automate-runner"]
    
        force_pull = true
        
      }
      resources {
        cpu    = 256
        memory = 1024
      }
	  # %{Lifecyle}s
	  meta {
	REPO_SRC = "http/"
	PIC = "-"
	COMMIT_AUTHOR = "Author: Chandra Febrian"
	S3_HCL = "hcl/automate-runner.nomad"
	APP_HOST = "[automate-runner.service.consul]"
  }
    }
    service {
      name = "automate-runner"
      port = "automate-runner"
      tags = [
      	"traefik.enable=true",
	"traefik.http.routers.automate-runner.rule=Host(\"automate-runner.service.consul\") || Host(\"automate-runner.service.consul\") ",
      ]
	  
      check {
        port        = "automate-runner"
        type        = "tcp"
        interval    = "10s"
        timeout     = "10s"
      }
	  
	  
    }
  }
}