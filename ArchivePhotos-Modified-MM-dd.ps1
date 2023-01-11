# Search File Path
$SearchPath = "C:\script_testing\Photos_Folder"
# Get all the folders which has files (all done,fail,accept,reject folder will be retrieved)
$AllFolders = Get-ChildItem -Path $SearchPath -Recurse | Where-Object {$_.PsIsContainer -and  $_.GetFiles().Count -gt 0}
# Loop through each folders
foreach($Folder in $AllFolders)
{
  # Get all Png files in a folder and group by Last Write Date
  $Groups = Get-ChildItem -Path $Folder.FullName -File -Filter *.png |Select-Object *,@{Name="LastWriteDate";Expression={(Get-Date $_.LastWriteTime).Date}}| Group-Object LastWriteDate
  # Loop though each group
  foreach($Group in $Groups)
  {
   try
   {
        # Check group has values
        if($Group.Group.Count -gt 0)
        {
            # Get the last write date to format zip file name
            $ZipFileName = Get-Date $Group.Group[0].LastWriteDate -Format "MMddyyyy"
            # Get the year
            $Year = (Get-Date $Group.Group[0].LastWriteDate).Year
            # Get the month
            $Month = Get-Date $Group.Group[0].LastWriteDate -Format "MM"
            # Get the dtae
            $Date = Get-Date $Group.Group[0].LastWriteDate -Format "dd"
            # Get the current path of these files
            $CurrentFolder = $Group.Group[0].DirectoryName
            # Form destination path
            $ArchivePath = "$CurrentFolder/Archive/$Year/$Month/$Date"
            # Check destination path is available, if not available
            if(-not (Test-Path $ArchivePath))
            {
              # Create the destination path
              New-Item -Path $ArchivePath -ItemType Directory | Out-Null
            }
            # Compress all the grouped files in the zip file
            Compress-Archive -Path $Group.Group.FullName -DestinationPath "$ArchivePath\$ZipFileName.zip" -CompressionLevel Optimal -ErrorAction Stop -Update
            # Remove all the zipped files
            Remove-Item -Path $Group.Group.FullName
        }
     }
     catch
     {
       Write-Host $_
     }
  }
}