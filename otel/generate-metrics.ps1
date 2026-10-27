$count = 0

Write-Host "Sending demo metrics to OpenTelemetry. Press Ctrl+C to stop."

while ($true) {
    $count++
    $timestamp = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds() * 1000000

    $payload = @{
        resourceMetrics = @(
            @{
                resource = @{
                    attributes = @(
                        @{
                            key = "service.name"
                            value = @{ stringValue = "project3-demo" }
                        }
                    )
                }
                scopeMetrics = @(
                    @{
                        scope = @{ name = "project3-test" }
                        metrics = @(
                            @{
                                name = "project3_test_requests"
                                unit = "{request}"
                                sum = @{
                                    dataPoints = @(
                                        @{
                                            asInt = "$count"
                                            timeUnixNano = "$timestamp"
                                        }
                                    )
                                    aggregationTemporality = "AGGREGATION_TEMPORALITY_CUMULATIVE"
                                    isMonotonic = $true
                                }
                            }
                        )
                    }
                )
            }
        )
    } | ConvertTo-Json -Depth 12

    try {
        Invoke-RestMethod `
            -Uri "http://localhost:4318/v1/metrics" `
            -Method Post `
            -ContentType "application/json" `
            -Body $payload | Out-Null

        Write-Host "$(Get-Date -Format 'HH:mm:ss') Sent demo counter: $count"
    }
    catch {
        Write-Host "Metric submission failed: $($_.Exception.Message)"
    }

    Start-Sleep -Seconds 15
}
