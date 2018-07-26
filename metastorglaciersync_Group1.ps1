Import-Module PSLogging
$msArray = @(Get-ChildItem \\metastor\Metastor\Scans -Directory -Name)
$metastorLocal = '\\metastor\Metastor\Scans'
$metastorGlacier = 'METASTOR'
$logDate = Get-Date -format yyyyMMddHHmm
$logName = "METASTOR_$logDate.log"
$alphaArray = $msArray[0..4]

Start-Log -LogPath "\\DATA2\AVD_Dept\MIKE\Logs" -LogName "$logName" -ScriptVersion "1.0"


foreach ($collection in $alphaArray){
Start-Process -FilePath "C:\Program Files\FastGlacier\glacier-con.exe" -Args "sync mdemers $metastorLocal\$collection us-east-1 $metastorGlacier/$collection ncks" -Wait
$timeLoad = Get-Date
Write-LogInfo -LogPath "\\DATA2\AVD_Dept\MIKE\Logs\$logName" -Message "$collection synced to glacier at $timeLoad."
	}

$timeComplete = Get-Date
$notification = @{
            type = 'note'
						title = "Metastor sync complete"
            body = "Metastor glacier sync completed at $timeComplete"
        }
$pbkey = '[REDACTED]'
$credentials = New-Object System.Management.Automation.PSCredential ($pbkey, (ConvertTo-SecureString $pbkey -AsPlainText -Force))
Invoke-RestMethod -Uri 'https://api.pushbullet.com/v2/pushes' -body $notification  -method Post -credential $credentials

Stop-Log -LogPath "\\DATA2\AVD_Dept\MIKE\Logs\$logName"
