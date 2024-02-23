Add-Type -AssemblyName PresentationFramework

[xml]$xaml = @'
<Window
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
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

$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlLoader]::Load($reader)

# Event handler for the Clean Temporary Files button
$cleanButton = $window.FindName("CleanButton")
$cleanButton.Add_Click({
    Write-Host "Cleaning temporary files..."
    Remove-Item -Path "$env:TEMP\*" -Force -Recurse
    Remove-Item -Path "C:\Windows\Temp\*" -Force -Recurse
    Write-Host "Temporary files cleaned successfully."
})

# Event handler for the Restart Computer button
$restartButton = $window.FindName("RestartButton")
$restartButton.Add_Click({
    Write-Host "Restarting computer..."
    Restart-Computer -Force
})

# Event handler for the Disable Windows Updates button
$disableUpdatesButton = $window.FindName("DisableUpdatesButton")
$disableUpdatesButton.Add_Click({
    Write-Host "Disabling Windows Updates (NOT RECOMMENDED - use only if you know what you're doing)..."
    Stop-Service -Name wuauserv
    Set-Service -Name wuauserv -StartupType Disabled
    Write-Host "Windows Updates disabled. Use with caution."
})

# Event handler for the Disable Windows Defender button
$disableDefenderButton = $window.FindName("DisableDefenderButton")
$disableDefenderButton.Add_Click({
    Write-Host "Disabling Windows Defender (NOT RECOMMENDED - use only if you know what you're doing)..."
    Set-MpPreference -DisableRealtimeMonitoring $true
    Write-Host "Windows Defender disabled. Use with caution."
})

# Display GUI
$window.ShowDialog()
