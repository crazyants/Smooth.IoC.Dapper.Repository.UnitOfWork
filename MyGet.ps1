﻿$ErrorActionPreference = "Stop"

$packageVersion = ($env:PackageVersion)
$configuration = ($env:Configuration)
$msBuildExe = ($env:MsBuildExe)
$msBuildTarget = ($env:Targets)

MyGet-Write-Diagnostic ""
MyGet-Write-Diagnostic ""
MyGet-Write-Diagnostic "###### Run all tests ######"
& "$PSScriptRoot\.nuget\nuget.exe" restore "$PSScriptRoot\Smooth.IoC.Dapper.Repository.UnitOfWork.sln"
if ($LASTEXITCODE -ne 0){
    throw "nuget restore failed"
}

MyGet-Write-Diagnostic ""
MyGet-Write-Diagnostic ""
MyGet-Write-Diagnostic "###### build the solution ######"
& "$msBuildExe" "$PSScriptRoot\Smooth.IoC.Dapper.Repository.UnitOfWork.sln" /t:"$msBuildTarget" /p:Configuration="$configuration"
if ($LASTEXITCODE -ne 0){
    throw "build failed"
}

MyGet-Write-Diagnostic ""
MyGet-Write-Diagnostic ""
MyGet-Write-Diagnostic "###### Run all tests ######"
& "$PSScriptRoot\.nunit\nunit3-console.exe" "$PSScriptRoot\src\Smooth.IoC.Dapper.Repository.UnitOfWork.Tests\bin\$configuration\Smooth.IoC.Dapper.Repository.UnitOfWork.Tests.dll"
if ($LASTEXITCODE -ne 0){
    throw "tests failed"
}

MyGet-Write-Diagnostic ""
MyGet-Write-Diagnostic ""
MyGet-Write-Diagnostic "###### create the NuGet packages ######"
& "$PSScriptRoot\.nuget\nuget.exe" pack "$PSScriptRoot\NuGetSpecs\Smooth.IoC.Dapper.Repository.UnitOfWork.nuspec" -OutputDirectory "$PSScriptRoot\Releases" -Version "$packageVersion" -Properties configuration="$configuration" -Verbosity detailed
if ($LASTEXITCODE -ne 0){
    throw "Nuget library packaging failed"
}

