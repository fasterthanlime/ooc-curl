use curl
import curl/Curl
import io/FileWriter, structs/ArrayList

writecb: func (buffer: Pointer, size: SizeT, nmemb: SizeT, fw: FileWriter) {
    fw write(buffer as CString, nmemb)
}

main: func (args: ArrayList<String>) {

    if(args size <= 1) {
        "Usage: %s URL\n" printfln(args[0])
        exit(0)
    }
    url := args get(1)

    fName := "tmp.html"
    fw := FileWriter new(fName)

    handle := Curl new()
    handle setOpt(CurlOpt url, url toCString())
    handle setOpt(CurlOpt writeData, fw)
    handle setOpt(CurlOpt writeFunction, writecb)

    handle perform()
    handle cleanup()
    fw close()

}
