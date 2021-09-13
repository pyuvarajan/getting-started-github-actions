#!/usr/bin/env bash

#set -euo pipefail

DEFID_BRCM="$(curl -s 'https://dev.azure.com/mssonic/build/_apis/build/definitions?name=Azure.sonic-buildimage.official.broadcom' | jq -r '.value[0].id')"
DEFID_MLNX="$(curl -s 'https://dev.azure.com/mssonic/build/_apis/build/definitions?name=Azure.sonic-buildimage.official.mellanox' | jq -r '.value[0].id')"
DEFID_VS="$(curl -s 'https://dev.azure.com/mssonic/build/_apis/build/definitions?name=Azure.sonic-buildimage.official.vs' | jq -r '.value[0].id')"

echo '{' > kvsk_f1.json
first=1
for BRANCH in 202012 202106 master
do
	if [ -z "${first}" ]; then
		echo '},' >> kvsk_f1.json
	fi
	first=''
	BUILD_BRCM="$(curl -s 'https://dev.azure.com/mssonic/build/_apis/build/builds?definitions='"${DEFID_BRCM}"'&branchName=refs/heads/'"${BRANCH}"'&$top=1&resultFilter=succeeded&api-version=6.0' | jq -r '.value[0].id')"
	BUILD_BRCM_TS="$(curl -s 'https://dev.azure.com/mssonic/build/_apis/build/builds/'"${BUILD_BRCM}"'?api-version=6.0' | jq -r '.queueTime')"
	BUILD_MLNX="$(curl -s 'https://dev.azure.com/mssonic/build/_apis/build/builds?definitions='"${DEFID_MLNX}"'&branchName=refs/heads/'"${BRANCH}"'&$top=1&resultFilter=succeeded&api-version=6.0' | jq -r '.value[0].id')"
	BUILD_MLNX_TS="$(curl -s 'https://dev.azure.com/mssonic/build/_apis/build/builds/'"${BUILD_MLNX}"'?api-version=6.0' | jq -r '.queueTime')"
	BUILD_VS="$(curl -s 'https://dev.azure.com/mssonic/build/_apis/build/builds?definitions='"${DEFID_VS}"'&branchName=refs/heads/'"${BRANCH}"'&$top=1&resultFilter=succeeded&api-version=6.0' | jq -r '.value[0].id')"
	BUILD_VS_TS="$(curl -s 'https://dev.azure.com/mssonic/build/_apis/build/builds/'"${BUILD_VS}"'?api-version=6.0' | jq -r '.queueTime')"

	#echo " [*] Last successful builds for \"${BRANCH}\":"
	#echo "     Broadcom: ${BUILD_BRCM}"
	#echo "     Mellanox: ${BUILD_MLNX}"
	#echo "     Virtual Switch: ${BUILD_VS}"

	ARTF_BRCM="$(curl -s 'https://dev.azure.com/mssonic/build/_apis/build/builds/'"${BUILD_BRCM}"'/artifacts?artifactName=sonic-buildimage.broadcom&api-version=5.1' | jq -r '.resource.downloadUrl')"
	ARTF_MLNX="$(curl -s 'https://dev.azure.com/mssonic/build/_apis/build/builds/'"${BUILD_MLNX}"'/artifacts?artifactName=sonic-buildimage.mellanox&api-version=5.1' | jq -r '.resource.downloadUrl')"
	ARTF_VS="$(curl -s 'https://dev.azure.com/mssonic/build/_apis/build/builds/'"${BUILD_VS}"'/artifacts?artifactName=sonic-buildimage.vs&api-version=5.1' | jq -r '.resource.downloadUrl')"


	echo "\"${BRANCH}\": {" >> kvsk_f1.json
	echo "\"sonic-broadcom.bin\": {" >> kvsk_f1.json
	echo "  \"url\": \"$(echo "${ARTF_BRCM}" | sed 's/format=zip/format=file\&subpath=\/target\/sonic-broadcom.bin/')\","  >> kvsk_f1.json
	echo "  \"build-url\": \"https://dev.azure.com/mssonic/build/_build/results?buildId=${BUILD_BRCM}&view=results\"," >> kvsk_f1.json
	echo "  \"build\": \"${BUILD_BRCM}\"," >> kvsk_f1.json
	echo "  \"date\": \"${BUILD_BRCM_TS}\"" >> kvsk_f1.json
	echo " }," >> kvsk_f1.json
	echo "\"sonic-aboot-broadcom.swi\": {" >> kvsk_f1.json
	echo "  \"url\": \"$(echo "${ARTF_BRCM}" | sed 's/format=zip/format=file\&subpath=\/target\/sonic-aboot-broadcom.swi/')\"," >> kvsk_f1.json
	echo "  \"build-url\": \"https://dev.azure.com/mssonic/build/_build/results?buildId=${BUILD_BRCM}&view=results\"," >> kvsk_f1.json
	echo "  \"build\": \"${BUILD_BRCM}\"," >> kvsk_f1.json
	echo "  \"date\": \"${BUILD_BRCM_TS}\"" >> kvsk_f1.json
	echo " }," >> kvsk_f1.json
	echo "\"sonic-mellanox.bin\": {" >> kvsk_f1.json
	echo "  \"url\": \"$(echo "${ARTF_MLNX}" | sed 's/format=zip/format=file\&subpath=\/target\/sonic-mellanox.bin/')\"," >> kvsk_f1.json
	echo "  \"build-url\": \"https://dev.azure.com/mssonic/build/_build/results?buildId=${BUILD_MLNX}&view=results\"," >> kvsk_f1.json
	echo "  \"build\": \"${BUILD_MLNX}\"," >> kvsk_f1.json
	echo "  \"date\": \"${BUILD_MLNX_TS}\"" >> kvsk_f1.json
	echo " }," >> kvsk_f1.json
	echo "\"sonic-vs.img.gz\": {" >> kvsk_f1.json
	echo "  \"url\": \"$(echo "${ARTF_VS}" | sed 's/format=zip/format=file\&subpath=\/target\/sonic-vs.img.gz/')\"," >> kvsk_f1.json
	echo "  \"build-url\": \"https://dev.azure.com/mssonic/build/_build/results?buildId=${BUILD_VS}&view=results\"," >> kvsk_f1.json
	echo "  \"build\": \"${BUILD_VS}\"," >> kvsk_f1.json
	echo "  \"date\": \"${BUILD_VS_TS}\"" >> kvsk_f1.json
	echo " }" # Final object >> kvsk_f1.json
	echo " }" >> kvsk_f1.json
done
echo " }" >> kvsk_f1.json
echo " }" >> kvsk_f1.json

git config --global user.email "kannankvs@gmail.com"
git config --global user.name "Kannan KVS"
git add kvsk_f1.json
git commit -m "first version of redirected file"
git push
