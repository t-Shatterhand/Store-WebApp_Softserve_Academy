[
  {
    "name": "${app_name}-${env}-app",
    "image": "${app_image}",
    "cpu": 256,
    "memory": 512,
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": ${app_port},
        "hostPort": ${app_port}
      }
    ]
  }
]