# Define the deployment name and namespace
$deploymentName = "sample-nginx"
# Get the list of pods for the deployment
$pods = kubectl get pods -l app=$deploymentName -o jsonpath='{.items[*].metadata.name}'

# Split the pods into an array
$podArray = $pods -split '\s+'

# Define colors for each pod
$colors = @("red", "blue", "green")

# Iterate over each pod
for ($i = 0; $i -lt $podArray.Length; $i++) {
    $podName = $podArray[$i]
    $podNumber = $i + 1
    $color = $colors[$i]

    # Create a temporary index.html file with the custom content
    $tempFile = "temp_index_$i.html"
    $content = "<html><body><h1 style='color:$color;'>Hello From Pod $podNumber</h1></body></html>"
    $content | Out-File -FilePath $tempFile -Encoding utf8

    # Copy the temporary file to the pod
    kubectl cp $tempFile "${podName}:/usr/share/nginx/html/index.html"
    
    # Clean up the temporary file
    Remove-Item $tempFile

    Write-Output "Updated index.html for pod $podName with color $color"
}
