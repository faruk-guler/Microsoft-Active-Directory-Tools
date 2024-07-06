# Import Active Directory module
Import-Module ActiveDirectory

# Define variables and Spesific OU
$domainController = "DC=guler,DC=com"
$rootOU = Get-ADOrganizationalUnit -Filter * -SearchBase $domainController
$htmlReportPath = "C:\AD_ACL_Rapor.html"
$reportDateTime = Get-Date
$computerName = $env:COMPUTERNAME
$domainName = ([System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()).Name

# Initialize HTML report content
$htmlReportContent = @"
<html>
<head>
    <title>Active Directory ACL-ACE Reporter TheGuler0x | 🐝</title>
    <style>
        body {
            background-color: #F0F8FF;
            font-family: Arial, sans-serif;
        }
        h2 {
            color: #333333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #dddddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
<h2>AD Mass ACL-ACE Reporter by TheGuler0x 🐝📜 https://www.farukguler.com</h2>
<p>Report generated on: $($reportDateTime.ToString('yyyy-MM-dd HH:mm:ss'))</p>
<p>Computer Name: $computerName</p>
<p>Domain Name: $domainName</p>

<h3>Organizational Units (OU) and their ACL-ACE Details</h3>
"@

# Retrieve ACL-ACE details for each OU
foreach ($ou in $rootOU) {
    $htmlReportContent += @"
    <h4>OU: $($ou.Name)</h4>
    <table>
        <tr>
            <th>Identity Reference</th>
            <th>Access Control Type</th>
            <th>Active Directory Right</th>
        </tr>
"@

    $acl = Get-ACL "AD:\$($ou.DistinguishedName)" | Select-Object -ExpandProperty Access
    foreach ($ace in $acl) {
        $htmlReportContent += @"
        <tr>
            <td>$($ace.IdentityReference)</td>
            <td>$($ace.AccessControlType)</td>
            <td>$($ace.ActiveDirectoryRights)</td>
        </tr>
"@
    }

    $htmlReportContent += "</table>"
}

# Complete HTML content
$htmlReportContent += "</body></html>"

# Save HTML report to file
$htmlReportContent | Out-File -FilePath $htmlReportPath -Encoding UTF8

Write-Host "ACL-ACE report generated successfully: $htmlReportPath"
