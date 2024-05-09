#    Description:
# This script is a workaround to the blank black screen problem in the game Dofus with AMD graphic cards.
# It enables the forceRenderCPU setting without going into the menu inside the game
#
#    Author: b95093cf (oXmz)
# Thanks to InfiniteFox for his investigations

# CONSTANTS
$SETTINGS_PATH = [System.Environment]::ExpandEnvironmentVariables('%appdata%\Dofus\dofus.dat')
$BACKUP_SETTINGS_PATH = $SETTINGS_PATH + ".bak"
$PATTERN_TO_FIND_STR = "forceRenderCPU"
$PATTERN_TO_FIND = [System.Text.Encoding]::ASCII.GetBytes($PATTERN_TO_FIND_STR)
$ERR_SETTINGS_FILE_NOT_FOUND = 80
$ERR_PATTERN_NOT_FOUND = 81
$ERR_CANT_EDIT_SETTINGS = 82
$ERR_UNEXPECTED = 90


# Function to find a bytes array inside another bytes array
function Find-Pattern ($bytes, $pattern) {
    for ($i = 0; $i -le $bytes.Length - $pattern.Length; $i++) {
        for ($j = 0; $j -lt $pattern.Length; $j++) {
            if ($bytes[$i + $j] -ne $pattern[$j]) {
                break
            }
            if ($j -eq $pattern.Length - 1) {
                return $i
            }
        }
    }
    return -1
}

if (-Not (Test-Path -Path $SETTINGS_PATH)) {
	Write-Error "The settings file can't be found: $SETTINGS_PATH"
	exit $ERR_SETTINGS_FILE_NOT_FOUND
}

# Read Dofus settings file
Write-Output " - Reading the file $SETTINGS_PATH ..."
$binaryData = [System.IO.File]::ReadAllBytes($SETTINGS_PATH)

# Find the index of the pattern "forceRenderCPU" (as bytes) in the file
Write-Output " - Finding '$PATTERN_TO_FIND_STR' in the file ..."
$index = Find-Pattern -bytes $binaryData -pattern $PATTERN_TO_FIND

# If we found the pattern
if ($index -ne -1) {
    $nextByteIndex = $index + $PATTERN_TO_FIND.Length

    if ($binaryData[$nextByteIndex] -eq 0x02) {
        $binaryData[$nextByteIndex] = 0x03

        # Write the modified data back to the file
		Write-Output " - Writing the changes back to the settings file $SETTINGS_PATH ..."
		try {
			[System.IO.File]::WriteAllBytes($SETTINGS_PATH, $binaryData)
			Write-Output " "
			Write-Output "The CPU rendering has been enabled."
		}
		catch {
			Write-Error "Can't modify the settings: $_"
			exit $ERR_CANT_EDIT_SETTINGS
		}
    }
	elseif ($binaryData[$nextByteIndex] -eq 0x03) {
        $binaryData[$nextByteIndex] = 0x02

        # Write the modified data back to the file
		Write-Output " - Writing the changes back to the settings file $SETTINGS_PATH ..."
		try {
			[System.IO.File]::WriteAllBytes($SETTINGS_PATH, $binaryData)
			Write-Output " "
			Write-Output "\nThe CPU rendering has been disabled."
		}
		catch {
			Write-Error "Can't modify the settings: $_"
			exit $ERR_CANT_EDIT_SETTINGS
		}
    }
	else {
		Write-Error "The byte following the pattern has an unexpected value"
		exit $ERR_UNEXPECTED
	}
} else {
    Write-Error "The pattern '$PATTERN_TO_FIND_STR' was not found in the file."
	exit $ERR_PATTERN_NOT_FOUND
}
