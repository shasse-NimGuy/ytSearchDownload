import std/osproc
import std/strformat
import std/httpclient
import std/strutils
import std/os

proc download(video: string) =
  discard execProcess(&"yt-dlp {video}")

proc getInfo(search: string): string =
  var client = newHttpClient()
  defer:
    client.close
  try:
    return client.getContent(search)
  except:
    echo "Failed to get content from " & search

proc getList(query: string): seq[string] =
  let info = getInfo(fmt"https://www.youtube.com/results?search_query={query}").split(
      """video_id","value":"""
    )
  for x in info[1 .. ^1]:
    result.add("https://www.youtube.com/watch?v=" & x[1 .. 11])

proc main() =
  var search = "memes"
  if paramCount() >= 2:
    echo "Too many params"
    quit()
  if paramCount() == 1:
    search = paramStr(1)
    echo "Quered > ", paramStr(1)

  let list = getList(search)
  for x in list:
    echo x

  for x in list:
    echo x
    download(x)
    echo "Done with > ", x, "\n"

when isMainModule:
  main()
