Param(
    [string]$title,
    [string]$content
)
# Param�ؼ�����Ҫ�ö�


#��Ӷ�XML�������
Add-Type -Path "C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETCore\v4.5\System.Runtime.WindowsRuntime.dll"

#PowerShell ������ Windows Runtime��WinRT������
[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]



#����XML�ļ�
$template = @"
<toast>
    <visual>
        <binding template="ToastText01">
            <text id="1">$content</text>
        </binding>
    </visual>
</toast>
"@

# ����һ��Toast֪ͨ
$toastXml = New-Object -TypeName Windows.Data.Xml.Dom.XmlDocument
$toastXml.LoadXml($template)
$toast = New-Object -TypeName Windows.UI.Notifications.ToastNotification -ArgumentList $toastXml

# ��ȡӦ�õ�Toast֪ͨ������
$appId = "{6D809377-6AF0-444B-8957-A3773F02200E}\Unity\Hub\Editor\2019.4.32f1\Editor\Unity.exe" # �滻Ϊ���APPID
$toastNotifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($appId)

# ��ʾToast֪ͨ
$toastNotifier.Show($toast)
pause