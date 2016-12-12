# This hopes to evaluate the source PHSS file and output text for XML and Opensong

Param(
[string]$Filepath
)

$source = Get-Content $Filepath
$maxlines = $source.count
write-host $maxlines total lines in the source file

foreach ($line in $source)
{

#Regular Line of a song
if $line.StartsWith("[a-z]")
    {   
        $CurrentSong = $CurrentSong + $line
     }
#check for new verse




#Check for new song


#Save file
$OutPutFileName = $SongTitle + '.txt'
$CurrentSong >> $OutPutFileName
$CurrentSong = $null


}    
