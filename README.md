# Photo_Archiver
Photo Archiver PS Script

This PowerShell script was created to archive photos on an Image Server.
The IT Team wanted this to be done in a specific way.
When the script runs it looks at the files by Year, Month, Date.
The script will create a folder structure based on the last write date of the file.
It creates a folder structure the following way CURRENTFOLDER/Year/Month/Date
In the final date folder all the photos that came in on that specific YY/MM/dd get zipped and put into that date folder.
It does this recursively for all photos.
