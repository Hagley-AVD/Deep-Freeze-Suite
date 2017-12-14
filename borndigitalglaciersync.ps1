Import-Module PSLogging
$bdArray = @(Get-ChildItem \\DATA2\AVD_Dept\DIGITAL_RECORDS\BORN_DIG -Directory -Name)
$borndigLocal = '\\DATA2\AVD_Dept\DIGITAL_RECORDS\BORN_DIG'
$borndigGlacier = 'DIGITAL_RECORDS/DIGITAL_RECORDS/BORN_DIG'
$logDate = Get-Date -format yyyyMMddHHmm
$logName = "BORN_DIG_$logDate.log"

Start-Log -LogPath “\\DATA2\AVD_Dept\MIKE\Logs” -LogName “$logName” -ScriptVersion “1.0”


foreach ($collection in $bdArray){
Start-Process -FilePath "C:\Program Files\FastGlacier\glacier-con.exe" -Args "sync mdemers $borndigLocal\$collection us-east-1 $borndigGlacier/$collection ncks" -Wait
$timeLoad = Get-Date
Write-LogInfo -LogPath “\\DATA2\AVD_Dept\MIKE\Logs\$logName” -Message “$collection synced to glacier at $timeLoad.”
	}

$timeComplete = Get-Date
$notification = @{
            type = 'note'
            title = "BORN_DIG sync complete"
            body = "Born Digital glacier sync completed at $timeComplete"
        }
$pbkey = '[REDACTED]'
$credentials = New-Object System.Management.Automation.PSCredential ($pbkey, (ConvertTo-SecureString $pbkey -AsPlainText -Force))
Invoke-RestMethod -Uri 'https://api.pushbullet.com/v2/pushes' -body $notification  -method Post -credential $credentials

Stop-Log -LogPath “\\DATA2\AVD_Dept\MIKE\Logs\$logName”
