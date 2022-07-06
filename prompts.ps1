# Script created by Philip Kleinberg #001510253

#Varibles for script
$folder_path = 'F:\Scripting and Automation\Requirements1' #folder location for requirements folder on my machine, if you have issues just change the location to YOUR requirements folder location
$Cpu_load_percentage = Get-CimInstance Win32_Processor | Select-Object -Property LoadPercentage #loads CPU load %
$Computer_info = Get-ComputerInfo #loads all computer info for RAM calculation
$total_ram = ($Computer_info.OsTotalVirtualMemorySize)
$free_ram = ($Computer_info.OsFreeVirtualMemory)
$used_ram = ($total_ram - $free_ram)
$ram_usage = ($used_ram/$total_ram*100)


try {


#do loop that allows continual choices by users to be made after switch statement 
do {

#user option varible- allows user to input choice during loop
$user_option_input = Read-Host "Please select an option:

Enter 1 to generate daily log

Enter 2 to list files in requirements folder

Enter 3 to list current CPU and memory usage

Enter 4 to list current running processes 

Enter 5 to exit script"

#Good ol switch statement allowing choices to be made during loop
switch ($user_option_input) {

1 {Get-Date | Out-File -FilePath $folder_path'\DailyLog.txt' -Append; Get-ChildItem $folder_path -Filter *.log | Select-Object -Property Name | Format-Table -HideTableHeaders | Out-File -Append -FilePath $folder_path'\DailyLog.txt'; Clear-host; write-host -ForegroundColor Red "Generating log"}
2 {Get-ChildItem $folder_path | Select-Object -Property Name, CreationTime, Length | Sort-Object -Property Name | Format-Table -HideTableHeader | Out-file -LiteralPath "$folder_path\C916contents.txt" ; clear-host ; Write-Host -ForegroundColor Red "Generating C916 file"}
3 {Clear-host; Write-Host -ForegroundColor Red "Current CPU usage is"($Cpu_load_percentage.LoadPercentage)"%"; Write-Host -ForegroundColor Red "Ram usage is" $ram_usage"%"}
4 {Get-Process | Select-Object -Property VirtualMemorySize, Name | Sort-Object -Property VirtualMemorySize | Out-GridView; Clear-Host}
default {} } 
} until ($user_option_input -eq 5) #allows loop to exit when user picks choice 5

} Catch [System.OutOfMemoryException] {Write-Host "Out of memory exception has occured."}

