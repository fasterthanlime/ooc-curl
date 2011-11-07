use curl
import curl/Highlevel
import io/FileWriter, structs/ArrayList

main: func (args: ArrayList<String>) {

    if(args size <= 1) {
        "Usage: %s URL [DESTINATION]" printfln(args[0])
        exit(0)
    }
    url := args get(1)

    handle: HTTPRequest 
    downloadString: Bool
    if(args size > 2) {
        handle = HTTPRequest new(url, FileWriter new(args get(2)))
        downloadString = false
    } else {
        handle = HTTPRequest new(url)
        downloadString = true
    }
    handle perform()
    if(downloadString)
        handle getString() println()
    else
        handle writer close()
}
