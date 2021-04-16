#!/usr/bin/env bash

SITE_SOURCE="http://images.mangafreak.net:8080/downloads/"

initialize() {
    while getopts m:s:e: flag
    do
        case "${flag}" in
            m) MANGA=${OPTARG};; 
            s) CHAPTER_START=${OPTARG};; 
            e) CHAPTER_END=${OPTARG};; 
        esac
    done

    EXTRACT_DIRECTORY=$MANGA
}

download_chapter() {
    local chapter_no=$1
    local file_downloaded=$MANGA\_$chapter_no
    local chapter_download_url=$SITE_SOURCE$file_downloaded

    wget -q --show-progress $chapter_download_url 

    local file_mimetype=$(file -bi $file_downloaded)

    if [[ $file_mimetype == "application/zip"* ]];
    then
        local extract_destination=$EXTRACT_DIRECTORY/CHAPTER_$(printf "%03d" $chapter_no)
        unzip -qd $extract_destination $file_downloaded
        rm $file_downloaded
    else
        echo "Not a zip file"
        exit 1
    fi
}

download() {
    mkdir -p $EXTRACT_DIRECTORY

    for (( chapter_no = $CHAPTER_START; chapter_no <= $CHAPTER_END; chapter_no++ ))
    do
        download_chapter $chapter_no
    done
}

main() {
    initialize $@
    download
}

main $@
