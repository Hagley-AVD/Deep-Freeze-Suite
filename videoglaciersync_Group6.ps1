Import-Module PSLogging
$vidArray = @(Get-ChildItem \\FS2\VideoWS -Directory -Name)
$videoLocal = '\\FS2\VideoWS'
$videoGlacier = 'video_hi-res'
$logDate = Get-Date -format yyyyMMddHHmm
$logName = "video_hi-res_Group6_$logDate.log"
$foxtrotArray = $vidArray[25..($vidArray.GetUpperBound(0))]

Start-Log -LogPath "\\DATA2\AVD_Dept\MIKE\Logs" -LogName "$logName" -ScriptVersion "1.0"


foreach ($collection in $foxtrotArray){
Start-Process -FilePath "C:\Program Files\FastGlacier\glacier-con.exe" -Args "sync mdemers $videoLocal\$collection us-east-1 $videoGlacier/$collection ncks" -Wait
$timeLoad = Get-Date
Write-LogInfo -LogPath "\\DATA2\AVD_Dept\MIKE\Logs\$logName" -Message "$collection synced to glacier at $timeLoad."
	}

$timeComplete = Get-Date
$notification = @{
            type = 'note'
            title = "VideoWS sync complete"
            body = "video_hi-resGroup6 synced to glacier at $timeComplete"
        }
$pbkey = '[REDACTED]'
$credentials = New-Object System.Management.Automation.PSCredential ($pbkey, (ConvertTo-SecureString $pbkey -AsPlainText -Force))
Invoke-RestMethod -Uri 'https://api.pushbullet.com/v2/pushes' -body $notification  -method Post -credential $credentials

Stop-Log -LogPath "\\DATA2\AVD_Dept\MIKE\Logs\$logName"
