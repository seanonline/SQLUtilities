###################################################################################
# Script: InstalSql_PS4.ps1
#
# Date : 27May-2017 
#
# Author: Sean Ch 
#
# PowerShell Script version tested : 4 
#
# Description: 
#
# Process the sql scripts in a specified directory $dir#
#
# Comments:
# ------------------------------------------------------------------------
#  Get-Content returns an array of lines rather than a string so got to use | Out-String
#  or  invoke-sqlcmd cmdlet has an -inputfile parameter 
####################################################################################


Set-ExecutionPolicy unrestricted;
Import-Module Sqlps -DisableNameChecking;

#set variables
$SQLInstance = "MachineName"

#Database Name
$DefaultDatabase = "Northwind"

# path to directory having sql files
$dir = "C:/Temp/storedProcedures"

$sqlfiles = get-childitem $dir

  
            # deploying many files so iterate through the files
            foreach($runfile in $sqlfiles.name) 
            {
                        $IsSQLErr = $false 

                        try
                        {
                            Write-Host 'Executing file... ', $runfile 

                             
                            # Get the content of the SQL Script
                           $SQLCommandText = Get-Content $dir\$runfile | Out-String                        


                            Write-Host 'text = ',$SQLCommandText 

                            
                            Invoke-Sqlcmd -Query $SQLCommandText -ServerInstance $SQLInstance -database $DefaultDatabase

                        }

                        #Error Detail 
                        catch 
                        { 
                            $IsSQLErr = $true 
                            Write-Host $Error[0] -ForegroundColor Red 
                            exit 1 
                        }

                        if(-not $IsSQLErr) 
                        { 
                                Write-Host 'FILE PROCESSED = ', $runfile 
                        } 
                        else 
                        { 
                                Write-Host "Execution step failed for:"  -ForegroundColor Red
                        } 
            }
 
  


