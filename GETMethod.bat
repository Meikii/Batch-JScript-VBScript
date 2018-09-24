@if (@this==@isBatch) @then
@echo off
setlocal enableextensions
set url="www.yourapi.com"
rem -- force use 32-bit cscript
set path=%windir%\syswow64;%path%

cscript //nologo //e:jscript "%~f0" %*

endlocal

exit /b
@end

(function (vbe) {
    vbe.Language = "VBScript";
    vbe.AllowUI = true;

    var constants = "OK,Cancel,Abort,Retry,Ignore,Yes,No,OKOnly,OKCancel,AbortRetryIgnore,YesNoCancel,YesNo,RetryCancel,Critical,Question,Exclamation,Information,DefaultButton1,DefaultButton2,DefaultButton3".split(",");
    for (var i = 0; constants[i]; i++) {
        this["vb" + constants[i]] = vbe.eval("vb" + constants[i]);
    }

    InputBox = function (prompt, title, msg, xpos, ypos) {
        return vbe.eval('InputBox(' + [
            toVBStringParam(prompt),
            toVBStringParam(title),
            toVBStringParam(msg),
            xpos != null ? xpos : "Empty",
            ypos != null ? ypos : "Empty"
        ].join(",") + ')');
    };

    MsgBox = function (prompt, buttons, title) {
        return vbe.eval('MsgBox(' + [
            toVBStringParam(prompt),
            buttons != null ? buttons : "Empty",
            toVBStringParam(title)
        ].join(",") + ')');
    };

    function toVBStringParam(str) {
        return str != null ? 'Unescape("' + escape(str + "") + '")' : "Empty";
    }

    function getText(strURL) {
        var strResult;

        try {
            // Create the WinHTTPRequest ActiveX Object.
            var WinHttpReq = new ActiveXObject(
                "WinHttp.WinHttpRequest.5.1");

            //  Create an HTTP request.
            var temp = WinHttpReq.Open("GET", strURL, false);


            //  Send the HTTP request.
            WinHttpReq.Send();

            //  Retrieve the response text.
            strResult = WinHttpReq.ResponseText;
        }
        catch (objError) {
            strResult = objError + "\n"
            strResult += "WinHTTP returned error: " +
                (objError.number & 0xFFFF).toString() + "\n\n";
            strResult += objError.description;
        }

        //  Return the response text.
        return strResult;
    }
    var serial = InputBox("Enter serial", "serial");
    if(getText(url + serial)=="Serial Unlocked!")
    {
        MsgBox("Successfully un-registered!");
    }
    else
    {
        MsgBox("Failed to un-register.");
    }

})(new ActiveXObject("ScriptControl"));

