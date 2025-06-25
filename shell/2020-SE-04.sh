#!/bin/bash


src=$1
dst=$2

imgs=$(mktemp)

mkdir -p $dst

mkdir -p $dst/images

mkdir -p $dst/by-date
mkdir -p $dst/by-album
mkdir -p $dst/by-title

getTitle ()
{

    str=$1

    echo $str | sed -e "s/([0-9a-zA-Z[:space:]]*)//g" | sed -e "s/.*\///g" -e "s/  / /g" -e "s/\.jpg//g"
}



for i in $1/*.jpg
do
    [[ -f "$i" ]] || continue


    title=$(getTitle "$i")
    album=$(echo $i |  sed -e "s/.*(\([0-9a-zA-Z[:space:]]*\))[0-9a-zA-Z[:space:]]*\.jpg/\1/g" )
    if [[ $album == $i ]]; then
        album="misc"
    fi
    date=$(stat -c %y "$i" | cut -d ' ' -f1)
    hasha=$(sha256sum "$i" | cut -c1-16)

    mkdir -p $dst/images

    img="$dst/images/$hasha.jpg"

    if [[ ! -f "$img" ]]; then
        cp "$i" "$img"
    fi

    mkdir -p "$dst/by-date/$date/by-album/$album/by-title"
    ln -sf "../../../images/$hasha.jpg" "$dst/by-date/$date/by-album/$album/by-title/$title.jpg"

    mkdir -p "$dst/by-date/$date/by-title"
    ln -sf "../../images/$hasha.jpg" "$dst/by-date/$date/by-title/$title.jpg"

    mkdir -p "$dst/by-album/$album/by-date/$date/by-title"
    ln -sf "../../../../images/$hasha.jpg" "$dst/by-album/$album/by-date/$date/by-title/$title.jpg"

    mkdir -p "$dst/by-album/$album/by-title"
    ln -sf "../../images/$hasha.jpg" "$dst/by-album/$album/by-title/$title.jpg"

    mkdir -p "$dst/by-title"
    ln -sf "images/$hasha.jpg" "$dst/by-title/$title.jpg"

done
