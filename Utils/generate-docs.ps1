cd $PSScriptRoot
$templates = Get-ChildItem "..\Templates\" -Filter *.json

ForEach ($template in $templates){
  $inFile = $template.Name
  $fileName = $inFile.TrimEnd('.json')
  $outFile = $fileName + ".md"
  $fileExists = Test-Path "..\Docs\$outfile"
  if ($fileExists){
      "Markdown file $outFile already exists"
    } else {
      New-Item -Path "..\Docs" -Name $outFile -ItemType "file" -Value "This is the initial markdown for $infile"
      $content = Get-Content -Path "template.md"
      Set-Content -Path "..\Docs\$outFile" -Value $content 
    }
  
  $templateParams = Get-Content -Path "..\Templates\$inFile" | ConvertFrom-Json
  foreach($param in ($templateParams.parameters | Get-Member -MemberType NoteProperty).Name){
    $paramType = ($templateParams.parameters.$param).type
    $paramValue = ($templateParams.parameters.$param).defaultValue
    
    Add-Content -Path "..\Docs\params.md" -Value "#### Parameter Name : $param"
    Add-Content -Path "..\Docs\params.md" -Value "    Type: $paramType"
    Add-Content -Path "..\Docs\params.md" -Value "    Default Value: $paramValue"
  }
  }
