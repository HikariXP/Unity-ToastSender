/*
 * Author: CharSui
 * Created On: 2024.04.16
 * Description: 通过一个PowerShell的脚本，自定义发起Windows Toast通知
 * dll示例地址:C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETCore\v4.5\System.Runtime.WindowsRuntime.dll
 */
using System.Diagnostics;
using System.IO;
using UnityEditor;

#if UNITY_EDITOR

public class CharSuiToast
{
	// todo:初始化->确认DLL存在以及位置
	
	private static string pluginPath = "Packages/com.charsui.toast/Plugins/ToastSenderTool.ps1";
	
	private static string pluginFullPath = Path.GetFullPath(pluginPath);

	private static string dllPath
	{
		get
		{
			#if UNITY_EDITOR_64
			return "Packages/com.charsui.toast/Plugins/dll/x64/System.Runtime.WindowsRuntime.dll";
			#else
			return "Packages/com.charsui.toast/Plugins/dll/x86/System.Runtime.WindowsRuntime.dll";
			#endif
		}
	}
	
	private static string dllFullPath = Path.GetFullPath(dllPath);

	[MenuItem("CharSuiToast/Check")]
	public static void SendTest()
	{
		SendToast("Unity", "123");
	}

	public static void SendToast(string title, string content)
	{
		PowerShell_RunScript(pluginFullPath, dllFullPath, title, content);
	}

	private static void PowerShell_RunScript(string scriptPath, string dllPath, string title, string content)
	{
		var startInfo = new ProcessStartInfo()
		{
			FileName = "powershell.exe",
			Arguments = $"-ExecutionPolicy Bypass -File \"{scriptPath}\" -dllPath \"{dllPath}\" -title \"{title}\" -content \"{content}\"",
			UseShellExecute = false,
			RedirectStandardOutput = true,
			RedirectStandardError = true, 
			CreateNoWindow = true
		};

		var process = new Process() { StartInfo = startInfo };
		process.Start();
		
		//To avoid deadlocks, always read the output stream first and then wait.
		string error = process.StandardError.ReadToEnd();
		process.WaitForExit();
		
		if (!string.IsNullOrEmpty(error))
		{
			UnityEngine.Debug.LogError($"Error: {error}");
		}
	}
}

#endif