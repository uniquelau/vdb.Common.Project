# Parameters 
Param (
    [String]$List = "ReplacementList.csv",
    [String]$Files = "*\*.*",
    $COMPANY = "contoso",
    $COMPANYFULLNAME = "Contoso Global Holdings 2014 Ltd.",
    $PROJECT = "bank",
    $debug=1
)

# Rename files and folders
# Get-ChildItem -Filter "*_company._project_*" -Recurse | Rename-Item -NewName {$_.name -replace '_company_._project_',$COMPANY.$PROJECT }

Write-Host "*** Renaming Files" -ForegroundColor Yellow

$find = '*_company_._project_*'

foreach ($sc in Get-ChildItem -Filter $find -Recurse | where { test-path $_.fullname -pathtype leaf} ) {
	
	if ($debug) {
		Write-Host "*** File found " -ForegroundColor Yellow
		Get-ChildItem $sc.FullName
	}
	
	Get-ChildItem $sc.FullName | foreach { 
		Write-Host $_ -ForegroundColor Yellow
		rename-item $_ $_.Name.Replace('_company_._project_', "${COMPANY}.${PROJECT}") 
	}

}

# Create an array that contains all the folders that should be renamed
$folders = Get-ChildItem -Filter $find -recurse | Where-Object {$_.PSIsContainer -eq $True}  | Select-Object

# Reverse the array - we need to deal with the deepest items first!
if ($folders) {
    [array]::Reverse($folders)

    foreach ($folder in $folders) {
        $folder.Name
        $folder.FullName

        Rename-Item $folder.FullName $folder.Name.Replace('_company_._project_', "${COMPANY}.${PROJECT}")
    } 
}

# Rename-Item $folder.FullName {$folder.Name -replace '_company_._project_', "${COMPANY}.${PROJECT}" }



# Import Manual CSV into $ReplacementList variable
$ReplacementList = Import-Csv $List;

# Handle replacements from our this Powershell's params
$_Company = New-Object PsObject -Property @{ OldValue = '_company_' ; NewValue = $COMPANY }
$_CompanyFullName = New-Object PsObject -Property @{ OldValue = '_companyfullname_' ; NewValue = $COMPANYFULLNAME }
$_Project = New-Object PsObject -Property @{ OldValue = '_project_' ; NewValue = $PROJECT }

# Dynamically create GUIDs
$_GUID1 = New-Object PsObject -Property @{ OldValue = '_guid0_' ; NewValue = [GUID]::NewGuid() }
$_GUID2 = New-Object PsObject -Property @{ OldValue = '_guid1_' ; NewValue = [GUID]::NewGuid() }
$_GUID3 = New-Object PsObject -Property @{ OldValue = '_guid2_' ; NewValue = [GUID]::NewGuid() }
$_GUID4 = New-Object PsObject -Property @{ OldValue = '_guid3_' ; NewValue = [GUID]::NewGuid() }
$_GUID5 = New-Object PsObject -Property @{ OldValue = '_guid4_' ; NewValue = [GUID]::NewGuid() }
$_GUID6 = New-Object PsObject -Property @{ OldValue = '_guid5_' ; NewValue = [GUID]::NewGuid() }

$ReplacementList += $_Company, $_CompanyFullName, $_Project, $_GUID1, $_GUID2, $_GUID3, $_GUID4, $_GUID5, $_GUID6

# Print out the replacement list
if ($debug) {
        Write-Host "*** Find and replace " -ForegroundColor Yellow
        $ReplacementList
}

# Run through the files and update
Get-ChildItem $Files |
ForEach-Object {

    Write-Host "*** File found " -ForegroundColor Yellow


    $Content = Get-Content -Path $_.FullName;
    foreach ($ReplacementItem in $ReplacementList)
    {
        $Content = $Content -Replace($ReplacementItem.OldValue, $ReplacementItem.NewValue)
    }
    Set-Content -Path $_.FullName -Value $Content
}
