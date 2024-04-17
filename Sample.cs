/*
 * Copyright (c) PeroPeroGames Co., Ltd.
 * Author: CharSui
 * Created On: 2024.04.16
 * Description: 通过一个PowerShell的脚本，自定义发起Windows Toast通知
 */
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Runtime.InteropServices;
using System;
using UnityEditor;
using UnityEngine;

public class NotificationTool
{
	[MenuItem("NotificationTest")]
	public static void SendTest()
	{
		// the path to ps1 you save
		string batPath = Path.Combine(Application.dataPath, "../NativePluginSrc/ToastSender.ps1");
		
		// GetFullPath to filter the "\"
		string path = Path.GetFullPath(batPath);
		
		// Inovke the script
		PowerShell_RunScript(path,"Unity","123");
	}
	
	private static void PowerShell_RunScript(string scriptPath, string title, string content)
	{
		var startInfo = new ProcessStartInfo()
		{
			FileName = "powershell.exe",
			Arguments = $"-ExecutionPolicy Bypass -File \"{scriptPath}\" -title \"{title}\" -content \"{content}\"",
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
