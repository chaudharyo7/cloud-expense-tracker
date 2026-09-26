resource "aws_cloudwatch_dashboard" "expense_dashboard" {
  dashboard_name = "expense-tracker-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      # Row 1: Lambda Metrics
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/Lambda", "Invocations", "FunctionName", aws_lambda_function.expense_lambda.function_name, { stat = "Sum", color = "#2ca02c", label = "Invocations" }],
            [".", "Errors", ".", ".", { stat = "Sum", color = "#d62728", label = "Errors" }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "Lambda - Invocations & Errors"
          period  = 300
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/Lambda", "Duration", "FunctionName", aws_lambda_function.expense_lambda.function_name, { stat = "Average", color = "#1f77b4", label = "Avg Duration (ms)" }],
            [".", "Duration", ".", ".", { stat = "p95", color = "#aec7e8", label = "p95 Duration (ms)" }],
            [".", "Throttles", ".", ".", { stat = "Sum", color = "#ff7f0e", yAxis = "right", label = "Throttles" }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "Lambda - Duration & Throttles"
          period  = 300
        }
      },

      # Row 2: API Gateway Metrics
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApiGateway", "Count", "ApiId", aws_apigatewayv2_api.expense_api.id, { stat = "Sum", color = "#1f77b4", label = "Request Count" }],
            [".", "4xx", ".", ".", { stat = "Sum", color = "#ff7f0e", label = "4xx Client Errors" }],
            [".", "5xx", ".", ".", { stat = "Sum", color = "#d62728", label = "5xx Server Errors" }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "API Gateway - Requests & Errors"
          period  = 300
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApiGateway", "Latency", "ApiId", aws_apigatewayv2_api.expense_api.id, { stat = "Average", color = "#1f77b4", label = "Avg Latency (ms)" }],
            [".", "Latency", ".", ".", { stat = "p95", color = "#aec7e8", label = "p95 Latency (ms)" }],
            [".", "IntegrationLatency", ".", ".", { stat = "Average", color = "#2ca02c", label = "Integration Latency (ms)" }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "API Gateway - Latency"
          period  = 300
        }
      },

      # Row 3: Application Load Balancer Metrics
      {
        type   = "metric"
        x      = 0
        y      = 12
        width  = 8
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", aws_lb.expense_alb.arn_suffix, { stat = "Sum", color = "#1f77b4", label = "ALB Requests" }],
            [".", "TargetResponseTime", ".", ".", { stat = "Average", color = "#ff7f0e", yAxis = "right", label = "Target Response Time (s)" }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "ALB - Traffic & Target Response Time"
          period  = 300
        }
      },
      {
        type   = "metric"
        x      = 8
        y      = 12
        width  = 8
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "HTTPCode_Target_2XX_Count", "LoadBalancer", aws_lb.expense_alb.arn_suffix, { stat = "Sum", color = "#2ca02c", label = "Target 2XX" }],
            [".", "HTTPCode_Target_4XX_Count", ".", ".", { stat = "Sum", color = "#ff7f0e", label = "Target 4XX" }],
            [".", "HTTPCode_Target_5XX_Count", ".", ".", { stat = "Sum", color = "#d62728", label = "Target 5XX" }],
            [".", "HTTPCode_ELB_5XX_Count", ".", ".", { stat = "Sum", color = "#9467bd", label = "ELB 5XX" }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "ALB - HTTP Status Codes"
          period  = 300
        }
      },
      {
        type   = "metric"
        x      = 16
        y      = 12
        width  = 8
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "HealthyHostCount", "TargetGroup", aws_lb_target_group.expense_target_group_frontend.arn_suffix, "LoadBalancer", aws_lb.expense_alb.arn_suffix, { stat = "Average", color = "#2ca02c", label = "Frontend Healthy" }],
            [".", "UnHealthyHostCount", ".", ".", ".", ".", { stat = "Average", color = "#d62728", label = "Frontend Unhealthy" }],
            [".", "HealthyHostCount", "TargetGroup", aws_lb_target_group.expense_target_group_backend.arn_suffix, "LoadBalancer", aws_lb.expense_alb.arn_suffix, { stat = "Average", color = "#1f77b4", label = "Backend Healthy" }],
            [".", "UnHealthyHostCount", ".", ".", ".", ".", { stat = "Average", color = "#e377c2", label = "Backend Unhealthy" }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "ALB - Target Group Host Health"
          period  = 60
        }
      },

      # Row 4: EC2 CPU Utilization
      {
        type   = "metric"
        x      = 0
        y      = 18
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", aws_instance.frontend_1.id, { stat = "Average", color = "#1f77b4", label = "frontend-1" }],
            [".", ".", ".", aws_instance.frontend_2.id, { stat = "Average", color = "#aec7e8", label = "frontend-2" }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "EC2 - Frontend CPU Utilization (%)"
          period  = 300
          yAxis = {
            left = {
              min = 0
              max = 100
            }
          }
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 18
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", aws_instance.backend_1.id, { stat = "Average", color = "#2ca02c", label = "backend-1" }],
            [".", ".", ".", aws_instance.backend_2.id, { stat = "Average", color = "#98df8a", label = "backend-2" }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "EC2 - Backend CPU Utilization (%)"
          period  = 300
          yAxis = {
            left = {
              min = 0
              max = 100
            }
          }
        }
      }
    ]
  })
}
