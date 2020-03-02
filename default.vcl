vcl 4.0;

backend tinyproxy {
    .host = "127.0.0.1";
    .port = "8888";
}

sub vcl_recv {

    # Wenn kein .jpg, .png oder .jpeg am Ende steht -> 404
    if(req.url !~ "\.jpg$" && req.url !~ "\.png$" && req.url !~ "\.jpeg$"){
        # Kein Bild gefunden
        set req.http.picfound = "false";
        
        return (synth(404));
    }

    # Bild gefunden
    set req.http.picfound = "true";
    
    # Wenn Parameter bildurl oder bildhost fehlt -> 404
    if(req.url !~ "(?i)\?.*bildhost=([^&]*)" || req.url !~ "(?i)\?.*bildurl=([^&]*)"){
        # Mindestens Einer der Parameter fehlt
        set req.http.parametersfound = "false";

        return (synth(404));
    }
    
    # bildhost ausschneiden
    set req.http.host = regsub(req.url, "(?i)\?.*bildhost=([^&]*).*", "\1");

    # Führendes slash entfernen
    set req.http.host = regsub(req.http.host, "/(.+)", "\1");

    set req.backend_hint = tinyproxy;

    # bildurl ausschneiden
    set req.url = regsub(req.url, "(?i)\?.*bildurl=([^&]*).*", "\1");
}

sub vcl_backend_response {
    # Negiert den User-Agent, da sonst für die gleiche URL mehrere cache-files angelegt werden
    unset beresp.http.Vary;
}

sub vcl_deliver {
}

sub vcl_synth {
    if(resp.status == 404){
        set resp.status = 404;
    }
}