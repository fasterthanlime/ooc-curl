use curl
import curl/Curl
import io/FileWriter, structs/Array

main: func (args: Array<String>) {

    if(args size() <= 1) {
        printf("Usage: %s URL\n", args[0])
        exit(0)
    }
    url := args get(1)

    fName := "tmp.html"
    fw := FileWriter new(fName)

    handle := Curl new()
    handle setOpt(CurlOpt url, url)
    handle setOpt(CurlOpt writeData, fw)
    handle setOpt(CurlOpt writeFunction, func (buffer: Pointer, size: SizeT, nmemb: SizeT, fw: FileWriter) {
        fw write(buffer as String, nmemb)
    })

    handle perform()
    handle cleanup()
    fw close()

}
