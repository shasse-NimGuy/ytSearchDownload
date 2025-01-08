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
    return ret.add(temp)

    

proc getList(query: string): seq[string] =
    var check: string
    var ret: string
    var count = 0
    var video: seq[string]
    let info = getInfo(fmt"https://www.youtube.com/results?search_query={query}")
    for x in info:
        if x == 'v':
            if info[count + 1] == 'i': 
                for x in 0 .. 7:
                    check.add(info[count + x])
                    if check == "video_id":
                        for x in 0 .. 30:
                            ret.add(info[count + x])

                        video.add(transform(ret))
                        ret = ""
                check = ""
        count = count + 1
    return video




proc main() =
    var search = "memes"
    if paramCount() >= 2:
        echo "Too many params"
        quit()
    elif paramCount() > 0:
        search = paramStr(1)
        echo "Quered > ", paramStr(1)


    for x in getList(search):
        echo x
        download(x)
        echo "Done with > ",x
        echo "\n" 









main()