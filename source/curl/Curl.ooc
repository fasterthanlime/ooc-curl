use curl
include curl/curl, curl/easy

import net/berkeley

// curl types covers
CURLoption: extern cover
CURLcode: extern cover
CURLformoption: extern cover
CURLINFO: extern cover

// curl global functions covers
CURL_GLOBAL_ALL: extern Long
curl_global_init: extern func (flags: Long)
curl_global_init_mem: extern func (flags: Long, malloc, free, realloc, strdup, calloc: Pointer)

// code executed at startup:
version(gc) {
    curl_global_init_mem(CURL_GLOBAL_ALL, gc_malloc, gc_free, gc_realloc, gc_strdup, gc_calloc)
} else {
    curl_global_init(CURL_GLOBAL_ALL)
}

/**
 * CURL easy handle
 */
Curl: cover from CURL* {

    new: extern(curl_easy_init) static func -> This
    setOpt: extern(curl_easy_setopt) func (CURLoption, ...)
    perform: extern(curl_easy_perform) func -> Int
    cleanup: extern(curl_easy_cleanup) func
    getInfo: extern(curl_easy_getinfo) func (CURLINFO, ...)

    escape: extern(curl_easy_escape) static func ~lowlevel (Curl, CString, Int) -> CString
    escape: static func (url: String) -> String {
        escape(null, url toCString(), url size) toString()
    }
    
    unescape: extern(curl_easy_unescape) static func ~lowlevel (Curl, CString, Int, Int*) -> CString
    unescape: static func (url: String) -> String {
        outlength: Int
        cstr := unescape(null, url toCString(), url size, outlength&)
        String new(cstr, outlength)
    }
    
}

/**
 * CURL linked lists
 */
CurlSList: cover from Pointer { // should be curl_slist
    new: static func -> This { null }
    append: extern(curl_slist_append) func (s: CString) -> This
    free: extern(curl_slist_free_all) func
}

/**
 * CURL options.
 */
