Param(
    [string]$dllPath,
    [string]$title,
    [string]$content
)
# Param关键字需要置顶

#添加对XML库的引用
Add-Type -Path $dllPath
echo $dllPath

[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]

[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]

#创建XML文件
$template = @"
<toast>
    <visual>
        <binding template="ToastGeneric">
            <text id = "1">$title</text>
	<text id = "2">$content</text>
        </binding>
    </visual>
</toast>
"@

echo "create xml success"

# 创建一个Toast通知
$toastXml = New-Object Windows.Data.Xml.Dom.XmlDocument
# $toastXml = New-Object -TypeName Windows.Data.Xml.Dom.XmlDocument
$toastXml.LoadXml($template)
$toast = [Windows.UI.Notifications.ToastNotification]::new($toastXml)

echo "create toast success"

# 获取应用的Toast通知管理器
# Run "Get-StartApps" in PowerShell To Get the App-Id to your unity or something
$appId = "{6D809377-6AF0-444B-8957-A3773F02200E}\Unity\Hub\Editor\2019.4.32f1\Editor\Unity.exe" # 替换为你的APPID
$toastNotifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($appId)

$toastNotifier.Show($toast)

pause
