$body = @{
    name = "Vivek Shop"
    description = "General store selling daily needs and groceries"
    category = "Grocery"
    address = "Main Market, Local Area"
    phone = "9876543210"
    ownerName = "Vivek"
    ownerId = "9876543210"
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri "https://instantpick-backend.onrender.com/api/shops" -Method Post -Body $body -ContentType "application/json"
$response | ConvertTo-Json