CurlOpt: cover {
    
    /* behavior options */
    verbose:    extern(CURLOPT_VERBOSE)    static CURLoption
    header:     extern(CURLOPT_HEADER)     static CURLoption
    noProgress: extern(CURLOPT_NOPROGRESS) static CURLoption
    noSignal:   extern(CURLOPT_NOSIGNAL)   static CURLoption
    
    /* callback options */
    writeFunction:           extern(CURLOPT_WRITEFUNCTION)              static CURLoption
    writeData:               extern(CURLOPT_WRITEDATA)                  static CURLoption
    readFunction:            extern(CURLOPT_READFUNCTION)               static CURLoption
    readData:                extern(CURLOPT_READDATA)                   static CURLoption
    ioCtlFunction:           extern(CURLOPT_IOCTLFUNCTION)              static CURLoption
    ioCtlData:               extern(CURLOPT_IOCTLDATA)                  static CURLoption
    seekFunction:            extern(CURLOPT_SEEKFUNCTION)               static CURLoption
    seekData:                extern(CURLOPT_SEEKDATA)                   static CURLoption
    sockOptFunction:         extern(CURLOPT_SOCKOPTFUNCTION)            static CURLoption
    sockOptData:             extern(CURLOPT_SOCKOPTDATA)                static CURLoption
    openSocketFunction:      extern(CURLOPT_OPENSOCKETFUNCTION)         static CURLoption
    openSocketData:          extern(CURLOPT_OPENSOCKETDATA)             static CURLoption
    progressFunction:        extern(CURLOPT_PROGRESSFUNCTION)           static CURLoption
    progressData:            extern(CURLOPT_PROGRESSDATA)               static CURLoption
    headerFunction:          extern(CURLOPT_HEADERFUNCTION)             static CURLoption
    writeHeader:             extern(CURLOPT_WRITEHEADER)                static CURLoption
    debugFunction:           extern(CURLOPT_DEBUGFUNCTION)              static CURLoption
    debugData:               extern(CURLOPT_DEBUGDATA)                  static CURLoption
    sslCtxFunction:          extern(CURLOPT_SSL_CTX_FUNCTION)           static CURLoption
    sslCtxData:              extern(CURLOPT_SSL_CTX_DATA)               static CURLoption
    convToNetworkFunction:   extern(CURLOPT_CONV_TO_NETWORK_FUNCTION)   static CURLoption
    convFromNetworkFunction: extern(CURLOPT_CONV_FROM_NETWORK_FUNCTION) static CURLoption
    convFromUtf8Function:    extern(CURLOPT_CONV_FROM_UTF8_FUNCTION)    static CURLoption
    
    /* error options */
    errorBuffer:             extern(CURLOPT_ERRORBUFFER)                static CURLoption
    stdErr:                  extern(CURLOPT_STDERR)                     static CURLoption
    failOnErr:               extern(CURLOPT_FAILONERR)                  static CURLoption
    
    /* network options */
    url:                     extern(CURLOPT_URL)                        static CURLoption
    protocols:               extern(CURLOPT_PROTOCOLS)                  static CURLoption
    redirProtocols:          extern(CURLOPT_REDIR_PROTOCOLS)            static CURLoption
    proxy:                   extern(CURLOPT_PROXY)                      static CURLoption
    proxyPort:               extern(CURLOPT_PROXYPORT)                  static CURLoption
    proxyType:               extern(CURLOPT_PROXYTYPE)                  static CURLoption
    noProxy:                 extern(CURLOPT_NOPROXY)                    static CURLoption
    httpProxyTunnel:         extern(CURLOPT_HTTPPROXYTUNNEL)            static CURLoption
    socks5GssApiService:     extern(CURLOPT_SOCKS5_GSSAPI_SERVICE)      static CURLoption
    socks5GssApiNec:         extern(CURLOPT_SOCKS5_GSSAPI_NEC)          static CURLoption
    // interface is a reserved keyword in ooc
    networkInterface:        extern(CURLOPT_INTERFACE)                  static CURLoption
    localPort:               extern(CURLOPT_LOCALPORT)                  static CURLoption
    localPortRange:          extern(CURLOPT_LOCALPORTRANGE)             static CURLoption
    dnsCacheTimeout:         extern(CURLOPT_DNS_CACHE_TIMEOUT)          static CURLoption  
    dnsUseGlobalCache:       extern(CURLOPT_DNS_USE_GLOBAL_CACHE)       static CURLoption   
    bufferSize:              extern(CURLOPT_BUFFERSIZE)                 static CURLoption   
    port:                    extern(CURLOPT_PORT)                       static CURLoption   
    tcpNoDelay:              extern(CURLOPT_TCP_NODELAY)                static CURLoption   
    addressScope:            extern(CURLOPT_ADDRESS_SCOPE)              static CURLoption   
    
    /* names and passwords options (authentification) */
    netRc:                   extern(CURLOPT_NETRC)                      static CURLoption
    netRcFile:               extern(CURLOPT_NETRC_FILE)                 static CURLoption
    userPwd:                 extern(CURLOPT_USERPWD)                    static CURLoption
    proxyUserPwd:            extern(CURLOPT_PROXYUSERPWD)               static CURLoption
    username:                extern(CURLOPT_USERNAME)                   static CURLoption
    password:                extern(CURLOPT_PASSWORD)                   static CURLoption
    proxyUsername:           extern(CURLOPT_PROXYUSERNAME)              static CURLoption
    proxyPassword:           extern(CURLOPT_PROXYPASSWORD)              static CURLoption
    httpAuth:                extern(CURLOPT_HTTPAUTH)                   static CURLoption
    proxyAuth:               extern(CURLOPT_PROXYAUTH)                  static CURLoption

    /* post options */
    post:                    extern(CURLOPT_POST)                       static CURLoption
    postFields:              extern(CURLOPT_POSTFIELDS)                 static CURLoption

    /* put options*/
    upload:                    extern(CURLOPT_UPLOAD)                       static CURLoption
    inFileSize:                    extern(CURLOPT_INFILESIZE)                       static CURLoption

    /* form/multipart options */
    httpPost:                extern(CURLOPT_HTTPPOST)                   static CURLoption   
    
    /* HTTP options */
    httpHeader:              extern(CURLOPT_HTTPHEADER)                 static CURLoption
    customRequest:           extern(CURLOPT_CUSTOMREQUEST)              static CURLoption
}

/**
 * Curl form options
 */
