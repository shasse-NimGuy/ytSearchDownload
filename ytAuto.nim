import std/osproc 
import std/strformat
import std/httpclient
import std/strutils
import std/os




proc download(video: string) = 
    discard execProcess(&"yt-dlp {video}")
   

proc getInfo(search: string): string = 
    var client = newHttpClient()
    try:
        return client.getContent(search)
    finally:
        client.close()

proc transform(sett: string): string =
    var ret = "https://www.youtube.com/watch?v="
    var temp: string
    temp = sett.replace("""video_id","value":""", "")
    temp = temp.replace(""""""", "")
    ret.add(temp)
    return ret

    

proc getList(query: string): seq[string] =
    var check: string
    var vid_id: string
    var count = 0
    var videos: seq[string]
    let info = getInfo(fmt"https://www.youtube.com/results?search_query={query}")
    for x in info:
        if x == 'v':
            if info[count + 1] == 'i': 
                for x in 0 .. 7:
                    check.add(info[count + x])
                    if check == "video_id":
                        for x in 0 .. 30:
                            vid_id.add(info[count + x])

                        videos.add(transform(vid_id))
                        vid_id = ""
                check = ""
        count = count + 1
    return videos




proc main() =
    var search = "memes"
    if paramCount() >= 2:
        echo "Too many params"
        quit()
    elif paramCount() > 0:
        search = paramStr(1)
        echo "Quered > ", paramStr(1)

    let list = getList(search)
    for x in list:
        echo x


    for x in list:
        echo x
        download(x)
        echo "Done with > ",x
        echo "\n" 









main()