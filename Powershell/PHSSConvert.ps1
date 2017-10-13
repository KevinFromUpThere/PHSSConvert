# This will evaluate the source PHSS txt file and output files formatted for Opensong

<# Param(
[string]$Filepath,
[string]$OutputFolder
) #>

$Filepath = "C:\github\PHSSConvert\data\txt\Part2Formatted.txt"
$OutputFolder = "C:\github\PHSSConvert\data\output\"

$source = Get-Content $Filepath
$maxlines = $source.count
write-host Source File = $Filepath
write-host $maxlines total lines in the source file
$EOL = "`r`n"
$alphapattern = '[^a-zA-Z]'
$numberpattern = '[^0-9]'
$isfirstline = '1'
$SongHeader = '<?xml version="1.0" encoding="UTF-8"?>' + $EOL + ' <song> '
$CurrentSong = $SongHeader


foreach ($line in $source)
{

    #Empty Line, go to next line
<#     if ($line -match '[ ]+') 
    {   
        continue 
    }
 #>

    #Check for new song
    #If new song, Save previous song to file
     if ($line -match '[0-9]+ ')  #Add = but does not have a dot after the number  regex > "\n[1-9]+ "
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
                        <aka></aka>'+ $EOL
                        $CurrentSong = $CurrentSong + "<key_line>$firstline</key_line>"+ $EOL
                        $CurrentSong = $CurrentSong + '<user1></user1>
                        <user2></user2>
                        <user3></user3>
                        <theme></theme>
                        <linked_songs/>
                        <tempo></tempo>
                        <time_sig></time_sig>'+ $EOL
                       $CurrentSong = $CurrentSong + '<backgrounds resize="screen" keep_aspect="false" link="false" background_as_text="false"/>'+ $EOL + '</song>'+ $EOL

           #Handle writing of the previous song
            $OutPutFileName = $OutputFolder + $hymnnumber + ' ' + $firstline #+ '.txt'
        #    $CurrentSong >> $OutPutFileName
            $CurrentSong | Out-File -Encoding "UTF8" $OutPutFileName
  
           #Begin work on the current song
            $SongTuneName = $line -replace $alphapattern,''  #Clean numbers from this line
            $CurrentSong =  $SongHeader + $EOL + '<title>' + $line + '</title>'+ $EOL + '<lyrics>[V1]' + $EOL   #Make New CurrentSong
            $hymnnumber = $line  -replace $numberpattern,''  #Remove the tune name from the new song line, only the hymn number remains
            $isfirstline = '1'

        }


    #check for new verse
     if ($line -match '[2-9]+\.')  #Add - and DOES have a dot after the nunber regex > \n[1-9]+\.
        {     
           $line = $line  -replace $numberpattern,''  #remove the dot from the verse 
           $line = '[V' + $line + ']'
            $CurrentSong = $CurrentSong + $line + $EOL

        }

    #Regular Line of a song
    if ($line -match '[A-Z]+ ') 
        {   
              #to-do collect first line
              $CurrentSong = $CurrentSong + ' ' + $line + $EOL
              if ($isfirstline -eq '1') {
                  $firstline = $line -replace $alphapattern+' ','' #remove punctuation from first line so it can be used in filenames etc
                  $isfirstline = 0
              }
        }



}    
