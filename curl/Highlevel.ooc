import io/Writer
import text/StringBuffer
import structs/HashMap

import curl/Curl

FormData: class {
    post, last: HTTPPost

    init: func {
        post = null
        last = null
    }

    init: func ~fromHashMap (map: HashMap<String>) {
        init()
        addFromHashMap(map)
    }

    addField: func (key, value: String) {
        formAdd(post&, last&, CurlForm copyName, key, CurlForm copyContents, value, CurlForm end)
    }

    addFieldFileContent: func (key, filename: String) {
        formAdd(post&, last&, CurlForm copyName, key, CurlForm fileContent, filename, CurlForm end)
    }

    addFieldFile: func ~withContentTypeWithLocalFilename (key, localFilename, sendFilename, contentType: String) {
        formAdd(post&, last&, \
                CurlForm copyName, key, \
                CurlForm file, sendFilename, \
                CurlForm fileName, localFilename, 
                CurlForm contentType, contentType, \
                CurlForm end)
    }

    addFieldFile: func ~lazy (key, filename: String) {
        formAdd(post&, last&, CurlForm copyName, key, CurlForm file, filename, CurlForm end)
    }

    free: func {
        formFree(post)
    }

    addFromHashMap: func (map: HashMap<String>) {
        for(key: String in map keys) {
            addField(key, map[key])
        }
    }

    /* TODO: complete */
}

HTTPRequest: class {
    curl: Curl
    writer: Writer
    post: FormData

    init: func (url: String, =writer) {
        post = null
        curl = Curl new()
        curl setOpt(CurlOpt writeData, this)
        curl setOpt(CurlOpt writeFunction, func (buffer: Pointer, size, nmemb: SizeT, self: HTTPRequest) {
            self writer write(buffer, nmemb)
        })
        setUrl(url)
    }

    __destroy__: func {
        if(post)
            post free()
        curl cleanup()
        "yo" println()
    }

    init: func ~writeToBuffer (url: String) {
        init(url, StringBuffer new())
    }

    setUrl: func (url: String) {
        curl setOpt(CurlOpt url, url)
    }

    setWriter: func (=writer) {}
    setPost: func (=post) {}

    perform: func -> Int {
        if(post)
            curl setOpt(CurlOpt httpPost, post)
        curl perform()
    }

    getString: func -> String {
        writer as StringBuffer toString()
    }
}
