Clear-Host # Clear the screen

$QUIET = "" # Show messages on the screen
#$QUIET = "--quiet" # Uncomment this line if you want to enable silent mode - messages will not be displayed on the screen

# Welcome screen
if ($QUIET -eq "") {
    Write-Host "Pobieranie faktur z systemu KSeF"
    Write-Host "Copyright (c) 2025 - 2026 by Sebastian Stybel, www.BONO-IT.pl"
    Write-Host "----------------------------------------------------------------------"
}

$LocDIR = (Get-Location).Path # Enter the path to the base directory where invoices will be downloaded from KSeF (default: the directory from which the script was run)
$ROK = (Get-Date).ToString("yyyy") # Current year (e.g., 2026)
$MIE = (Get-Date).ToString("MM") # Current month (e.g., 03)
$DZI = "01" # First (01) day of the month

$KSeFNIP = "1234567890" # Enter the company’s tax ID here
$KSeFToken = "20260201-EC-1A2B3C4D5E-1122334455-AB|nip-1234567890|11aa22bb33cc44dd55ee66ff77aa88bb99cc00dd11ee22ff33aa44bb55cc66dd" # Enter the KSeF token here

$KSeFDownloadStart = $ROK + "-" + $MIE + "-" + $DZI # Date (e.g., 2026-03-01) from which invoices should be downloaded
$KSeFJSONStateDIR = "$LocDIR/$ROK/$MIE/_KSeF_/State/JSON/" # Path to the directory containing the KSeF invoice download status for the JSON format
$KSeFJSONOutputDIR = "$LocDIR/$ROK/$MIE/_KSeF_/" # Path to the output directory for the list of invoices in JSON format
$KSeFCSVStateDIR = "$LocDIR/$ROK/$MIE/_KSeF_/State/CSV/" # Path to the directory containing the KSeF invoice download status for the CSV format
$KSeFCSVOutputDIR = "$LocDIR/$ROK/$MIE/_KSeF_/" # Path to the output directory for the list of invoices in CSV format
$KSeFOutputFileNameJSON = "ksef_output_$ROK$MIE.json"  # Name of the output file containing the list of invoices in JSON format
$KSeFOutputFileNameCSV = "ksef_output_$ROK$MIE.csv" # Name of the output file containing the list of invoices in CSV format
$KSeFOutputJSON = "$KSeFJSONOutputDIR$KSeFOutputFileNameJSON" # Location and name of the file containing the list of invoices in JSON format - used by the program (ksef-pdf-generator.exe) that generates invoices in PDF format
$KSeFInvSub1DIR = "$LocDIR/$ROK/$MIE/Faktury-Sprzedaz/" # Path to the directory where sales invoices are to be downloaded (KSeF - Subject1)
$KSeFInvSub2DIR = "$LocDIR/$ROK/$MIE/Faktury-Zakupowe/" # Path to the directory where purchase invoices are to be downloaded (KSeF - Subject2)

# Creating the directory structure
$NewDir = New-Item -ItemType Directory -Path $KSeFCSVOutputDIR -Force -ErrorAction SilentlyContinue
$NewDir = New-Item -ItemType Directory -Path $KSeFJSONOutputDIR -Force -ErrorAction SilentlyContinue
$NewDir = New-Item -ItemType Directory -Path $KSeFCSVStateDIR -Force -ErrorAction SilentlyContinue
$NewDir = New-Item -ItemType Directory -Path $KSeFJSONStateDIR -Force -ErrorAction SilentlyContinue
$NewDir = New-Item -ItemType Directory -Path $KSeFInvSub1DIR -Force -ErrorAction SilentlyContinue
$NewDir = New-Item -ItemType Directory -Path $KSeFInvSub2DIR -Force -ErrorAction SilentlyContinue

# Downloading sales and purchase invoices in KSeF XML format
& $LocDIR/ksef-xml-download.exe --nip $KSeFNIP --token $KSeFToken --subject-type Subject1and2 --download-xml --xml-sub1-output-dir $KSeFInvSub1DIR --xml-sub2-output-dir $KSeFInvSub2DIR --ksef-state-dir $KSeFJSONStateDIR --output json --output-filename $KSeFOutputFileNameJSON --output-append --output-dir $KSeFJSONOutputDIR --date-from $KSeFDownloadStart $QUIET

# Downloading a list of sales and purchase invoices in CSV format
& $LocDIR/ksef-xml-download.exe --nip $KSeFNIP --token $KSeFToken --subject-type Subject1and2 --xml-sub1-output-dir $KSeFInvSub1DIR --xml-sub2-output-dir $KSeFInvSub2DIR --ksef-state-dir $KSeFCSVStateDIR --output csv --output-filename $KSeFOutputFileNameCSV --output-append --output-dir $KSeFCSVOutputDIR --date-from $KSeFDownloadStart $QUIET

# Generating invoice visualizations in PDF format (PDF/A-3 standard - ISO 19005-3:2012) based on XML invoices downloaded from the KSeF system
& $LocDIR/ksef-pdf-generator.exe --state $KSeFOutputJSON $QUIET
