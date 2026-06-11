resource "docker_image" "mysql" {
  name = "mysql:8.0"
}

resource "docker_container" "db" {
  name  = "db"
  image = docker_image.mysql.image_id

  ports {
    internal = "3306"
    external = var.db_port[terraform.workspace]
  }

  env = [
    "MYSQL_ROOT_PASSWORD=Waldorojas_13",
  ]

  networks_advanced {
    name = docker_network.app_network.name
  }
}