# Dofus CPU Rendering Switcher

Workaround for the blank black screen problem with AMD graphic cards on the game **Dofus**.

This script will switch the setting *Force CPU rendering* in the user's setting files (turning the setting on if it was off, and off if it was on)

## Usage (simple)

 - Search and open **Windows Powershell**
 - Copy and paste this one line command in Powershell :

       Invoke-Expression $((Invoke-WebRequest https://raw.githubusercontent.com/b95093cf/DofusCPURenderingSwitcher/main/dofus_switch_rendering.ps1).Content)

   Don't forget to press Enter.

   Once done the script will tell you if it switched on or off the CPU rendering
 - Play


## Alternative usage (little less simple)

 - Download the script [**dofus_switch_rendering.ps1**](https://raw.githubusercontent.com/b95093cf/DofusCPURenderingSwitcher/main/dofus_switch_rendering.ps1)
 - Open the file with **Windows PowerShell ISE**
 - Disable temporarly script execution restrictions by entering this command in the area with blue background
   
       Set-ExecutionPolicy Unrestricted -Scope Process
   
 - Run the script by clicking on the green *"play"* arrow or by pressing *F5*
 - Once done the script will tell you if it switched on or off the CPU rendering
 - Play

