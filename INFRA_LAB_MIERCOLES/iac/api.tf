resource "docker_container" "api" {
  name  = "api-${terraform.workspace}-01"
  image = "lab/api"

   ports {
    internal = "3000"
    external = var.api_port[terraform.workspace]
  }
 networks_advanced {
    name = docker_network.app_network.name
  }
}
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../src/Lambda" 
  output_path = "${path.module}/lambda_function.zip"
}

resource "aws_lambda_function" "mi_lambda" {
  filename      = data.archive_file.lambda_zip.output_path
  function_name = "mi-funcion-lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "Node.handler" 
  runtime       = "nodejs20.x"
}