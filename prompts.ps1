#Scirpt cretaed by Philip Kleinberg #001510253

#module import
Import-Module ActiveDirectory

#OU creation
New-ADOrganizationalUnit -Name "Finance" -Path "DC=consultingfirm,DC=COM" 

#Ou path
$Domain = "OU=Finance,DC=consultingfirm,DC=com"

#user list
$NewUsersList = Import-csv C:\Users\LabAdmin\Desktop\Requirements2\financePersonnel.csv

#try/catch statement to help stop potential issues with ForEach
try {

ForEach($user in $NewUsersList) {

$First_Name = $user.First_Name.trim()
$Last_Name = $user.Last_Name.trim()
$samAccount = $user.samAccount.trim()
$Display_name = "$First_Name" + " " + "$Last_Name"
$City = $user.City.trim()
$County = $user.County.trim()
$PostalCode = $user.PostalCode.trim()
$officephone = $user.OfficePhone.trim()
$mobilephone = $user.MobilePhone.trim()
$OU_path = "OU=Finance,DC=consultingfirm,DC=COM"



New-ADUser -Path $OU_path -Name "$Display_name" -Enabled $true -PostalCode "$PostalCode" -MobilePhone "$mobilephone" -City "$City" -OfficePhone "$officephone" -DisplayName "$Display_name" -GivenName "$First_Name" -Surname "$Last_Name" -SamAccountName "$samAccount" -PasswordNotRequired $true 



} } Catch [System.OutOfMemoryException] {Write-Host "Out of memory exception has occured."}

#Sql server import
Import-module -Name "SqlServer"

#Import contacts from CSV
$CSV_import = Import-csv C:\Users\LabAdmin\Desktop\Requirements2\NewClientData.csv

#ClientDB creation
Invoke-Sqlcmd -ServerInstance "SRV19-Primary\SQLExpress" -Query "USE master;
GO
CREATE DATABASE ClientDB
GO"

#Client_A_Contacts Table creation
Invoke-Sqlcmd -ServerInstance "SRV19-Primary\SQLExpress" -Database "ClientDB" -Query "USE ClientDB
    CREATE TABLE Client_A_Contacts (
    first_name varchar(255),
    last_name varchar(255),
    city varchar(255),
    county varchar(255),
    zip varchar(255),
    officePhone varchar(255),
    mobilePhone varchar(255)
);"

#try/catch statement to help stop potential issues with ForEach
try {

#Importing CSV into Contacts table
Foreach ($csv_line in $CSV_import) {
$first_name = $csv_line.first_name.trim()
$last_name = $csv_line.last_name.trim()
$city = $csv_line.city.trim()
$county = $csv_line.county.trim()
$zip = $csv_line.zip.trim()
$officePhone = $csv_line.officePhone.trim()
$mobile = $csv_line.mobilePhone.trim()

Invoke-Sqlcmd -ServerInstance "SRV19-Primary\SQLExpress" -Database "ClientDB" -Query "USE ClientDB
INSERT INTO dbo.Client_A_Contacts (first_name, last_name, city, county, zip, officePhone, mobilePhone)
VALUES('$first_name', '$last_name', '$city', '$county', '$zip', '$officePhone', '$mobile');"



} } Catch [System.OutOfMemoryException] {Write-Host "Out of memory exception has occured."}

#Outputting SQL results
cd C:\Users\LabAdmin\Desktop\
Invoke-sqlcmd -Database ClientDB -ServerInstance .\SQLEXPRESS -Query 'SELECT * FROM dbo.Client_A_Contacts' > .\results.txt
