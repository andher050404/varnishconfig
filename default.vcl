vcl 4.0;
import std;

# Auflistung der zu chachenden backend-server.
backend otto {
    .host = "dabappx.ov.otto.de";
}

backend laudert {
    .host = "rfp.laudert.de";
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
    if(req.url !~ "(?i)\?.*bildurl=([^&]*)" || req.url !~ "(?i)\?.*bildhost=([^&]*)"){
        # Mindestens Einer der Parameter fehlt
        set req.http.parametersfound = "false";

        return (synth(404));
    }

    # Parameter korrekt gefunden
    set req.http.parametersfound = "true";

    if (req.http.picfound == "true" && req.http.parametersfound == "true") {
        # bildhost ausschneiden
        set req.http.hostparam = regsub(req.url, "(?i)\?.*bildhost=([^&]*).*", "\1");

        # Führendes slash entfernen
        set req.http.hostparam = regsub(req.http.hostparam, "/(.+)", "\1");

        # Initial kein Backendserver gesetzt
        set req.http.backendset = "false";

        # Hier nacheinander die Backend-Server auflisten
        if(req.http.hostparam=="dabappx.ov.otto.de"){
            # bildhost ist otto
            set req.backend_hint = otto;
            set req.http.backendset = "true";
        }

        if(req.http.hostparam=="rfp.laudert.de"){
            # bildhost ist otto
            set req.backend_hint = laudert;
            set req.http.backendset = "true";
        }
        
        # Keinen kpnfigurierten Backendserver gefunden
        if(req.http.backendset == "false"){
            return (synth(404));
        }

        # bildurl ausschneiden
        set req.url = regsub(req.url, "(?i)\?.*bildurl=([^&]*).*", "\1");
    }
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