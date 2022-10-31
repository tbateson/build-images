FROM mcr.microsoft.com/windows/servercore:1809 AS base

FROM base AS pwr
SHELL ["powershell", "-command"]
RUN iex (iwr -UseBasicParsing 'https://raw.githubusercontent.com/airpwr/airpwr/main/src/install.ps1')

# Load up all the shipyard tools and initialize them
FROM pwr AS shipyard
COPY pwr.json *.gradle ./
COPY src ./src/
RUN pwr sh; \
	gradle -i --no-daemon doxygen test clean --rerun-tasks --refresh-dependencies; \
	pwr exit; \
	rm -r -fo pwr.json, src, *.gradle

FROM shipyard AS deploy
RUN New-Item -ItemType file -Path $profile -Force; \
	pwr sh sonar-scanner:4; \
	$SonarScannerPath = ($env:PATH | Select-String '[^;]*sonar-scanner[^;]*').Matches[0].Value; \
	pwr exit; \
	Add-Content $profile \"`$env:PATH = \"\"`${env:PATH};$SonarScannerPath\"\"\"