CurlForm: cover {
    copyName: extern(CURLFORM_COPYNAME) static CURLformoption
    ptrName: extern(CURLFORM_PTRNAME) static CURLformoption
    copyContents: extern(CURLFORM_COPYCONTENTS) static CURLformoption
    ptrContents: extern(CURLFORM_PTRCONTENTS) static CURLformoption
    contentsLength: extern(CURLFORM_CONTENTSLENGTH) static CURLformoption
    fileContent: extern(CURLFORM_FILECONTENT) static CURLformoption
    file: extern(CURLFORM_FILE) static CURLformoption
    contentType: extern(CURLFORM_CONTENTTYPE) static CURLformoption
    fileName: extern(CURLFORM_FILENAME) static CURLformoption
    buffer: extern(CURLFORM_BUFFER) static CURLformoption
    bufferPtr: extern(CURLFORM_BUFFERPTR) static CURLformoption
    bufferLength: extern(CURLFORM_BUFFERLENGTH) static CURLformoption
    stream: extern(CURLFORM_STREAM) static CURLformoption
    array: extern(CURLFORM_ARRAY) static CURLformoption
    contentHeader: extern(CURLFORM_CONTENTHEADER) static CURLformoption
    end: extern(CURLFORM_END) static CURLformoption
}

HTTPPost: cover from struct curl_httppost*
formAdd: extern(curl_formadd) func (firstitem, lastitem: HTTPPost*, ...) -> Int
formFree: extern(curl_formfree) func (form: HTTPPost) -> Int

/** CurlInfo for curl_easy_getinfo */
CurlInfo: cover {
    effectiveUrl: extern(CURLINFO_EFFECTIVE_URL) static CURLINFO
    responseCode: extern(CURLINFO_RESPONSE_CODE) static CURLINFO
    /* TODO: wrap */
}

CURLMcode: extern cover

MultiMsgType: enum {
    none
    done
    last
}

_MultiMsgData: cover { // TODO: really a union
    whatever: Pointer
    result: Int // TODO
}

MultiMsg: cover from CURLMsg {
    msg: MultiMsgType
    easyHandle: extern(easy_handle) Curl
    data: _MultiMsgData
}

CURLSocket: extern(curl_socket_t) cover
CURLMoption: extern cover
MultiErrorCode: enum {
    callMultiPerform = -1
    ok = 0
    badHandle
    badEasyHandle
    outOfMemory
    internalError
    badSocket
    unknownOption
    last
}

Poll: enum {
    none = 0
    in = 1
    out = 2
    inout = 3
    remove = 4
}

MultiOpt: cover {
    socketFunction: extern(CURLMOPT_SOCKETFUNCTION) static CURLMoption
    socketData: extern(CURLMOPT_SOCKETDATA) static CURLMoption
    pipelining: extern(CURLMOPT_PIPELINING) static CURLMoption
    timerFunction: extern(CURLMOPT_TIMERFUNCTION) static CURLMoption
    timerData: extern(CURLMOPT_TIMERDATA) static CURLMoption
    maxConnects: extern(CURLMOPT_MAXCONNECTS) static CURLMoption
}

CURL_SOCKET_TIMEOUT: extern Long

Multi: cover from CURLM* {
    new: extern(curl_multi_init) static func -> This
    addHandle: extern(curl_multi_add_handle) func (Curl) -> MultiErrorCode
    removeHandle: extern(curl_multi_remove_handle) func (Curl) -> MultiErrorCode
    fdset: extern(curl_multi_fdset) func (FdSet*, FdSet*, FdSet*, Int*) -> MultiErrorCode
    perform: extern(curl_multi_perform) func (Int*) -> MultiErrorCode
    cleanup: extern(curl_multi_cleanup) func -> MultiErrorCode
    infoRead: extern(curl_multi_info_read) func (Int*) -> MultiMsg*
    strerror: extern(curl_multi_strerror) static func (MultiErrorCode) -> Char*
    setOpt: extern(curl_multi_setopt) func (CURLMoption, ...) -> MultiErrorCode
    assign: extern(curl_multi_assign) func (CURLSocket, Pointer) -> MultiErrorCode
    timeout: extern(curl_multi_timeout) func (Long*) -> MultiErrorCode
    socket: extern(curl_multi_socket) func(CURLSocket, Int*) -> MultiErrorCode
    socketAction: extern(curl_multi_socket_action) func(CURLSocket, Int, Int*) -> MultiErrorCode
    socketAll: extern(curl_multi_socket_all) func(Int*) -> MultiErrorCode
}
