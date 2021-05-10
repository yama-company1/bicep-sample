$locName="<location>"
$pubName="RedHat"
Get-AzVMImagePublisher -Location $locName | Select-Object PublisherName
Get-AzVMImageOffer -Location $locName -PublisherName $pubName
$offerName="RHEL"
Get-AzVMImageSku -Location $locName -PublisherName $pubName -Offer $offerName
$skuName ="83-gen2"
Get-AzVMImage -Location $locName -PublisherName $pubName -Offer $offerName -Sku $skuName
