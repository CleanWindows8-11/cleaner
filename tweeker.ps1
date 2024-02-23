Add-Type -AssemblyName PresentationFramework

[xml]$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Windows Optimizer" Height="300" Width="400">
    <Grid>
        <Button Content="Clean Temporary Files" HorizontalAlignment="Left" Margin="50,50,0,0" VerticalAlignment="Top" Width="200" Height="30" Name="CleanButton"/>
        <Button Content="Restart Computer" HorizontalAlignment="Left" Margin="50,100,0,0" VerticalAlignment="Top" Width="200" Height="30" Name="RestartButton"/>
        <Button Content="Disable Windows Updates" HorizontalAlignment="Left" Margin="50,150,0,0" VerticalAlignment="Top" Width="200" Height="30" Name="DisableUpdatesButton"/>
        <Button Content="Disable Windows Defender" HorizontalAlignment="Left" Margin="50,200,0,0" VerticalAlignment="Top" Width="200" Height="30" Name="DisableDefenderButton"/>
    </Grid>
</Window>
'@

# Define functions
function Clean-TemporaryFiles {
    Write-Host "Cleaning temporary files..."
    Remove-Item -Path "$env:TEMP\*" -Force -Recurse
    Remove-Item -Path "C:\Windows\Temp\*" -Force -Recurse
    Write-Host "Temporary files cleaned successfully."
}

function Restart-Computer {
    Write-Host "Restarting computer..."
    Restart-Computer -Force
}

function Disable-Windows-Updates {
    Write-Host "Disabling Windows Updates (NOT RECOMMENDED - use only if you know what you're doing)..."
    Stop-Service -Name wuauserv
    Set-Service -Name wuauserv -StartupType Disabled
    Write-Host "Windows Updates disabled. Use with caution."
}

function Disable-Windows-Defender {
    Write-Host "Disabling Windows Defender (NOT RECOMMENDED - use only if you know what you're doing)..."
    Set-MpPreference -DisableRealtimeMonitoring $true
    Write-Host "Windows Defender disabled. Use with caution."
}

# Create XAML reader
$xamlReader = (New-Object System.Xml.XmlNodeReader $xaml)

# Load XAML elements
[Windows.Markup.XamlLoader]::Load($xamlReader)

# Event handlers for buttons
$window = [Windows.Markup.XamlLoader]::Load($xamlReader)
$window.FindName("CleanButton").Add_Click({ Clean-TemporaryFiles })
$window.FindName("RestartButton").Add_Click({ Restart-Computer })
$window.FindName("DisableUpdatesButton").Add_Click({ Disable-Windows-Updates })
$window.FindName("DisableDefenderButton").Add_Click({ Disable-Windows-Defender })

# Display GUI
$window.ShowDialog()
