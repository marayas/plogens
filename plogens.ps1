Function Get-StringHash 
     
{    
     
     param
     (
   

        
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true,
        HelpMessage='Specify string to be hashed. Accepts from pipeline.')]
        [alias('text','InputObject')]
        [ValidateNotNullOrEmpty()]
        [string]
        $String,
        
        [Parameter(Mandatory=$true, Position=1, ValueFromPipeline=$false, ValueFromPipelineByPropertyName=$false,
        HelpMessage='Specify string to be hashed. Accepts from pipeline.')]
        [alias('HashName')]
        [ValidateSet('SHA1', 'SHA256', 'SHA384', 'SHA512', 'MACTripleDES', 'MD5', 'RIPEMD160')]
        [string]
        $Algorithm = 'SHA256'
     )
 
    $StringBuilder = New-Object -TypeName System.Text.StringBuilder 
    [System.Security.Cryptography.HashAlgorithm]::Create($Algorithm).ComputeHash([System.Text.Encoding]::UTF8.GetBytes($String)) | ForEach-Object -Process {
        [Void]$StringBuilder.Append($_.ToString('x2'))
    }

    
    $Private:properties = @{
        'String'    = $String
        'Hash'      = $StringBuilder.ToString() 
        'Algorithm' = $Algorithm
        
    }

    $Private:RetObject = New-Object -TypeName PSObject -Prop $properties | Sort-Object
    return $RetObject 
    
}


$Strings = Get-Content "shakeys.txt"

$result = foreach ($String in $Strings){

write-host -ForegroundColor green "Converting string $string"
Get-StringHash  -String $string  -Algorithm MD5 

}

$result | export-csv -NoTypeInformation .\plogens.csv