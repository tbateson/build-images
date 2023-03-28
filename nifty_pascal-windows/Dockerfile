FROM mcr.microsoft.com/windows/servercore:1809 AS base

FROM base AS pwr
SHELL ["powershell", "-command"]
RUN Install-PackageProvider -Name NuGet -Force; \
	Set-PSRepository -Name PSGallery -InstallationPolicy Trusted; \
	Install-Module Airpower;

# Load up all the shipyard tools and initialize them
FROM pwr AS deploy
COPY Airpower.ps1 *.gradle ./
RUN pwr pull sonar-scanner; \
	pwr exec -ScriptBlock { gradle -i --no-daemon resolveDependencies --refresh-dependencies }; \
	if (-not $?) { throw \"gradle failed with exit code $LASTEXITCODE\" }; \
	rm -r -fo Airpower.ps1, *.gradle

# Create make.exe -> gmake.exe link
RUN Get-ChildItem -Path \\?\$env:LocalAppData\Airpower\content -Recurse -Include 'gmake.exe' | Select-Object -First 1 | ForEach-Object { New-Item -ItemType HardLink \"$($_.DirectoryName)\make.exe\" -Target $_ }
