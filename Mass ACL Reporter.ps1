# Active Directory module import
Import-Module ActiveDirectory

# DC name and root OU
$domainController = "DC=guler,DC=com"
$rootOU = Get-ADOrganizationalUnit -Filter * -SearchBase $domainController

# HTML rapor dosyası oluştur
$htmlReportPath = "C:\AD_ACL_Rapor.html"
$htmlReportContent = "<html><head><title>Active Directory ACL-ACE Report</title></head><body>"


# Başlık
$htmlReportContent += "<h2># All Domain OU Mass ACL-ACE Reporter:📜</h2>"
# Ana domain ACL bilgilerini rapora ekleyin
$htmlReportContent += "<h2># | TheGuler0x | 🐝</h2>"

# Ana domain ACL al
$domainACL = dsacls $domainController

$reportDateTime = Get-Date
$computerName = $env:COMPUTERNAME
$domainName = ([System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()).Name

$htmlReportContent += "<p style='color: blue '>Generated: $reportDateTime</p>"
$htmlReportContent += "<p style='color: blue '>Host: $computerName</p>"
$htmlReportContent += "<p style='color: red '>Etki Alanı: $domainName</p>"


# Ana domain name
$htmlReportContent += "<h2><font color='green'>#Main Domain: $domainController</font></h2>"

$domainACL -split "`r`n" | ForEach-Object {
    $htmlReportContent += "<pre>$_</pre>"
}

# Tüm OU'ları işleyin
foreach ($ou in $rootOU) {
    $ouDN = $ou.DistinguishedName
    $ouName = $ou.Name
    $ouACL = dsacls "$ouDN"

    # OU başlığı (sarı renkle vurgulandı)
    $htmlReportContent += "<h2><font color='green'>#OU: $ouName</font></h2>"

    # dsacls çıktısını satır satır ekleyin
    $ouACL -split "`r`n" | ForEach-Object {
        $htmlReportContent += "<pre>$_</pre>"
    }

    # Özel işaretleme ekleyin
    $htmlReportContent += "<p style='color: red; font-weight: bold;'>📃📃📃📃📃📃📃📃📃📃📃📃📃📃📃📃📃📃📃📃📃📃📃📃📃📃📃</p>"
}

# HTML raporunu kapat
$htmlReportContent += "</body></html>"
$htmlReportContent | Out-File -FilePath $htmlReportPath
