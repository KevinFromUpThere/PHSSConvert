# This hopes to evaluate the source PHSS file and output text for XML and Opensong

Param(
[string]$Filepath
)

$source = Get-Content $Filepath
$maxlines = $source.count
write-host Source File = $Filepath
write-host $maxlines total lines in the source file

foreach ($line in $source)
{

    #Check for new song
    #If new song, Save previous song to file
     if ($line.StartsWith("[1-9]"))  #Add = but does not have a dot after the number
        {     
            $OutPutFileName = $line + '.txt'
            $CurrentSong >> $OutPutFileName
            $CurrentSong = $null
        }


    #check for new verse
     if ($line.StartsWith("[1-9]"))  #Add - and DOES have a dot after the nunber
        {     

        }

    #Regular Line of a song
    if ($line.StartsWith("[a-z]"))
        {   
            $CurrentSong = $CurrentSong + $line

        }


}    
