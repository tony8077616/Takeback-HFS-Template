
[sym-preview]
<script>
var noticedpreview = false;
var givetofais = false;
// Previewing: Core script
function _previewfile(url) {
    var fileurl = decodeURI(url);
    var filename = spliturllast(fileurl);
    // Judge the file type
    var filetype = 'unknown';
    switch (url.slice(-4).toLowerCase()) {
        case '.png': case '.jpg': case 'jpeg':
        case '.gif': case 'webp': case '.ico':
            filetype = 'image';
            break;
        case '.txt': case 'html': case '.htm':
            filetype = 'text';
            break;
        case '.mp3': case '.m4a':
        case '.wav': case '.ogg': // '.ogg' can be an audio and/or video.
            filetype = 'audio';
            break;
        case '.mp4': case 'webm':
        case '.ogv':    // Name an '.ogg' as '.ogv' to view as a video here.
            filetype = 'video';
            break;
        case '.swf':
            filetype = 'flash';
            break;
        case '.rtf':
        case '.doc': case 'docx': case '.odt':
        case '.xls': case 'xlsx': case '.ods':
        case '.ppt': case 'pptx': case '.odp':
            filetype = 'workdocument';
            break;
        default:
            filetype = 'unknown';
            break;
    }
    // Define the preview content
    previewcontent = '';
    switch (filetype) {
        case 'image':
            previewcontent = '{.!Tap photo to start a slideshow; Right-click/Long-press to save.}&nbsp;<br />\
                <a href="javascript: slideshow(\'?start\')"><img class="previewimg" id="previewobject" src="'+fileurl+'" /></a><br />';
            break;
        case 'audio':
            previewcontent = '<audio controls loop autoplay><source src="'+fileurl+'">\
                {.!Sorry, previewing this file is not sopported by your browser.}</audio><br />\
                <a href="javascript: previewfile(\'?fais\', \''+fileurl+'\')"><span style="color: wheat">[{.!Move to mini player.}]</span>&nbsp;</a>';
            break;
        case 'video':
            previewcontent = '{.!Rotate your device to fullscreen if mobile.}<br />\
                <video controls loop autoplay class="previewvid" id="previewobject"><source src="'+fileurl+'">\
                {.!Sorry, previewing this file is not sopported by your browser.}</video><br />';
            break;
        case 'text':
            previewcontent = '<iframe class="previewiframe" id="previewobject" src="'+fileurl+'">\
                {.!Previewing not supported, please try dowload.}</iframe><br />';
            break;
        case 'flash':
            previewcontent = '{.!Enable flash plug-in in your browser/site settings to view.}&nbsp;<br />\
                {.!Mobile platforms will not support flash anymore.}&nbsp;<br />\
                <embed class="previewflashobject" id="previewobject" src="'+fileurl+'" type="application/x-shockwave-flash" />\
                <div><a class="previewflashfullscreenexit" href="javascript: previewfile(\'?flashfullscreenexit\');"><abbr title="{.!Exit Fullscreen.}">[X]</abbr></a></div>\
                <br /><a href="javascript: previewfile(\'?flashfullscreen\')">[{.!Tap here to fullscreen.}]&nbsp;</a>';
            break;
        case 'workdocument':
            previewcontent = ( url.indexOf('127.0.0')<0 && url.indexOf('192.168')<0 && url.indexOf('localhost')<0 ?     // If no local IP/hostnames in location
                '{.!You can preview this document with Microsoft Office Online service.}<br />\
                    <a href="https://view.officeapps.live.com/op/view.aspx?src='+url+'" target="_blank"><span style="color: wheat" >[{.!View online.}]</span> </a>' : 
                '{.!Unable to view online: this site is in LAN.}<br />' );
            break;
        default:
            previewcontent = '<span style="color: yellow">{.!Previewing not supported, please try dowload.}</span>&nbsp;<br />';
            break;
    }
    previewcontent += '<a href="'+filename+'" onclick="previewfile(\'?download\', \''+filename+'\');"><span style="color: cyan">[{.!Tap here to download.}]</span>&nbsp;</a>'
    if (filetype=='audio' && givetofais==true) {
        previewfile('?fais', url);
    } else {
        previewtip.innerHTML = spliturllast(fileurl);   // spliturllast() in "addon.pre"
        preview.innerHTML = previewcontent;
        previewfile('?show');
    }
    console.log('%c\nPreviewing file:\n'+fileurl+'\nIts type is '+filetype, 'color: teal;');
    if (!noticedpreview && filetype!='unknown') {
        notice('{.!Slide up the screen to see if using a mobile.}', '{.!Preview Opened.}');
        noticedpreview = true;
    }
}

// Previewing: Shell script
function previewfile (ctrl, url) {
    switch (ctrl) {
        case '?show':
            $('.preview').slideDown(); $('#previewopen').slideUp(); break;
        case '?open':
            _previewfile(url); break;
        case '?close':
            $('.preview').slideUp(); $('#previewopen').slideDown(); break;
        case '?download':
            window.location.href = url; 
            notice(url, '{.!Starting Download.}: '+decodeURI(url));
            break;
        case '?fais':
            if (document.querySelector('audio')!=null) document.querySelector('audio').pause();
            fais('?play', url); previewfile('?close');
            givetofais = true;
            break;
        // For flash. Though this thing is dying, but there are still mini-games come with flash
        case '?flashfullscreen':
            $('.previewflashobject').addClass('flashfullpaged');
            $('.previewflashfullscreenexit').fadeIn();
            notice('{.!Exit by tapping the [X].} =>', '{.!Fullscreened.}');
            break;
        case '?flashfullscreenexit':
            $('.previewflashobject').removeClass('flashfullpaged');
            $('.previewflashfullscreenexit').fadeOut();
            break;
        default:
            previewfile('?open', url);
    }
}
previewfile('?show');
</script>
