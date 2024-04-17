Param(
    [string]$title,
    [string]$content
)
# Param关键字需要置顶


#添加对XML库的引用
Add-Type -Path "C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETCore\v4.5\System.Runtime.WindowsRuntime.dll"

#PowerShell 中引入 Windows Runtime（WinRT）的类
[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]



#创建XML文件
$template = @"
<toast>
    <visual>
        <binding template="ToastText01">
            <text id="1">$content</text>
        </binding>
    </visual>
</toast>
"@

# 创建一个Toast通知
$toastXml = New-Object -TypeName Windows.Data.Xml.Dom.XmlDocument
$toastXml.LoadXml($template)
$toast = New-Object -TypeName Windows.UI.Notifications.ToastNotification -ArgumentList $toastXml

# 获取应用的Toast通知管理器
$appId = "{6D809377-6AF0-444B-8957-A3773F02200E}\Unity\Hub\Editor\2019.4.32f1\Editor\Unity.exe" # 替换为你的APPID
$toastNotifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($appId)

# 显示Toast通知
$toastNotifier.Show($toast)
pause