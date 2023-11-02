# Active Directory module import
Import-Module ActiveDirectory

# DC name and root OU
# [DistinguishedName]
$domainController = "DC=guler,DC=com"
$rootOU = Get-ADOrganizationalUnit -Filter * -SearchBase $domainController

# HTML rapor dosyası oluştur
$htmlReportPath = "C:\AD_ACL_Rapor.html"
$htmlReportContent = "<html><head><title>Active Directory ACL Rapor</title></head><body>"

# Başlık ekleyin
$htmlReportContent += "<h1>#All Domain OU Mass ACL Reporter:</h1>"
$htmlReportContent += "<h1>#| TheGuler0x |</h1>"

# All OU Foreach
foreach ($ou in $rootOU) {
    $ouDN = $ou.DistinguishedName
    $ouName = $ou.Name
    $ouACL = dsacls "$ouDN"

    # OU başlığı
    $htmlReportContent += "<h2>OU: $ouName</h2>"

    # dsacls çıktısını satır satır ekleyin
    $ouACL -split "`r`n" | ForEach-Object {
        $htmlReportContent += "<pre>$_</pre>"
    }

    # Her OU sonrasında bir boş satır ekleyin
    $htmlReportContent += "<br>"
}

# HTML raporunu kapat
$htmlReportContent += "</body></html>"
$htmlReportContent | Out-File -FilePath $htmlReportPath

Write-Host "HTML rapor oluşturuldu: $htmlReportPath"