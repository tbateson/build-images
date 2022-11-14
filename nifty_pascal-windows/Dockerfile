FROM mcr.microsoft.com/windows/servercore:1809 AS base

FROM base AS pwr
SHELL ["powershell", "-command"]
RUN iex (iwr -UseBasicParsing 'https://raw.githubusercontent.com/airpwr/airpwr/main/src/install.ps1')

# Load up all the shipyard tools and initialize them
FROM pwr AS deploy
COPY pwr.json *.gradle ./
COPY src ./src/
RUN pwr sh; \
	pwr load sonar-scanner; \
	gradle -i --no-daemon doxygen test clean --rerun-tasks --refresh-dependencies; \
	pwr exit; \
	rm -r -fo pwr.json, src, *.gradle
