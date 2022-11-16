FROM mcr.microsoft.com/windows/servercore:1809 AS base

FROM base AS pwr
SHELL ["powershell", "-command"]
RUN iex (iwr -UseBasicParsing 'https://raw.githubusercontent.com/airpwr/airpwr/main/src/install.ps1')

# Load up all the shipyard tools and initialize them
FROM pwr AS deploy
COPY pwr.json *.gradle ./
RUN pwr sh; \
	pwr load sonar-scanner; \
	gradle -i --no-daemon resolveDependencies --rerun-tasks --refresh-dependencies; \
	pwr exit; \
	rm -r -fo pwr.json, *.gradle

# Create make.exe -> gmake.exe link
RUN Get-ChildItem -Path $env:AppData\pwr\pkg\perl-* -Recurse -Include 'gmake.exe' | Select-Object -First 1 | ForEach-Object { New-Item -ItemType HardLink \"$($_.DirectoryName)\make.exe\" -Target $_ }
