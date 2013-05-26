var searchArray = new Array();

function deleteAll()
{
    searchArray.splice(0, searchArray.length)
}

function searchText(text)
{
    deleteAll();
    
    var sel = window.getSelection();
    var elm = document.getElementById('content');
    sel.collapse(elm, 0);
    while (window.find(text))
    {
        document.execCommand("HiliteColor", false, "yellow");
        sel.collapseToEnd();
        
        var node = sel.focusNode;
        var span = node.parentElement;
        span.setAttribute("class","MyAppHighlight");
        window.location.href="cmd:scrollWindow@parameter&" + span.nodeName;
        searchArray.push(span);
    }
    window.location.href="cmd:scrollWindow@parameter&" + searchArray.length;
    return searchArray.length;
}

function showElement(index)
{
    var subNode = searchArray[index];
    window.location.href="cmd:scrollWindow@parameter&" + subNode.nodeName;
    subNode.scrollIntoView();
}

function removedHighlights()
{
    var elm = document.getElementById('content');
    removeAllHighlightsForElement(elm);
    
    deleteAll();
}

function removeAllHighlightsForElement(element) {
    if (element) {
        if (element.nodeType == 1) {
            
            if (element.getAttribute("class") == "MyAppHighlight") {
                var text = element.removeChild(element.firstChild);
                
                element.parentNode.insertBefore(text,element);
                element.parentNode.removeChild(element);
                return true;
            } else {
                var normalize = false;
                for (var i=element.childNodes.length-1; i>=0; i--)
                {
                    var childNode = element.childNodes[i];
                    if (removeAllHighlightsForElement(childNode)) {
                        normalize = true;
                    }
                }
                if (normalize) {
                    element.normalize();
                }
            }
        }
    }
    return false;
}
