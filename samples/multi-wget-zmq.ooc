/* A simple example how to use the libcurl multi interface with ooczmq */

use czmq
import czmq

use curl
import curl/Curl
import io/FileWriter, structs/[ArrayList, HashMap]

multi := Multi new()
ctx := Context new() // just so we get a fancy SIGTERM handling and get to close our file
zloop := Loop new()
listeners := HashMap<Int, LoopCallback> new()
ztimer: LoopCallback

remaining: Int

writecb: func (buffer: Pointer, size: SizeT, nmemb: SizeT, fw: FileWriter) {
    fw write(buffer as CString, nmemb)
}

/** see if there are any finished transfers, and if yes, free their handles */
checkHandles: func {
    "Check my handles!" println()
    queued := 0
    msg: MultiMsg*
    toRemove := ArrayList<Curl> new()
    while(true) {
        msg = multi infoRead(queued&)
        if(msg == null) break
    
        if(msg@ msg == MultiMsgType done) {
            // hey yeah, we're done!
            curlCode := msg@ data result
            "Completed a handle with curl code %d" printfln(curlCode)

            // remove the handle
            toRemove add(msg@ easyHandle)
        } else {
            "Unknown curl message type: %d" printfln(msg@ msg)
        }
    }

    for(handle in toRemove) {
        effUrl: CString
        handle getInfo(CurlInfo effectiveUrl, effUrl&)

        "Removing handle %s!" printfln(effUrl toString())
        multi removeHandle(handle)
        handle cleanup()
    }
}

/* called by mainloop when there's data available on a watched socket */
dataCb: func (zloop: Loop, item: PollItem, cb: LoopCallback) {
    result := MultiErrorCode callMultiPerform
    while(result == MultiErrorCode callMultiPerform) {
        result = multi socketAction(item@ fd as CURLSocket, 0, remaining&) // TODO: we don't need to pass 0 here
    }
    checkHandles()
}

/* called by curl when we should listen for events on a certain socket */
socketCb: func (easy: Curl, sock: Int, what: Int, userp: Pointer, socketp: Pointer) -> Int {
    "Should listen for %d on %d" printfln(what, sock as Long)
    match (what) {
        case Poll none => { "Nothing? Interesting." println() }
        case Poll remove => {
            "Remove meeeeh!" println()
            cb := listeners get(sock)
            if(!cb) {
                "I don't know this socket." println()
            } else {
                zloop removeEvent(cb)
                listeners remove(sock)
            }

        }
        case => {
            // translate event masks
            events: ZMQ = match (what) {
                case Poll in => ZMQ POLLIN
                case Poll out => ZMQ POLLOUT
                case Poll inout => ZMQ POLLIN | ZMQ POLLOUT
            }
            "zmq event mask: %d" printfln(events)
            cb := zloop addEvent(sock, events, dataCb)
            listeners add(sock, cb)
        }
    }
    0
}

/* called by curl when the timeout value changes. set a new timeout if needed. */
multiTimeoutCb: func (multi: Multi, timeout: Long, userp: Pointer) -> Int {
    "Timeout changed! %d" printfln(timeout)
    match(timeout) {
        case -1 => {
            // no timeout! just chill
        }
        case 0 => {
            // call timeoutCb immediately
            timeoutExpired()
        }
        case => {
            // set a new timeout
            if(ztimer != null) {
                zloop removeTimer(ztimer)
            } // TODO. we don't really need that.
            ztimer = zloop addTimer(timeout, 1, timeoutCb)
        }
    }
    0
}

/* called by our czmq zloop after our timeout has expired. initially called
   once by `multiTimeoutCb` because we need to do a sole
   `socketAction` call for a kickstart. */
timeoutCb: func (zloop: Loop, item: PollItem, cb: LoopCallback) {
    timeoutExpired()
}

timeoutExpired: func {
    "Timeout expired!" println()
    result := MultiErrorCode callMultiPerform
    while(result == MultiErrorCode callMultiPerform) {
        result = multi socketAction(CURL_SOCKET_TIMEOUT as CURLSocket, 0, remaining&)
    }

    checkHandles()
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

    multi setOpt(MultiOpt socketFunction, socketCb)
    multi setOpt(MultiOpt timerFunction, multiTimeoutCb)

    multi addHandle(handle)
   
    // just let the timeout expire now, once, so we can call `socketAction`.
    zloop addTimer(0, 1, timeoutCb)

    zloop start()
    
//    handle cleanup() // cleaned automagically!
    fw close()

}
