# This hopes to evaluate the source PHSS file and output text for XML and Opensong

Param(
[string]$Filepath
)

$source = Get-Content $Filepath

