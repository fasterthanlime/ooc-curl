use curl
include curl/curl, curl/easy

// code executed at startup:
curl_global_init(CURL_GLOBAL_ALL)

// curl types covers
CURLoption: extern cover
CURLcode: extern cover
CURLformoption: extern cover

// curl global functions covers
CURL_GLOBAL_ALL: extern Long
curl_global_init: extern func (Long)

/**
 * CURL easy handle
 */
Curl: cover from CURL* {

    new: extern(curl_easy_init) static func -> This
    setOpt: extern(curl_easy_setopt) func (CURLoption, ...)
    perform: extern(curl_easy_perform) func -> Int
    cleanup: extern(curl_easy_cleanup) func

}

/**
 * CURL options.
 */
CurlOpt: cover {
    
    /* behavior options */
    verbose:    extern(CURLOPT_VERBOSE)   static CURLoption
    header:     extern(CURLOPT_HEADER)    static CURLoption
    noProgress: extern(CURLOPT_HEADER)    static CURLoption
    noSignal:   extern(CURLOPT_NOSIGNAL)  static CURLoption
    
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

    /* form/multipart options */
    httpPost:                extern(CURLOPT_HTTPPOST)                   static CURLoption   
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
