# This hopes to evaluate the source PHSS file and output text for XML and Opensong

Param(
[string]$Filepath,
[string]$OutputFolder
)

$source = Get-Content $Filepath
$maxlines = $source.count
write-host Source File = $Filepath
write-host $maxlines total lines in the source file
$EOL = "`r`n"
$alphapattern = '[^a-zA-Z]'
$numberpattern = '[^0-9]'
$CurrentSong = '<?xml version="1.0" encoding="UTF-8"?>' + $EOL + ' <song> '

foreach ($line in $source)
{

    #Check for new song
    #If new song, Save previous song to file
     if ($line -match '[1-9]+ ')  #Add = but does not have a dot after the number  regex > "\n[1-9]+ "
        {     
           #finish the previous song file
            $CurrentSong = $CurrentSong + '</lyrics>
                        <author></author>
                        <copyright></copyright>'+ $EOL
                         $CurrentSong = $CurrentSong + "<hymn_number>$hymnnumber</hymn_number>"+ $EOL
                        $CurrentSong = $CurrentSong + '<presentation></presentation>
                        <ccli></ccli>
                        <capo print="false"></capo>
                        <key></key>
                        <aka></aka>
                        <key_line></key_line>
                        <user1></user1>
                        <user2></user2>
                        <user3></user3>
                        <theme></theme>
                        <linked_songs/>
                        <tempo></tempo>
                        <time_sig></time_sig>'+ $EOL
                       $CurrentSong = $CurrentSong + '<backgrounds resize="screen" keep_aspect="false" link="false" background_as_text="false"/>'+ $EOL + '</song>'+ $EOL

           #Handle writing of the previous song
            $OutPutFileName = $OutputFolder + $songtitle + '.txt'
            $CurrentSong >> $OutPutFileName
  
           #Begin work on the current song
            $SongTuneName = $line.Replace($alphapattern,'') 
            $CurrentSong = $CurrentSong = '<?xml version="1.0" encoding="UTF-8"?>' + $EOL + ' <song> '+ $EOL
            $CurrentSong = $CurrentSong + '<title>' + $line + '</title>'+ $EOL + '<lyrics> [V1]' + $EOL
            $songtitle = $line  #todo add first line to this
            $hymnnumber = $line.Replace($numberpattern,'')

        }


    #check for new verse
     if ($line -match '[2-9]+\.')  #Add - and DOES have a dot after the nunber regex > \n[1-9]+\.
        {     
           # write-host new verse $line
           $line = $line.replace(' ','')
           $line = '[V' + $line.replace('.','') + ']'
            $CurrentSong = $CurrentSong + $line + $EOL

        }

    #Regular Line of a song
    if ($line -match '[A-Z]+ ') 
        {   
              #to-do collect first line
              # write-host normal line $line
              $CurrentSong = $CurrentSong + $line + $EOL
        }



}    
