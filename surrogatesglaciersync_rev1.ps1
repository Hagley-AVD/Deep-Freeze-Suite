Import-Module PSLogging
$surrArray = @(Get-ChildItem \\DATA2\AVD_Dept\DIGITAL_RECORDS\SURROGATES_NOT_ONLINE -Directory -Name)
$surrogatesLocal = '\\DATA2\AVD_Dept\DIGITAL_RECORDS\SURROGATES_NOT_ONLINE'
$surrogatesGlacier = 'DIGITAL_RECORDS/DIGITAL_RECORDS/SURROGATES_NOT_ONLINE'
$logDate = Get-Date -format yyyyMMddHHmm
$logName = "SURROGATES_NOT_ONLINE_$logDate.log"
$bunnie = '2017_205 _Bunnie du Pont films'

Start-Log -LogPath “\\DATA2\AVD_Dept\MIKE\Logs” -LogName “$logName” -ScriptVersion “1.0”


foreach ($collection in $surrArray){
if ($collection -ne $bunnie){
Start-Process -FilePath "C:\Program Files\FastGlacier\glacier-sync.exe" -Args "mdemers $surrogatesLocal\$collection us-east-1 $surrogatesGlacier/$collection ncs" -Wait
$timeLoad = Get-Date
Write-LogInfo -LogPath “\\DATA2\AVD_Dept\MIKE\Logs\$logName” -Message “$collection synced to glacier at $timeLoad.”
    }
if ($collection -eq $bunnie){
Write-LogInfo -LogPath “\\DATA2\AVD_Dept\MIKE\Logs\$logName” -Message “Skipping $bunnie”
}
    }

$timeComplete = Get-Date
$notification = @{
            type = 'note'
            title = "Surrogate Sync Complete"
            body = "surrogates glacier sync completed at $timeComplete"
        }
$pbkey = '[REDACTED]'
$credentials = New-Object System.Management.Automation.PSCredential ($pbkey, (ConvertTo-SecureString $pbkey -AsPlainText -Force))
Invoke-RestMethod -Uri 'https://api.pushbullet.com/v2/pushes' -body $notification  -method Post -credential $credentials

Stop-Log -LogPath “\\DATA2\AVD_Dept\MIKE\Logs\$logName”
