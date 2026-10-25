# System for retrieving invoices from the KS<span style="color: red">e</span>F system - English version / [wersja Polska](https://github.com/sstybel/KSeF-PL)

<a href="https://github.com/sstybel/KSeF-EN/releases/latest"><img alt="Static Badge" src="https://img.shields.io/badge/download-red?style=for-the-badge&label=stable&color=%23FF0000&link=https%3A%2F%2Fgithub.com%2Fsstybel%2FKSeF-EN%2Freleases%2Flatest"></a> ![GitHub Release](https://img.shields.io/github/v/release/sstybel/KSeF-EN?sort=date&display_name=release&style=for-the-badge&logo=github&label=release&link=https%3A%2F%2Fgithub.com%2Fsstybel%2FKSeF-EN) ![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/sstybel/KSeF-EN/total?style=for-the-badge&logo=github&link=https%3A%2F%2Fgithub.com%2Fsstybel%2FKSeF-EN)

---

## 📘 Table of contents

- [System for retrieving invoices from the KSeF system - English version / wersja Polska](#system-for-retrieving-invoices-from-the-ksef-system---english-version--wersja-polska)
  - [📘 Table of contents](#-table-of-contents)
  - [Introduction](#introduction)
  - [Creating a token in the KSeF system](#creating-a-token-in-the-ksef-system)
  - [Required tools](#required-tools)
  - [Downloading invoices in KSeF XML format](#downloading-invoices-in-ksef-xml-format)
  - [Downloading the invoice list in CSV format](#downloading-the-invoice-list-in-csv-format)
  - [Generating invoice visualizations in PDF format](#generating-invoice-visualizations-in-pdf-format)
  - [A script automating the process of downloading and generating documents from KSeF in Windows PowerShell](#a-script-automating-the-process-of-downloading-and-generating-documents-from-ksef-in-windows-powershell)
  - [Creating a task schedule in Windows to run the automation](#creating-a-task-schedule-in-windows-to-run-the-automation)
  - [Download](#download)
  - [GitHub](#github)
  - [Copyright © 2025 - 2026 by Sebastian Stybel, www.BONO-IT.pl](#copyright--2025---2026-by-sebastian-stybel-wwwbono-itpl)

## Introduction

This document describes the use of two tools for:
1. Downloading invoices in **KSeF XML** format - [**KSeF XML Download**](https://github.com/sstybel/ksef-xml-download)
2. Generating invoice visualizations in **PDF** format based on **KSeF XML** invoices - [**KSeF PDF Generator**](https://github.com/sstybel/ksef-pdf-generator)

This guide focuses on building an automation that cyclically (every 4 hours) checks for new invoices (sales and purchase) in the **KSeF** system. If new invoices (sales and/or purchase) appear in the **KSeF** system, the automation script performs the following 3 actions:
1. Downloads sales and/or purchase **KSeF XML** invoices into the appropriate folders, i.e.:
    1. Sales: `[DRIVE]:\[LOCATION]\[YEAR]\[MONTH]\Sales-Invoices\` (e.g. `C:\KSeF\2026\03\Sales-Invoices\`);
    2. Purchase: `[DRIVE]:\[LOCATION]\[YEAR]\[MONTH]\Purchase-Invoices\` (e.g. `C:\KSeF\2026\03\Purchase-Invoices\`);
2. Updates the current monthly invoice list in a **CSV** file and places it in the directory: `[DRIVE]:\[LOCATION]\[YEAR]\[MONTH]\_KSeF_\ksef_output[YEAR][MONTH].csv` (e.g. `C:\KSeF\2026\03\_KSeF_\ksef_output202603.csv`);
3. Generates invoice visualizations in **PDF** format according to the [**PDF/A-3**](https://en.wikipedia.org/wiki/PDF/A#PDF/A-3) standard ([**ISO 19005-3:2012**](https://www.iso.org/standard/57229.html)) based on the downloaded **KSeF XML** invoices and places them in the same location – see point 1.

Each month will have its own independent directory structure containing the **KSeF XML** invoice list, the document list in a **CSV** file, and the visual representation of invoices in **PDF** format.

## Creating a token in the KSeF system

For the [**KSeF XML Download**](https://github.com/sstybel/ksef-xml-download) tool to work properly, it is necessary to configure one of two authentication mechanisms in the **KSeF** system:

1. Certificate authentication;
2. Token authentication;

For the purposes of this automation, the **token authentication** method was selected.

You can use an existing token or, for security reasons, generate a new token specifically for the script.

To do this, go to the [**National e-Invoice System**](https://ksef.podatki.gov.pl/) website – [**https://ksef.podatki.gov.pl/**](https://ksef.podatki.gov.pl/) and click the **"[`Log in to KSeF`](https://ap.ksef.mf.gov.pl/web/)"** button.

![Screen-Shot](https://github.com/sstybel/KSeF-EN/blob/main/images/01.png)

This will take you to the login page, where you select the **"[`Authenticate in the National e-Invoice System`](https://ap.ksef.mf.gov.pl/web/)"** tile.

![Screen-Shot](https://github.com/sstybel/KSeF-EN/blob/main/images/02.png)

As the login method, choose **"[`Log in via login.gov.pl`](https://ap.ksef.mf.gov.pl/web/login)"**.

![Screen-Shot](https://github.com/sstybel/KSeF-EN/blob/main/images/03.png)

Next, enter the **Tax ID (NIP)** of the entity for which you will download **KSeF** invoices and click the **"`Authenticate`"** button.

![Screen-Shot](https://github.com/sstybel/KSeF-EN/blob/main/images/04.png)

In the next step, choose a login method for the [**Ministry of Finance**](https://www.gov.pl/web/finanse) services, for example using the [**mObywatel**](https://www.gov.pl/web/mobywatel) application.

![Screen-Shot](https://github.com/sstybel/KSeF-EN/blob/main/images/05.png)

After authentication, you will be logged in to the **National e-Invoice System – KSeF Taxpayer Application**, where you should go to the **"`Tokens`"** section and select **"`Generate token`"**.

![Screen-Shot](https://github.com/sstybel/KSeF-EN/blob/main/images/06.png)

Complete the form by providing:
1. The token name;
2. The permissions for the token – select "invoice viewing";
3. Click the **"`Generate token`"** button.

![Screen-Shot](https://github.com/sstybel/KSeF-EN/blob/main/images/07.png)

If the token does not appear, keep clicking the **"`Refresh`"** button until the token is displayed.

![Screen-Shot](https://github.com/sstybel/KSeF-EN/blob/main/images/08.png)

Usually, after one or two refreshes, your new token will appear. The token is displayed only once, so you must copy it (the **"`Copy`"** button) and save it in a secure place; otherwise, you will have to invalidate it and generate it again – repeat the entire token generation procedure from the beginning.

![Screen-Shot](https://github.com/sstybel/KSeF-EN/blob/main/images/09.png)

Now you have a generated token and can proceed with testing and script configuration.

## Required tools

To build the automation, as mentioned in the introduction, you will need two tools, which can be downloaded from the [**GitHub**](https://github.com/sstybel) repository:

1. [**KSeF XML Download**](https://github.com/sstybel/ksef-xml-download/) - https://github.com/sstybel/ksef-xml-download/releases/latest
2. [**KSeF PDF Generator**](https://github.com/sstybel/ksef-pdf-generator/) - https://github.com/sstybel/ksef-pdf-generator/releases/latest

To do this, create for example a **`KSeF-Company`** directory in the root of drive **`M:\`**, and store the `.exe` files downloaded earlier from the [**GitHub**](https://github.com/sstybel) repository in that location. I use the [**Windows PowerShell**](https://learn.microsoft.com/en-us/powershell/scripting/what-is-windows-powershell?view=powershell-7.5) shell for this purpose.

```
PS C:\> m:

PS M:\> cd \

PS M:\> mkdir KSeF-Company

PS M:\> cd KSeF-Company

PS M:\KSeF-Company> Invoke-WebRequest https://github.com/sstybel/ksef-xml-download/releases/download/1.40/ksef-xml-download.exe `
-OutFile .\ksef-xml-download.exe

PS M:\KSeF-Company> Invoke-WebRequest https://github.com/sstybel/ksef-pdf-generator/releases/download/1.4.0/ksef-pdf-generator.exe `
-OutFile .\ksef-pdf-generator.exe

PS M:\KSeF-Company> dir

    Directory: M:\KSeF-Company

Mode                  LastWriteTime         Length     Name
-----                 -------------         -------    -----
-a----                18.03.2026  12:00     41685797   ksef-pdf-generator.exe
-a----                18.03.2026  12:00     19273120   ksef-xml-download.exe

PS M:\KSeF-Company>
```

This way, the environment is prepared for further work.

## Downloading invoices in KSeF XML format

The first action we will perform is downloading purchase (**Subject2**) and sales (**Subject1**) invoices for March 2026 (i.e. 2026-03-01). The **KSeF XML** invoices will be saved to the appropriate directories, for example:

1. Purchase (**Subject2**) - `M:\KSeF-Company\Purchase-Invoices\`
2. Sales (**Subject1**) - `M:\KSeF-Company\Sales-Invoices\`

To do this, run the following commands:

```
PS M:\KSeF-Company> mkdir Sales-Invoices

PS M:\KSeF-Company> mkdir Purchase-Invoices

PS M:\KSeF-Company> dir


    Directory: M:\KSeF-Company


Mode         LastWriteTime     Length  Name
----         -------------     ------  ----
d-----   18.03.2026  18:19             Sales-Invoices
d-----   18.03.2026  18:19             Purchase-Invoices
-a----   18.03.2026  17:01   41685797  ksef-pdf-generator.exe
-a----   18.03.2026  16:58   19273120  ksef-xml-download.exe

PS M:\KSeF-Company> .\ksef-xml-download.exe --nip 1234567890 `
--token "20260201-EC-1A2B3C4D5E-1122334455-AB|nip-1234567890|11aa22bb33cc44dd55ee66ff77aa88bb99cc00dd11ee22ff33aa44bb55cc66dd" `
--subject-type Subject1and2 `
--download-xml `
--xml-sub1-output-dir .\Sales-Invoices `
--xml-sub2-output-dir .\Purchase-Invoices `
--ksef-state-dir .\State `
--output json `
--output-filename march_2026.json `
--output-append `
--output-dir .\

KSeF XML Invoices Downloader - ver. 1.40
Copyright (c) 2025 - 2026 by Sebastian Stybel, www.BONO-IT.pl
--------------------------------------------------------------------

Connecting to KSeF system (environment: prod)...
NIP (Tax ID): 1234567890
Authentication method: token
Session initialized. Reference number: 20260318-AA-1122334455-AABBCCDDEE-FF

Downloading invoices issued (sales) and received (purchases) - Subject1 and Subject2...
No existing KSeF state found at: .\State\ksef_state.json. A new state file will be created at: .\State\ksef_state.json
KSeF state saved to: .\State\ksef_state.json
{
    "Subject1": [
        {
.....
		}
    ],
    "Subject2": [
        {
.....
        }
    ]
}

Downloading KSeF XML file(s) from issued (sales) - Subject1 to: .\Sales-Invoices
  Downloaded: .\Sales-Invoices\1234567890-20260220-112233440000-12.xml
  Downloaded: .\Sales-Invoices\1234567890-20260228-445566770000-34.xml
  Downloaded: .\Sales-Invoices\1234567890-20260309-889900AA0000-56.xml
  Downloaded: .\Sales-Invoices\1234567890-20260312-BBCCDDEE0000-78.xml

Downloading KSeF XML file(s) from received (purchases) - Subject2 to: .\Purchase-Invoices
  Downloaded: .\Purchase-Invoices\1122334455-20260216-AA11BB22CC33-55.xml
  Downloaded: .\Purchase-Invoices\6677889900-20260221-BB00CC99DD88-44.xml
  Downloaded: .\Purchase-Invoices\1112223334-20260303-321123321123-33.xml
  Downloaded: .\Purchase-Invoices\5556667778-20260309-456654456654-22.xml
  Downloaded: .\Purchase-Invoices\1133557799-20260312-778899998877-11.xml

Ending session...
Session ended.

PS M:\KSeF-Company> tree /f

Folder PATH listing for volume DataSS
Volume serial number is A4F7-F767
M:.
│   ksef-pdf-generator.exe
│   ksef-xml-download.exe
│   march_2026.json
│
├───Sales-Invoices
│       1234567890-20260220-112233440000-12.xml
│       1234567890-20260228-445566770000-34.xml
│       1234567890-20260309-889900AA0000-56.xml
│       1234567890-20260312-BBCCDDEE0000-78.xml
│
├───Purchase-Invoices
│       1122334455-20260216-AA11BB22CC33-55.xml
│       6677889900-20260221-BB00CC99DD88-44.xml
│       1112223334-20260303-321123321123-33.xml
│       5556667778-20260309-456654456654-22.xml
│       1133557799-20260312-778899998877-11.xml
│
└───State
        ksef_state.json

PS M:\KSeF-Company>
```

The invoices in **KSeF XML** format have been downloaded.

## Downloading the invoice list in CSV format

The next action we will perform is downloading the invoice list for March 2026 (i.e. 2026-03-01). The invoice list will be saved to a **CSV** file (**`march_2026.csv`**), which can then be opened in **Excel** for further analysis.

To do this, run the following commands:

```
PS M:\KSeF-Company> .\ksef-xml-download.exe --nip 1234567890 `
--token "20260201-EC-1A2B3C4D5E-1122334455-AB|nip-1234567890|11aa22bb33cc44dd55ee66ff77aa88bb99cc00dd11ee22ff33aa44bb55cc66dd" `
--subject-type Subject1and2 `
--output csv `
--output-filename march_2026.csv `
--output-append `
--output-dir .\ `
--xml-sub1-output-dir .\Sales-Invoices `
--xml-sub2-output-dir .\Purchase-Invoices

KSeF XML Invoices Downloader - ver. 1.40
Copyright (c) 2025 - 2026 by Sebastian Stybel, www.BONO-IT.pl
--------------------------------------------------------------------

Connecting to KSeF system (environment: prod)...
NIP (Tax ID): 1234567890
Authentication method: token
Session initialized. Reference number: 20260318-CC-9988776655-FFAADDEECC-55

Downloading invoices issued (sales) and received (purchases) - Subject1 and Subject2...
"ksefSubjectType";"ksefNumber";"formSystemCode";"formSchemaVersion";"formValue";"invoiceNumber";"invoiceIssueDate";"invoiceCurrency";"invoiceType";"invoicingMode";"invoiceHash";"sellerNIP";"sellerName";"buyerIdType";"buyerIdValue";"buyerName";"netAmount";"vatAmount";"grossAmount";"qrCode";"fileName"

.....

Ending session...
Session ended.

PS M:\KSeF-Company> dir

    Directory: M:\KSeF-Company

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        18.03.2026     19:27                Sales-Invoices
d-----        18.03.2026     19:27                Purchase-Invoices
d-----        18.03.2026     19:27                State
-a----        18.03.2026     17:01       41685797 ksef-pdf-generator.exe
-a----        18.03.2026     16:58       19273120 ksef-xml-download.exe
-a----        18.03.2026     19:31           4608 march_2026.csv
-a----        18.03.2026     19:27          14325 march_2026.json
```

The invoice list has been downloaded (or updated) in the **`march_2026.csv`** file.

![Screen-Shot](https://github.com/sstybel/KSeF-EN/blob/main/images/10.png)

The description of the **CSV** header fields is as follows:
- **ksefSubjectType** - Type of **KSeF** invoice: **Subject1** (sales invoice), **Subject2** (purchase invoice);
- **ksefNumber** - Invoice number assigned by the **KSeF** system;
- **formSystemCode** - **KSeF** invoice code (version);
- **formSchemaVersion** - **KSeF** invoice schema version;
- **formValue** - **KSeF** form type;
- **invoiceNumber** - Invoice number assigned by the invoice issuer;
- **invoiceIssueDate** - Invoice issue date;
- **invoiceInvoicingDate** - Date when the **KSeF** number was assigned;
- **invoiceCurrency** - Currency, e.g. PLN;
- **invoiceType** - Invoice type, e.g. VAT;
- **invoicingMode** - Invoice issuance mode: **Online**, **Offline**;
- **invoiceHash** - Invoice hash (fingerprint);
- **sellerNIP** - Seller's Tax ID (NIP);
- **sellerName** - Seller's name;
- **buyerIdType** - Buyer identifier type, e.g. NIP;
- **buyerIdValue** - Buyer identifier. If the buyer identifier type is NIP, the buyer identifier is the NIP number;
- **buyerName** - Buyer's name;
- **netAmount** - Net value, total net value of the invoice;
- **vatAmount** - VAT value, total VAT value of the invoice;
- **grossAmount** - Gross value, total gross value of the invoice – Net value + VAT value;
- **qrCode** - Link to the **KSeF** system website verifying that the invoice was issued in the **KSeF** system;
- **fileName** - Location of the **KSeF XML** invoice file.

## Generating invoice visualizations in PDF format

The last action we will perform is generating invoice visualizations in **PDF** format according to the [**PDF/A-3**](https://en.wikipedia.org/wiki/PDF/A#PDF/A-3) standard ([**ISO 19005-3:2012**](https://www.iso.org/standard/57229.html)) for March 2026 (i.e. 2026-03-01).

The invoice visualizations will be saved in the same folders as the invoices downloaded in **KSeF XML** format. Additionally, the generated [**PDF/A-3**](https://en.wikipedia.org/wiki/PDF/A#PDF/A-3) invoices contain the embedded **KSeF XML** invoice file.

To do this, run the following commands:

```
PS M:\KSeF-Company> .\ksef-pdf-generator.exe -s .\march_2026.json

KSeF PDF Generator - ver. 1.4.0
Copyright (c) 2025 - 2026 by Sebastian Stybel, www.BONO-IT.pl
------------------------------------------------------------------------------

State file provided: .\march_2026.json
Processing state file: .\march_2026.json
Added XML file from state: .\Sales-Invoices\1234567890-20260220-112233440000-12.xml

.....

Invoice version: FA (3)
Generating PDF...
PDF generated successfully: .\Purchase-Invoices\1133557799-20260312-778899998877-11.pdf

PS M:\KSeF-Company> tree /f

Folder PATH listing for volume DataSS
Volume serial number is A4F7-F767
M:.
│   ksef-pdf-generator.exe
│   ksef-xml-download.exe
│   march_2026.csv
│   march_2026.json
│
├───Sales-Invoices
│       1234567890-20260220-112233440000-12.pdf
│       1234567890-20260220-112233440000-12.xml
│       1234567890-20260228-445566770000-34.pdf
│       1234567890-20260228-445566770000-34.xml
│       1234567890-20260309-889900AA0000-56.pdf
│       1234567890-20260309-889900AA0000-56.xml
│       1234567890-20260312-BBCCDDEE0000-78.pdf
│       1234567890-20260312-BBCCDDEE0000-78.xml
│
├───Purchase-Invoices
│       1122334455-20260216-AA11BB22CC33-55.pdf
│       1122334455-20260216-AA11BB22CC33-55.xml
│       6677889900-20260221-BB00CC99DD88-44.pdf
│       6677889900-20260221-BB00CC99DD88-44.xml
│       1112223334-20260303-321123321123-33.pdf
│       1112223334-20260303-321123321123-33.xml
│       5556667778-20260309-456654456654-22.pdf
│       5556667778-20260309-456654456654-22.xml
│       1133557799-20260312-778899998877-11.pdf
│       1133557799-20260312-778899998877-11.xml
│
└───State
        ksef_state.json

PS M:\KSeF-Company>
```

The invoices in **PDF** format have been generated.

![Screen-Shot](https://github.com/sstybel/KSeF-EN/blob/main/images/11.png)

## A script automating the process of downloading and generating documents from KSeF in Windows PowerShell

To summarize the entire workflow described above, all that remains is to script it.

I chose [**Windows PowerShell**](https://learn.microsoft.com/en-us/powershell/scripting/what-is-windows-powershell?view=powershell-7.5) as the shell for the script because it is available in [**Microsoft Windows**](https://www.microsoft.com/en-us/windows) without additional installation starting from **Windows 10**.

First, let us define all the necessary parameters so that in the future it is easy to quickly modify the script behavior.

**File: `KSeF.ps1`**
```powershell
Clear-Host # Clear the screen

$QUIET = "" # Show messages on the screen
#$QUIET = "--quiet" # Uncomment if you want to enable silent mode - no messages displayed on the screen

# Welcome screen
if ($QUIET -eq "") {
    Write-Host "Downloading invoices from the KSeF system"
    Write-Host "Copyright (c) 2025 - 2026 by Sebastian Stybel, www.BONO-IT.pl"
    Write-Host "----------------------------------------------------------------------"
}

$LocDIR = (Get-Location).Path # Specify the path to the base directory where invoices from KSeF will be downloaded (default: the directory from which the script was launched)
$ROK = (Get-Date).ToString("yyyy") # Current year (e.g. 2026)
$MIE = (Get-Date).ToString("MM") # Current month (e.g. 03)
$DZI = "01" # First day (01) of the month

$KSeFNIP = "1234567890" # Specify the company's NIP (Tax ID)
$KSeFToken = "20260201-EC-1A2B3C4D5E-1122334455-AB|nip-1234567890|11aa22bb33cc44dd55ee66ff77aa88bb99cc00dd11ee22ff33aa44bb55cc66dd" # Specify the KSeF Token
$KSeFDownloadStart = $ROK + "-" + $MIE + "-" + $DZI # Date (e.g. 2026-03-01) from which invoices should be downloaded
$KSeFJSONStateDIR = "$LocDIR/$ROK/$MIE/_KSeF_/State/JSON/" # Path to the directory with the KSeF invoice download state for JSON format
$KSeFJSONOutputDIR = "$LocDIR/$ROK/$MIE/_KSeF_/" # Path to the output directory for the invoice list in JSON format
$KSeFCSVStateDIR = "$LocDIR/$ROK/$MIE/_KSeF_/State/CSV/" # Path to the directory with the KSeF invoice download state for CSV format
$KSeFCSVOutputDIR = "$LocDIR/$ROK/$MIE/_KSeF_/" # Path to the output directory for the invoice list in CSV format
$KSeFOutputFileNameJSON = "ksef_output_$ROK$MIE.json"  # Output file name for the invoice list in JSON format
$KSeFOutputFileNameCSV = "ksef_output_$ROK$MIE.csv" # Output file name for the invoice list in CSV format
$KSeFOutputJSON = "$KSeFJSONOutputDIR$KSeFOutputFileNameJSON" # Path and name of the invoice list file in JSON format - used by the program (ksef-pdf-generator.exe) generating invoices in PDF format
$KSeFInvSub1DIR = "$LocDIR/$ROK/$MIE/Sales-Invoices/" # Path to the directory where sales invoices (KSeF - Subject1) should be downloaded
$KSeFInvSub2DIR = "$LocDIR/$ROK/$MIE/Purchase-Invoices/" # Path to the directory where purchase invoices (KSeF - Subject2) should be downloaded
```

Next, let us create the required directory structure where the data downloaded from the **KSeF** system will be stored.

```powershell
# Creating the directory structure
$NewDir = New-Item -ItemType Directory -Path $KSeFCSVOutputDIR -Force -ErrorAction SilentlyContinue
$NewDir = New-Item -ItemType Directory -Path $KSeFJSONOutputDIR -Force -ErrorAction SilentlyContinue
$NewDir = New-Item -ItemType Directory -Path $KSeFCSVStateDIR -Force -ErrorAction SilentlyContinue
$NewDir = New-Item -ItemType Directory -Path $KSeFJSONStateDIR -Force -ErrorAction SilentlyContinue
$NewDir = New-Item -ItemType Directory -Path $KSeFInvSub1DIR -Force -ErrorAction SilentlyContinue
$NewDir = New-Item -ItemType Directory -Path $KSeFInvSub2DIR -Force -ErrorAction SilentlyContinue
```

Finally, execute the three commands according to the plan above, using the variables defined earlier.

```powershell
# Downloading sales and purchase invoices in KSeF XML format

& $LocDIR/ksef-xml-download.exe --nip $KSeFNIP `
--token $KSeFToken `
--subject-type Subject1and2 `
--download-xml `
--xml-sub1-output-dir $KSeFInvSub1DIR `
--xml-sub2-output-dir $KSeFInvSub2DIR `
--ksef-state-dir $KSeFJSONStateDIR `
--output json `
--output-filename $KSeFOutputFileNameJSON `
--output-append `
--output-dir $KSeFJSONOutputDIR `
--date-from $KSeFDownloadStart `
$QUIET

# Downloading the list of sales and purchase invoices in CSV format

& $LocDIR/ksef-xml-download.exe --nip $KSeFNIP `
--token $KSeFToken `
--subject-type Subject1and2 `
--xml-sub1-output-dir $KSeFInvSub1DIR `
--xml-sub2-output-dir $KSeFInvSub2DIR `
--ksef-state-dir $KSeFCSVStateDIR `
--output csv `
--output-filename $KSeFOutputFileNameCSV `
--output-append `
--output-dir $KSeFCSVOutputDIR `
--date-from $KSeFDownloadStart `
$QUIET

# Generating invoice visualizations in PDF format (PDF/A-3 standard - ISO 19005-3:2012) based on the downloaded XML invoices from the KSeF system

& $LocDIR/ksef-pdf-generator.exe --state $KSeFOutputJSON `
$QUIET
```

The complete script can be downloaded from the [**KSeF.ps1**](https://github.com/sstybel/KSeF-EN/blob/main/KSeF.ps1) repository.

## Creating a task schedule in Windows to run the automation

Finally, the script must be put into motion, meaning it should be triggered (run) cyclically. In [**Microsoft Windows**](https://www.microsoft.com/en-us/windows), we have Task Scheduler, where we can create a recurring task.

The task frequency should not be too high, because the **KSeF** system includes protection against system overload caused by excessive calls. However, the most reasonable interval is **2h** - **4h**, meaning from 12 to 6 runs per day – if the computer is turned on 24 hours a day.

As for running a script written in [**Windows PowerShell**](https://learn.microsoft.com/en-us/powershell/scripting/what-is-windows-powershell?view=powershell-7.5) from a scheduled task, on the task tab in the **Actions** section, fill out the form as follows:

- Program/script: **`Powershell.exe`**
- Add arguments (optional): **`-ExecutionPolicy Bypass M:\KSeF-Company\KSeF.ps1`**
- Start in (optional): **`M:\KSeF-Company\`**

You can download the exported scheduled task from the [**BONO-IT_KSeF.xml**](https://github.com/sstybel/KSeF-EN/blob/main/KSeF.ps1) repository.

![Screen-Shot](https://github.com/sstybel/KSeF-EN/blob/main/images/12.png)

---

## Download

<a href="https://github.com/sstybel/KSeF-EN/releases/latest"><img alt="Static Badge" src="https://img.shields.io/badge/download-red?style=for-the-badge&label=stable&color=%23FF0000&link=https%3A%2F%2Fgithub.com%2Fsstybel%2FKSeF-EN%2Freleases%2Flatest"></a> ![GitHub Release](https://img.shields.io/github/v/release/sstybel/KSeF-EN?sort=date&display_name=release&style=for-the-badge&logo=github&label=release&link=https%3A%2F%2Fgithub.com%2Fsstybel%2FKSeF-EN) ![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/sstybel/KSeF-EN/total?style=for-the-badge&logo=github&link=https%3A%2F%2Fgithub.com%2Fsstybel%2FKSeF-EN)

##  GitHub

[![GitHub Stats](https://github-stats-extended.vercel.app/api?username=sstybel&rank_icon=github&show=reviews%2Cdiscussions_started%2Cdiscussions_answered%2Cprs_merged%2Cprs_merged_percentage%2Cprs_commented%2Cprs_reviewed%2Cissues_commented%2Ccontributions%2Call_time_contribs&show_icons=true&include_all_commits=true&theme=aura_dark)](https://github-stats-extended.vercel.app/api?username=sstybel&rank_icon=github&show=reviews%2Cdiscussions_started%2Cdiscussions_answered%2Cprs_merged%2Cprs_merged_percentage%2Cprs_commented%2Cprs_reviewed%2Cissues_commented%2Ccontributions%2Call_time_contribs&show_icons=true&include_all_commits=true&theme=aura_dark)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[![GitHub Stats](https://github-stats-extended.vercel.app/api/top-langs?username=sstybel&langs_count=6&theme=monokai)](https://github-stats-extended.vercel.app/api/top-langs?username=sstybel&langs_count=6&theme=monokai)

&nbsp;

---

## Copyright &copy; 2025 - 2026 by Sebastian Stybel, [www.BONO-IT.pl](https://www.bono-it.pl/)
