# Get all products
$products = Invoke-RestMethod -Uri "https://instantpick-backend.onrender.com/api/products" -Method Get

$shopId = "698dc943148fdab957c75f4c"

# Update each product
foreach ($product in $products.data) {
    $productId = $product._id
    Write-Host "Updating product: $($product.name)"
    
    $updateBody = @{
        shopId = $shopId
        shopName = "Vivek Shop"
    } | ConvertTo-Json
    
    try {
        $result = Invoke-RestMethod -Uri "https://instantpick-backend.onrender.com/api/products/$productId" -Method Put -Body $updateBody -ContentType "application/json"
        Write-Host "✅ Updated: $($product.name)"
    } catch {
        Write-Host "❌ Failed: $($product.name) - $($_.Exception.Message)"
    }
}

Write-Host "`n✅ All products updated!"
