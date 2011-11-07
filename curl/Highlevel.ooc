import io/[Writer, BufferWriter]
import structs/[HashMap, List, ArrayList]

import curl/Curl

FormData: class {
    post, last: HTTPPost

    init: func {
        post = null
        last = null
    }

    init: func ~fromHashMap (map: HashMap<String, String>) {
        init()
        addFromHashMap(map)
    }

    addField: func (key, value: String) {
        formAdd(post&, last&, CurlForm copyName, key toCString(), CurlForm copyContents, value toCString(), CurlForm end)
    }

    addFieldFileContent: func (key, filename: String) {
        formAdd(post&, last&, CurlForm copyName, key toCString(), CurlForm fileContent, filename toCString(), CurlForm end)
    }

    addFieldFile: func ~withContentTypeWithLocalFilename (key, localFilename, sendFilename, contentType: String) {
        formAdd(post&, last&,
                CurlForm copyName, key toCString(),
                CurlForm file, sendFilename toCString(),
                CurlForm fileName, localFilename toCString(),
                CurlForm contentType, contentType toCString(),
                CurlForm end)
    }

    addFieldFile: func ~lazy (key, filename: String) {
        formAdd(post&, last&, CurlForm copyName, key toCString(), CurlForm file, filename toCString(), CurlForm end)
    }

    free: func {
        formFree(post)
    }

    addFromHashMap: func (map: HashMap<String, String>) {
        for(key: String in map getKeys()) {
            addField(key, map[key])
        }
    }

    /* TODO: complete */
}

HTTPRequest: class {
    curl: Curl
    writer: Writer
    formData: FormData = null
    headers: List<String>

    defaultWriteFunction: static func (buffer: Pointer, size, nmemb: SizeT, self: HTTPRequest) {
        self writer write(buffer, nmemb)
    }

    init: func (url: String, =writer) {
        curl = Curl new()
        curl setOpt(CurlOpt writeData, this)
        curl setOpt(CurlOpt writeFunction, defaultWriteFunction)
        setUrl(url)
    }

    __destroy__: func {
        if(formData)
            formData free()
        curl cleanup()
    }

    init: func ~writeToBuffer (url: String) {
        init(url, BufferWriter new())
    }

    /**
     * Make this a POST request, and set its content
     */
    post: func ~fullContent (content: String) {
        curl setOpt(CurlOpt post, true)
        curl setOpt(CurlOpt postFields, content toCString())
    }

    header: func (header: String) {
        if(!headers) {
            headers = ArrayList<String> new()
        }
        headers add(header)
    }

    header: func ~keyValue (key, value: String) {
        header("%s: %s" format(key, value))
    }

    setUrl: func (url: String) {
        curl setOpt(CurlOpt url, url toCString())
    }

    setWriter: func (=writer) {}
    setFormData: func (=formData) {}

    perform: func -> Int {
        if(formData) {
            curl setOpt(CurlOpt httpPost, formData post)
        }

        slist: CurlSList
        if(headers) {
            slist = CurlSList new()
            for(header: String in headers) {
                "Adding header || %s" printfln(header)
                slist = slist append(header toCString())
            }
            curl setOpt(CurlOpt httpHeader, slist)
        }

        result := curl perform()

        if(headers) {
            slist free()
        }

        result
    }

    getString: func -> String {
        writer as BufferWriter buffer() toString()
    }

    /* methods for later (after perform) */

    /** return the HTTP/FTP response code. Will be 0 if
     * no server response code has been received. */
    getResponseCode: func -> Long {
        ret: Long
        curl getInfo(CurlInfo responseCode, ret&)
        ret
    }

}
